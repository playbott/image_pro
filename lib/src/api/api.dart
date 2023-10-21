import 'dart:typed_data';

import 'package:image_pro/src/api/consts.dart';

import '../image/encode.dart';

class ImagePro {}

class Encoder {
  static Future<Uint8List?> toJPEG(Uint8List fileBytes, {int? quality}) {
    return ImageProEncoder.toJPEG(
        fileBytes, quality ?? EncodeParameters.jpegQuality);
  }
}
