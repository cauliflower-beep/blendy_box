import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: cs.primary)),
                  Text('帮助中心', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 48),
                ],
              ),
              SizedBox(height: spacing.lg),
              Text('常见问题', style: theme.textTheme.titleMedium),
              SizedBox(height: spacing.sm),
              const Text('· 如何导入GLB/GLTF文件？通过首页的“选择文件”按钮。'),
              const Text('· 模型预览失败怎么办？请检查文件是否损坏或格式是否支持。'),
              const Text('· 如何切换主题？设置页 -> 主题设置。'),
              SizedBox(height: spacing.lg),
              Text('使用指南', style: theme.textTheme.titleMedium),
              SizedBox(height: spacing.sm),
              const Text('从首页选择模型 -> 进入预览 -> 查看详情。'),
            ],
          ),
        ),
      ),
    );
  }
}