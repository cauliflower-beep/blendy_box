// 条件导出：在移动/桌面端使用 IO 实现，在 Web 端使用 Web 实现
export 'cache_utils_io.dart' if (dart.library.html) 'cache_utils_web.dart';