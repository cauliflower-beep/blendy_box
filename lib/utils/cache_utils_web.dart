import 'dart:async';

class CacheUtils {
  // Web 端无法访问本地文件系统缓存，返回 0
  static Future<int> computeCacheSize() async => 0;
  static Future<int> clearCache() async => 0;
}