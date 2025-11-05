import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/design_tokens.dart';

/// Web 平台的占位页：
/// - 浏览本地目录在 Web 不可用；提供与系统文件选择兼容的替代方案
/// - 用户可在此页选择 GLB/GLTF 文件并返回
class FileBrowserPage extends StatefulWidget {
  const FileBrowserPage({super.key});

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> {
  List<PlatformFile> _picked = [];
  bool _loading = false;

  Future<void> _pickFiles() async {
    setState(() => _loading = true);
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['glb', 'gltf'],
        allowMultiple: true,
        withData: true,
      );
      if (result == null) {
        setState(() => _loading = false);
        return;
      }
      setState(() {
        _picked = result.files;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('选择文件失败：$e')));
      }
    }
  }

  void _confirmImport() {
    if (_picked.isEmpty) return;
    // 在 Web 上没有路径，仅返回占位的文件名列表给上层做模型条目添加
    final names = _picked.map((f) => f.name).toList();
    Navigator.pop(context, names);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Icons.arrow_back, color: cs.primary)),
                  Text('选择文件', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  TextButton(onPressed: () => Navigator.pop(context), child: Text('取消', style: TextStyle(color: cs.primary))),
                ],
              ),
              SizedBox(height: spacing.md),
              Container(
                padding: EdgeInsets.all(spacing.md),
                decoration: BoxDecoration(color: cs.primary.withOpacity(0.06), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.info, color: Colors.blue),
                    SizedBox(width: spacing.sm),
                    Expanded(
                      child: Text(
                        'Web 暂不支持选择目录。你可以在此页选择 GLB/GLTF 文件进行导入。',
                        style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.8)),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacing.md),

              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.separated(
                        itemCount: _picked.length,
                        separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                        itemBuilder: (context, i) {
                          final f = _picked[i];
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.view_in_ar, color: cs.primary),
                              title: Text(f.name),
                              subtitle: Text('${(f.size / (1024 * 1024)).toStringAsFixed(2)}MB'),
                            ),
                          );
                        },
                      ),
              ),
              SizedBox(height: spacing.md),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _pickFiles,
                      icon: const Icon(Icons.file_open),
                      label: const Text('选择 GLB/GLTF 文件'),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _picked.isEmpty ? null : _confirmImport,
                      child: const Text('导入选中文件'),
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