import 'package:flutter/material.dart';
import 'package:model_viewer_plus/model_viewer_plus.dart';
import '../theme/design_tokens.dart';
import 'model_detail_page.dart';

/// 3D 模型预览页（参考原型：8. 3D模型预览页）
/// - 使用 model_viewer_plus 真实预览 GLB/GLTF 模型
/// - 顶部返回 & 收藏/分享按钮；中部预览区域与操作提示；底部操作栏
class ModelViewerPage extends StatefulWidget {
  final String title;
  final String src; // 可为 assets 路径或本地文件路径
  final int? sizeBytes;
  final DateTime? openedAt;

  const ModelViewerPage({
    super.key,
    required this.title,
    required this.src,
    this.sizeBytes,
    this.openedAt,
  });

  @override
  State<ModelViewerPage> createState() => _ModelViewerPageState();
}

class _ModelViewerPageState extends State<ModelViewerPage> {
  bool _favorite = false;
  bool _fullscreen = false;
  Key _viewerKey = UniqueKey();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    return Scaffold(
      backgroundColor: cs.brightness == Brightness.dark ? const Color(0xFF0F1623) : Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            children: [
              if (!_fullscreen) _buildTopBar(theme),
              SizedBox(height: spacing.sm),
              Expanded(child: _buildViewer(theme, cs)),
              SizedBox(height: spacing.sm),
              if (!_fullscreen) _buildBottomActions(theme, cs, spacing),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme) {
    final cs = theme.colorScheme;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          style: ButtonStyle(backgroundColor: MaterialStatePropertyAll(Colors.black26)),
        ),
        Text(widget.title, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white)),
        Row(children: [
          IconButton(
            onPressed: () => setState(() => _favorite = !_favorite),
            icon: Icon(_favorite ? Icons.favorite : Icons.favorite_border, color: Colors.white),
            style: ButtonStyle(backgroundColor: const MaterialStatePropertyAll(Colors.black26)),
          ),
          SizedBox(width: 8),
          IconButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('分享功能即将支持'))),
            icon: const Icon(Icons.share, color: Colors.white),
            style: ButtonStyle(backgroundColor: const MaterialStatePropertyAll(Colors.black26)),
          ),
        ])
      ],
    );
  }

  Widget _buildViewer(ThemeData theme, ColorScheme cs) {
    return Stack(
      alignment: Alignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.blue.shade900.withOpacity(0.3),
                  Colors.grey.shade800,
                ],
              ),
            ),
            child: ModelViewer(
              key: _viewerKey,
              src: widget.src,
              autoRotate: true,
              cameraControls: true,
              ar: false,
              backgroundColor: Colors.transparent,
            ),
          ),
        ),
        Positioned(
          bottom: 24,
          child: Container(
            decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(24)),
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: const Row(
              children: [
                Icon(Icons.pan_tool, color: Colors.white, size: 16),
                SizedBox(width: 6),
                Text('单指旋转 | 双指缩放 | 长按平移', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(ThemeData theme, ColorScheme cs, AppSpacing spacing) {
    Widget _action(IconData icon, String label, VoidCallback onTap, {Color? color}) {
      return Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: (color ?? Colors.white).withOpacity(0.6)),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color ?? Colors.white),
            ),
          ),
          SizedBox(height: spacing.xs),
          Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white)),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _action(Icons.refresh, '重置视角', _resetView),
        _action(Icons.fullscreen, '全屏', () => setState(() => _fullscreen = true)),
        _action(
          Icons.info,
          '模型详情',
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ModelDetailPage(
                title: widget.title,
                src: widget.src,
                sizeBytes: widget.sizeBytes,
                openedAt: widget.openedAt,
              ),
            ),
          ),
          color: cs.primary,
        ),
        _action(Icons.download, '导出', () => ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('导出功能即将支持')))),
      ],
    );
  }

  void _resetView() {
    // 通过重新创建 viewer key 来重置视角
    setState(() {
      _viewerKey = UniqueKey();
    });
  }
}