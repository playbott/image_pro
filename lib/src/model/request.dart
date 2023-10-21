import 'dart:typed_data';

class Request {
  Uint8List bytes;
  dynamic Function(Uint8List data)? function;
  Request({
    required this.bytes,
    required this.function});
}

class Response {
  final int mAddress;
  final int mLength;
  final int errorCode;
  Response({required this.mAddress, required this.mLength, required this.errorCode});
}
