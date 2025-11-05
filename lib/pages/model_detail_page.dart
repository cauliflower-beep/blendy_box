import 'package:flutter/material.dart';
import '../theme/design_tokens.dart';

/// 模型详情页（参考原型：9. 模型详情页）
/// - 展示模型基础信息与占位的高级信息（材质/纹理/动画/统计）
class ModelDetailPage extends StatelessWidget {
  final String title;
  final String src;
  final int? sizeBytes;
  final DateTime? openedAt;

  const ModelDetailPage({
    super.key,
    required this.title,
    required this.src,
    this.sizeBytes,
    this.openedAt,
  });

  String _humanSize(int? bytes) {
    if (bytes == null) return '未知';
    if (bytes < 1024) return '$bytes B';
    final kb = bytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)}KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(2)}MB';
  }

  String _fmtDate(DateTime? dt) {
    if (dt == null) return '未知';
    String two(int n) => n < 10 ? '0$n' : '$n';
    return '${dt.year}-${two(dt.month)}-${two(dt.day)}';
  }

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
            children: [
              // 顶部导航栏
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.arrow_back, color: cs.primary),
                  ),
                  Text('模型详情', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 48),
                ],
              ),

              SizedBox(height: spacing.md),

              Expanded(
                child: ListView(
                  children: [
                    // 基础信息
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('基础信息', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: spacing.sm),
                            _kv(theme, '名称', title),
                            _kv(theme, '格式', _inferFormat(src)),
                            _kv(theme, '大小', _humanSize(sizeBytes)),
                            _kv(theme, '来源', src),
                            _kv(theme, '最近打开', _fmtDate(openedAt)),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: spacing.sm),

                    // 材质信息（占位）
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('材质', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: spacing.xs),
                            Text('暂未解析', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: spacing.sm),

                    // 纹理信息（占位）
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('纹理', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: spacing.xs),
                            Text('暂未解析', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: spacing.sm),

                    // 动画信息（占位）
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('动画', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: spacing.xs),
                            Text('暂未解析', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                          ],
                        ),
                      ),
                    ),

                    SizedBox(height: spacing.sm),

                    // 模型统计（占位）
                    Card(
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('模型统计', style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold)),
                            SizedBox(height: spacing.xs),
                            Text('顶点/面/节点数量暂未解析', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7))),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _inferFormat(String path) {
    final lower = path.toLowerCase();
    final ext = lower.split('.').isNotEmpty ? lower.split('.').last : '';
    return ext.isEmpty ? '未知' : ext;
  }

  Widget _kv(ThemeData theme, String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(k, style: theme.textTheme.bodyMedium)),
          Expanded(child: Text(v, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)))),
        ],
      ),
    );
  }
}