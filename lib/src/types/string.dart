import 'dart:ffi' as ffi;
import 'dart:typed_data' as td;
import 'dart:convert';
import 'package:ffi/ffi.dart' show StringUtf8Pointer;

extension StringExtension on String {
  ffi.Pointer<ffi.Char> toC() {
    return toNativeUtf8().cast<ffi.Char>();
  }

  td.Uint8List toUint8List() {
    List<int> intList = utf8.encode(this);
    return td.Uint8List.fromList(intList);
  }
}
