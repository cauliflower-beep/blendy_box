import 'package:flutter/material.dart';
import 'design_tokens.dart';

/// 应用主题集中定义
///
/// - 暴露浅色/深色主题入口：AppTheme.light / AppTheme.dark
/// - 统一配置按钮、卡片、标签页、文字与滚动行为
/// - 通过 ThemeExtension 注入非 Material 的设计令牌（圆角、阴影、间距）
class AppTheme {
  /// 浅色主题（参考原型的全局样式）
  static ThemeData light() {
    const seed = AppPalette.primary;
    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.light).copyWith(
      background: AppPalette.backgroundLight,
      surface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppPalette.backgroundLight,
      fontFamily: 'Roboto', // 原型中提到 Inter/Arial；移动端默认 Roboto 可用

      // 主按钮（btn-primary）
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            // 悬停/按下时略深一些
            final base = colorScheme.primary;
            if (states.contains(MaterialState.hovered) || states.contains(MaterialState.pressed)) {
              return HSLColor.fromColor(base).withLightness(0.45).toColor();
            }
            return base;
          }),
          foregroundColor: MaterialStateProperty.all(Colors.white),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.light.button)),
          ),
          textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          elevation: const MaterialStatePropertyAll(0),
        ),
      ),

      // 次按钮（btn-secondary）
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: const MaterialStatePropertyAll(AppPalette.secondaryBgLight),
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
          side: const MaterialStatePropertyAll(BorderSide(color: AppPalette.secondaryBorderLight)),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.light.button)),
          ),
          textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),

      // 卡片主题（接近原型的阴影与圆角）
      cardTheme: CardThemeData(
        color: Colors.white,
        shadowColor: AppShadows.light.cardShadowColor,
        elevation: AppShadows.light.cardElevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.light.card)),
        clipBehavior: Clip.antiAlias,
      ),

      // Tab 样式（tab-active：蓝色下划线）
      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 3),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14),
        bodyLarge: TextStyle(fontSize: 16),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),

      // 注入设计令牌扩展
      extensions: const [
        AppRadii.light,
        AppShadows.light,
        AppSpacing.light,
      ],
    );
  }

  /// 深色主题（颜色与阴影做适配）
  static ThemeData dark() {
    const seed = AppPalette.primary;
    final colorScheme = ColorScheme.fromSeed(seedColor: seed, brightness: Brightness.dark);

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: const Color(0xFF0F1623), // 深色下更深背景，便于对比
      fontFamily: 'Roboto',

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            final base = colorScheme.primary;
            if (states.contains(MaterialState.hovered) || states.contains(MaterialState.pressed)) {
              return HSLColor.fromColor(base).withLightness(0.55).toColor();
            }
            return base;
          }),
          foregroundColor: const MaterialStatePropertyAll(Colors.white),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.dark.button)),
          ),
          textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
          elevation: const MaterialStatePropertyAll(0),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(colorScheme.surface.withOpacity(0.12)),
          foregroundColor: MaterialStateProperty.all(colorScheme.primary),
          side: MaterialStatePropertyAll(BorderSide(color: colorScheme.primary.withOpacity(0.3))),
          padding: const MaterialStatePropertyAll(EdgeInsets.symmetric(vertical: 12, horizontal: 24)),
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.dark.button)),
          ),
          textStyle: const MaterialStatePropertyAll(TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),

      cardTheme: CardThemeData(
        color: colorScheme.surface,
        shadowColor: AppShadows.dark.cardShadowColor,
        elevation: AppShadows.dark.cardElevation,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadii.dark.card)),
        clipBehavior: Clip.antiAlias,
      ),

      tabBarTheme: TabBarThemeData(
        labelColor: colorScheme.primary,
        unselectedLabelColor: colorScheme.onSurface.withOpacity(0.7),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(color: colorScheme.primary, width: 3),
        ),
        labelStyle: const TextStyle(fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: true,
      ),

      textTheme: const TextTheme(
        bodyMedium: TextStyle(fontSize: 14),
        bodyLarge: TextStyle(fontSize: 16),
        titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),

      extensions: const [
        AppRadii.dark,
        AppShadows.dark,
        AppSpacing.dark,
      ],
    );
  }
}

/// 自定义滚动行为：移除越界的水波/回弹效果（近似原型隐藏滚动条/避免滚动干扰）。
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child; // 不显示任何 overscroll 指示器
  }
}