import 'package:flutter/material.dart';
import 'dart:ui' show lerpDouble;

/// 全局设计令牌（Design Tokens）与 ThemeExtensions
///
/// 目标：
/// - 集中管理颜色、圆角、阴影、间距等“非组件”级样式常量；
/// - 避免在页面里硬编码样式值，改为通过主题或扩展统一取值；
/// - 为后续主题切换（浅色/深色、自定义品牌主题）打下基础。

/// 圆角令牌：用来统一控制圆角尺寸（比如按钮、卡片、容器）。
class AppRadii extends ThemeExtension<AppRadii> {
  final double phone; // 类似原型里的 phone 外壳圆角
  final double card; // 卡片圆角
  final double button; // 按钮圆角

  const AppRadii({
    required this.phone,
    required this.card,
    required this.button,
  });

  @override
  AppRadii copyWith({double? phone, double? card, double? button}) {
    return AppRadii(
      phone: phone ?? this.phone,
      card: card ?? this.card,
      button: button ?? this.button,
    );
  }

  @override
  ThemeExtension<AppRadii> lerp(ThemeExtension<AppRadii>? other, double t) {
    if (other is! AppRadii) return this;
    return AppRadii(
      phone: lerpDouble(phone, other.phone, t)!,
      card: lerpDouble(card, other.card, t)!,
      button: lerpDouble(button, other.button, t)!,
    );
  }

  /// 默认浅色主题下的圆角尺寸，参考原型：36（容器）、16（卡片）、24（按钮）
  static const light = AppRadii(phone: 36, card: 16, button: 24);
  /// 深色主题通常保持同一几何尺寸（也可以按需调整）。
  static const dark = AppRadii(phone: 36, card: 16, button: 24);
}

/// 阴影令牌：控制卡片等组件的阴影颜色与强度。
class AppShadows extends ThemeExtension<AppShadows> {
  final Color cardShadowColor; // 卡片阴影颜色（略带品牌色调）
  final double cardElevation; // 卡片海拔（Material 阴影强度）

  const AppShadows({
    required this.cardShadowColor,
    required this.cardElevation,
  });

  @override
  AppShadows copyWith({Color? cardShadowColor, double? cardElevation}) {
    return AppShadows(
      cardShadowColor: cardShadowColor ?? this.cardShadowColor,
      cardElevation: cardElevation ?? this.cardElevation,
    );
  }

  @override
  ThemeExtension<AppShadows> lerp(ThemeExtension<AppShadows>? other, double t) {
    if (other is! AppShadows) return this;
    return AppShadows(
      cardShadowColor: Color.lerp(cardShadowColor, other.cardShadowColor, t)!,
      cardElevation: lerpDouble(cardElevation, other.cardElevation, t)!,
    );
  }

  /// 原型中的卡片阴影带轻微蓝色调，这里用半透明主色近似。
  static const light = AppShadows(
    cardShadowColor: Color(0x144A90E2), // 0x14 = ~8% 透明度
    cardElevation: 4,
  );

  static const dark = AppShadows(
    cardShadowColor: Color(0x224A90E2), // 深色下略强化阴影
    cardElevation: 6,
  );
}

/// 间距令牌：统一页面间距（避免在代码里散落 magic number）。
class AppSpacing extends ThemeExtension<AppSpacing> {
  final double xs; // 4
  final double sm; // 8
  final double md; // 12
  final double lg; // 16
  final double xl; // 24

  const AppSpacing({
    required this.xs,
    required this.sm,
    required this.md,
    required this.lg,
    required this.xl,
  });

  @override
  AppSpacing copyWith({double? xs, double? sm, double? md, double? lg, double? xl}) {
    return AppSpacing(
      xs: xs ?? this.xs,
      sm: sm ?? this.sm,
      md: md ?? this.md,
      lg: lg ?? this.lg,
      xl: xl ?? this.xl,
    );
  }

  @override
  ThemeExtension<AppSpacing> lerp(ThemeExtension<AppSpacing>? other, double t) {
    if (other is! AppSpacing) return this;
    return AppSpacing(
      xs: lerpDouble(xs, other.xs, t)!,
      sm: lerpDouble(sm, other.sm, t)!,
      md: lerpDouble(md, other.md, t)!,
      lg: lerpDouble(lg, other.lg, t)!,
      xl: lerpDouble(xl, other.xl, t)!,
    );
  }

  static const light = AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
  static const dark = AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
}

/// 一些基础颜色常量（可用于 ThemeData 的色板构建）。
class AppPalette {
  // 原型主色：#4A90E2（蓝色）
  static const Color primary = Color(0xFF4A90E2);
  // 浅色背景：#f0f8ff（Azure）
  static const Color backgroundLight = Color(0xFFF0F8FF);
  // 次按钮（btn-secondary）背景：#f5f7fa
  static const Color secondaryBgLight = Color(0xFFF5F7FA);
  // 次按钮边框：#E3F2FD
  static const Color secondaryBorderLight = Color(0xFFE3F2FD);
}