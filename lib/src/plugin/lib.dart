
import 'dart:ffi';
import 'dart:io';
import 'dart:math';

import '../generated/image_pro_bindings.dart';

const String _libName = 'bild';

/// The bindings to the native functions in [dyLib].
final ImageProBindings bindings = ImageProBindings(dyLib);

/// The dynamic library in which the symbols for [ImageProBindings] can be found.
final DynamicLibrary dyLib = () {
  if (Platform.isMacOS || Platform.isIOS) {
    return DynamicLibrary.open('$_libName.framework/$_libName');
  }
  if (Platform.isAndroid || Platform.isLinux) {
    try {
      return DynamicLibrary.open('lib$_libName.so');
    } catch (_) {
      final appIdAsBytes = File('/proc/self/cmdline').readAsBytesSync();
      final endOfAppId = max(appIdAsBytes.indexOf(0), 0);
      final appId = String.fromCharCodes(appIdAsBytes.sublist(0, endOfAppId));
      // final files = Directory("/data/data/$appId").listSync(recursive: true);
      return DynamicLibrary.open('/data/data/$appId/lib/lib$_libName.so');
    }
  }
  if (Platform.isWindows) {
    return DynamicLibrary.open('$_libName.dll');
  }
  throw UnsupportedError('Unknown platform: ${Platform.operatingSystem}');
}();
