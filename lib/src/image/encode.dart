import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import '../model/request.dart';
import '../plugin/caller.dart';
import '../plugin/lib.dart';
import '../types/types.dart';

class ImageProEncoder {
  static Future<Uint8List?> toJPEG(Uint8List fileBytes, int quality) async {
    final response = await Caller.invoke(Request(
        bytes: fileBytes,
        function: (Uint8List data) {
          ByteData sendData = ByteData.createByteData(uint8List: data);
          return bindings.JPEGEncode(
              sendData.pointer, sendData.length, quality);
        }));

    if (response.errorCode == -1) {
      return null;
    }

    final encodedBytes =
        TypeConverter.fromPointerAndSize(response.mAddress, response.mLength);

    return encodedBytes;
  }
}
