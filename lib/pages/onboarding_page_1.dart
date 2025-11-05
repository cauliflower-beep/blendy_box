import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// 引导页（第 1 页）：导入本地 Blend 文件
///
/// 对应原型结构：
/// - 顶部右侧「跳过」文本按钮；
/// - 中部圆形图标容器（蓝色浅背景），图标使用文件相关符号；
/// - 标题、副标题文本；
/// - 底部三枚圆点，第一枚突出表示当前页；
///
/// 实现要点：
/// - 使用 ThemeExtension 的间距令牌（AppSpacing），避免在页面里硬编码数值；
/// - 颜色从 ColorScheme/主色派生，避免直接写色值；
class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          // 原型 p-8 ≈ 32，这里用 xl(24)+sm(8) 组合保证不硬编码
          padding: EdgeInsets.all(spacing.xl + spacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 顶部栏：右侧「跳过」文本按钮
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text(
                      '跳过',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),

              // 内容区：圆形图标、标题与副标题
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.file_open, // 近似原型的文件导入符号
                      color: colorScheme.primary,
                      size: 48,
                    ),
                  ),
                  SizedBox(height: spacing.xl + spacing.sm),
                  Text(
                    '导入本地Blend文件',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: 24, // 原型 text-2xl
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: spacing.md),
                  Text(
                    '直接打开手机里的.blend格式文件，无需转换',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),

              // 底部页码圆点：当前页突出显示
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(color: colorScheme.primary),
                  SizedBox(width: spacing.xs + 2),
                  _Dot(color: colorScheme.primary.withOpacity(0.25)),
                  SizedBox(width: spacing.xs + 2),
                  _Dot(color: colorScheme.primary.withOpacity(0.25)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}