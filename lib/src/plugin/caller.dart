import 'dart:async';
import 'dart:isolate';
import 'package:flutter/foundation.dart';
import '../model/request.dart';

int _nextRequestId = 0;
Map<int, Completer<Response>> _requests = {};
Future<SendPort> _helperIsolateSendPort = () async {
  final Completer<SendPort> completer = Completer<SendPort>();

  final ReceivePort receivePort = ReceivePort()
    ..listen((dynamic data) {
      if (data is SendPort) {
        completer.complete(data);
        return;
      }
      if (data is Response) {
        final Completer<Response> completer = _requests[_nextRequestId]!;
        _requests.remove(_nextRequestId);
        completer.complete(Response(
            mAddress: data.mAddress,
            mLength: data.mLength,
            errorCode: data.errorCode));
        return;
      }
      throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
    });

  await Isolate.spawn((SendPort sendPort) async {
    final ReceivePort helperReceivePort = ReceivePort()
      ..listen((dynamic data) {
        if (data is Request) {
          if (data.function != null) {
            final response = data.function!(data.bytes);
            sendPort.send(Response(
                mAddress: response.r0.address,
                mLength: response.r1,
                errorCode: response.r2));
          } else {
            throw UnsupportedError('Invalid function');
          }
          return;
        }
        throw UnsupportedError('Unsupported message type: ${data.runtimeType}');
      });
    sendPort.send(helperReceivePort.sendPort);
  }, receivePort.sendPort);
  return completer.future;
}();

class Caller {
  static Future<Response> invoke(Request request) async {
    late Stopwatch stopwatch;
    if (kDebugMode) {
      stopwatch = Stopwatch()..start();
    }
    _nextRequestId++;
    final SendPort helperIsolateSendPort = await _helperIsolateSendPort;
    final Completer<Response> completer = Completer<Response>();
    _requests[_nextRequestId] = completer;
    helperIsolateSendPort.send(request);

    if (kDebugMode) {
      stopwatch.stop();

      int elapsedTime = stopwatch.elapsed.inMilliseconds <= 1000
          ? stopwatch.elapsed.inMilliseconds
          : stopwatch.elapsed.inSeconds;
      final timeStr =
          stopwatch.elapsed.inMilliseconds <= 1000 ? 'milliseconds' : 'seconds';
      print('The elapsed time: $elapsedTime $timeStr.');
    }
    return completer.future;
  }
}
