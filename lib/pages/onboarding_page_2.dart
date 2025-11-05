import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// 引导页（第 2 页）：3D模型实时预览
class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

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
                    decoration: BoxDecoration(color: cs.secondary.withOpacity(0.12), shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Icon(Icons.threed_rotation, color: cs.secondary, size: 48),
                  ),
                  SizedBox(height: spacing.xl + spacing.sm),
                  Text('3D模型实时预览',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(fontSize: 24, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  SizedBox(height: spacing.md),
                  Text('高清展示模型细节，支持多角度查看',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Dot(color: cs.primary.withOpacity(0.25)),
                  SizedBox(width: spacing.xs + 2),
                  _Dot(color: cs.primary),
                  SizedBox(width: spacing.xs + 2),
                  _Dot(color: cs.primary.withOpacity(0.25)),
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
    return Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle));
  }
}