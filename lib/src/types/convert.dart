import 'dart:ffi' as ffi;
import 'dart:typed_data' as td;
import 'package:ffi/ffi.dart' show calloc;
import 'dart:io' as io;

class ByteData {
  ByteData({required this.pointer, required this.length});
  final ffi.Pointer<ffi.Void> pointer;
  final int length;

  factory ByteData.createByteData({required td.Uint8List uint8List}) {
    late ffi.Pointer<ffi.Uint8> ptr;
    WeakReference<td.Uint8List> weakReferenceData = WeakReference(uint8List);

    final sendData = weakReferenceData.target;

    if (sendData != null) {
      ptr = TypeConverter.castToC(data: sendData);
    } else {
      throw Exception('byte conversion error');
    }

    return ByteData(
        pointer: ffi.Pointer.fromAddress(ptr.address),
        length: weakReferenceData.target!.lengthInBytes);
  }
}

class TypeConverter {
  static ffi.Pointer<ffi.Uint8> castToC({required td.Uint8List data}) {
    ffi.Pointer<ffi.Uint8> ptr = calloc<ffi.Uint8>(data.length);
    for (int i = 0; i < data.length; i++) {
      ptr[i] = data[i];
    }
    return ptr;
  }

  static ffi.Pointer<ffi.Uint8> castToCFRomList({required List<int> data}) {
    return castToC(data: td.Uint8List.fromList(data));
  }

  static td.Uint8List fromPointerAndSize(int address, int size) {
    final charPointer = ffi.Pointer<ffi.Char>.fromAddress(address);
    final uint8List = td.Uint8List(size);
    for (var i = 0; i < size; i++) {
      uint8List[i] = charPointer[i];
    }
    return uint8List;
  }

  static Future<td.Uint8List> getByteDataFromFile(String filePath) async {
    final file = io.File(filePath);
    return file.readAsBytes();
  }
}
