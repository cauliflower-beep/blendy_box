import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// 引导页（第 3 页）：灵活操作模型 + CTA
class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.xl + spacing.sm),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text('跳过', style: theme.textTheme.bodyMedium?.copyWith(color: cs.primary, fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(color: cs.tertiary.withOpacity(0.12), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(Icons.pan_tool_alt, color: cs.tertiary, size: 48),
                  ),
                  SizedBox(height: spacing.xl + spacing.sm),
                  Text('灵活操作模型',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  SizedBox(height: spacing.md),
                  Text('旋转、缩放、平移，轻松掌控你的3D模型',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
              // CTA 按钮：立即体验
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/home');
                      },
                      child: const Text('立即体验'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}