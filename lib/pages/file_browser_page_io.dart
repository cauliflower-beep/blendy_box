import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../theme/design_tokens.dart';

/// 目录浏览页（非 Web 平台）：
/// - 支持选择一个目录
/// - 仅展示该目录下的 GLB/GLTF 文件与子目录
/// - 支持进入子目录浏览
/// - 选择单个文件并返回其绝对路径列表（当前为单选）
class FileBrowserPage extends StatefulWidget {
  const FileBrowserPage({super.key});

  @override
  State<FileBrowserPage> createState() => _FileBrowserPageState();
}

class _FileBrowserPageState extends State<FileBrowserPage> {
  String? _currentPath;
  bool _loading = false;
  List<FileSystemEntity> _entries = [];
  String? _selectedFilePath;

  @override
  void initState() {
    super.initState();
    // 初次进入，可让用户选择目录
  }

  Future<void> _chooseDirectory() async {
    try {
      final path = await FilePicker.platform.getDirectoryPath(dialogTitle: '选择文件夹');
      if (path == null) return;
      setState(() {
        _currentPath = path;
      });
      await _loadDirectory(path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('选择目录失败：$e')));
      }
    }
  }

  Future<void> _loadDirectory(String path) async {
    setState(() {
      _loading = true;
      _entries = [];
      _selectedFilePath = null;
    });
    try {
      final dir = Directory(path);
      final items = <FileSystemEntity>[];
      final stream = dir.list(recursive: false, followLinks: false);
      await for (final entity in stream) {
        if (entity is Directory) {
          items.add(entity);
        } else if (entity is File) {
          final lower = entity.path.toLowerCase();
          final ext = lower.split('.').isNotEmpty ? lower.split('.').last : '';
          if (ext == 'glb' || ext == 'gltf') {
            items.add(entity);
          }
        }
      }
      items.sort((a, b) {
        final aIsDir = a is Directory;
        final bIsDir = b is Directory;
        if (aIsDir && !bIsDir) return -1;
        if (!aIsDir && bIsDir) return 1;
        return a.path.toLowerCase().compareTo(b.path.toLowerCase());
      });
      setState(() {
        _entries = items;
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('读取目录失败：$e')));
      }
    }
  }

  void _enterDirectory(Directory dir) async {
    final path = dir.path;
    setState(() => _currentPath = path);
    await _loadDirectory(path);
  }

  void _goUp() async {
    if (_currentPath == null) return;
    final parent = Directory(_currentPath!).parent;
    setState(() => _currentPath = parent.path);
    await _loadDirectory(parent.path);
  }

  void _toggleSelectFile(String path) {
    setState(() {
      _selectedFilePath = _selectedFilePath == path ? null : path;
    });
  }

  void _confirmImport() {
    final selected = _selectedFilePath;
    if (selected == null) return;
    Navigator.pop(context, [selected]);
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
                  Text('选择文件', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface)),
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消', style: theme.textTheme.bodyMedium?.copyWith(color: cs.primary)),
                  ),
                ],
              ),

              SizedBox(height: spacing.md),

              // 目录选择/路径展示
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _currentPath == null ? '未选择目录' : _currentPath!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.7)),
                    ),
                  ),
                  SizedBox(width: spacing.sm),
                  OutlinedButton.icon(
                    onPressed: _chooseDirectory,
                    icon: const Icon(Icons.folder_open),
                    label: const Text('选择目录'),
                  ),
                  if (_currentPath != null) ...[
                    SizedBox(width: spacing.sm),
                    IconButton(
                      tooltip: '上一级',
                      onPressed: _goUp,
                      icon: const Icon(Icons.arrow_upward),
                    ),
                  ],
                ],
              ),

              SizedBox(height: spacing.md),

              
              Expanded(
                child: _loading
                    ? const Center(child: CircularProgressIndicator())
                    : (_currentPath == null)
                        ? Center(
                            child: Text('请先选择目录', style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                          )
                        : ListView.separated(
                            itemCount: _entries.length,
                            separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
                            itemBuilder: (context, index) {
                              final e = _entries[index];
                              final isDir = e is Directory;
                              final name = e.path.split(Platform.pathSeparator).last;
                              final selected = (!isDir) && _selectedFilePath == e.path;
                              return InkWell(
                                onTap: () {
                                  if (isDir) {
                                    _enterDirectory(e as Directory);
                                  } else {
                                    _toggleSelectFile(e.path);
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isDir ? Colors.white : (selected ? cs.primary.withOpacity(0.08) : Colors.white),
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: selected ? cs.primary : Colors.grey.withOpacity(0.2), width: selected ? 2 : 1),
                                    boxShadow: [
                                      BoxShadow(color: cs.primary.withOpacity(0.08), blurRadius: 8, offset: const Offset(0, 2)),
                                    ],
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: spacing.md, horizontal: spacing.md),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 48,
                                        height: 48,
                                        decoration: BoxDecoration(
                                          color: (isDir ? Colors.amber : cs.primary).withOpacity(0.12),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        alignment: Alignment.center,
                                        child: Icon(isDir ? Icons.folder : Icons.view_in_ar, color: isDir ? Colors.amber : cs.primary),
                                      ),
                                      SizedBox(width: spacing.md),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(name, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface)),
                                            SizedBox(height: spacing.xs),
                                            Text(isDir ? '文件夹' : e.path,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                                          ],
                                        ),
                                      ),
                                      if (!isDir)
                                        Icon(selected ? Icons.check_circle : Icons.circle, color: selected ? cs.primary : Colors.grey.withOpacity(0.3)),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
              ),

              SizedBox(height: spacing.md),

              // 底部确认按钮
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _selectedFilePath == null ? null : _confirmImport,
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