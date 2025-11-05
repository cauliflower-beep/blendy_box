import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// 启动页（参考原型「1. 启动页」）
///
/// 设计要点：
/// - 中心图标圆形背景（主色）；
/// - 标题与副标题以主题色系展示；
/// - 底部三个小圆点做轻微的脉冲动画；
/// - 使用 ThemeExtension 的 spacing，避免硬编码间距；
class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    return Scaffold(
      // 背景使用从浅蓝到白色的线性渐变，贴近原型的 from-blue-100 to-white
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.primary.withOpacity(0.12),
              Colors.white,
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 圆形图标容器
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Icons.view_in_ar, // 3D/AR 相关图标，近似原型的立方体
                  color: Colors.white,
                  size: 40,
                ),
              ),
              SizedBox(height: spacing.lg + spacing.sm),
              // 标题
              Text(
                'Blender 3D Viewer',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF1E3A8A), // 接近原型 text-blue-800
                ),
              ),
              SizedBox(height: spacing.xs),
              // 副标题
              Text(
                '你的3D模型随身看',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary.withOpacity(0.8),
                ),
              ),
              SizedBox(height: spacing.xl),
              // 三个脉冲圆点
              const _PulseDots(),
            ],
          ),
        ),
      ),
    );
  }
}

/// 三个轻微脉冲动画圆点，延时错位以形成流动感
class _PulseDots extends StatelessWidget {
  const _PulseDots();

  @override
  Widget build(BuildContext context) {
    final spacing = Theme.of(context).extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
    final primary = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _PulseDot(color: primary.withOpacity(0.6), delay: const Duration(milliseconds: 0)),
        SizedBox(width: spacing.xs + 2),
        _PulseDot(color: primary.withOpacity(0.6), delay: const Duration(milliseconds: 200)),
        SizedBox(width: spacing.xs + 2),
        _PulseDot(color: primary.withOpacity(0.6), delay: const Duration(milliseconds: 400)),
      ],
    );
  }
}

class _PulseDot extends StatefulWidget {
  const _PulseDot({required this.color, required this.delay});

  final Color color;
  final Duration delay;

  @override
  State<_PulseDot> createState() => _PulseDotState();
}

class _PulseDotState extends State<_PulseDot> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _scale = Tween(begin: 0.9, end: 1.15).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _opacity = Tween(begin: 0.6, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    // 延时启动，形成错位动画效果
    Future.delayed(widget.delay, () {
      if (mounted) {
        _controller.repeat(reverse: true);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _opacity.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle),
            ),
          ),
        );
      },
    );
  }
}