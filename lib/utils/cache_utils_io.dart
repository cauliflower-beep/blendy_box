import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheUtils {
  static Future<int> computeCacheSize() async {
    int total = 0;
    try {
      final tempDir = await getTemporaryDirectory();
      total += await _dirSize(tempDir);
    } catch (_) {}
    try {
      final supportDir = await getApplicationSupportDirectory();
      total += await _dirSize(supportDir);
    } catch (_) {}
    return total;
  }

  static Future<int> clearCache() async {
    int freed = 0;
    try {
      final tempDir = await getTemporaryDirectory();
      freed += await _clearDir(tempDir);
    } catch (_) {}
    try {
      final supportDir = await getApplicationSupportDirectory();
      freed += await _clearDir(supportDir);
    } catch (_) {}
    return freed;
  }

  static Future<int> _dirSize(Directory dir) async {
    int size = 0;
    if (!await dir.exists()) return 0;
    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          try {
            final len = await entity.length();
            size += len;
          } catch (_) {}
        }
      }
    } catch (_) {}
    return size;
  }

  static Future<int> _clearDir(Directory dir) async {
    int freed = 0;
    if (!await dir.exists()) return 0;
    try {
      await for (final entity in dir.list(recursive: true, followLinks: false)) {
        try {
          if (entity is File) {
            final len = await entity.length();
            await entity.delete();
            freed += len;
          } else if (entity is Directory) {
            await entity.delete(recursive: true);
          }
        } catch (_) {}
      }
    } catch (_) {}
    return freed;
  }
}