// Conditional export to provide platform-specific implementations without breaking web builds.
// On non-web (IO) platforms, use the real directory browser; on web, use a stub page.
export 'file_browser_page_io.dart' if (dart.library.html) 'file_browser_page_web.dart';