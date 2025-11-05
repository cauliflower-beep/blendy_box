import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'theme/app_theme.dart';
import 'theme/design_tokens.dart';
import 'pages/startup_page.dart';
import 'pages/onboarding_page_1.dart';
import 'pages/onboarding_page_2.dart';
import 'pages/onboarding_page_3.dart';
import 'pages/onboarding_flow.dart';
import 'pages/file_browser_page.dart';
import 'pages/model_viewer_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blendy Box',
      // 接入全局主题：避免样式硬编码，支持主题切换
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system, // 后续也可以通过设置持久化切换主题
      scrollBehavior: const AppScrollBehavior(),
      home: const OnboardingFlowPage(),
      routes: {
        '/home': (context) => const HomePage(),
      },
    );
  }
}

/// 简单的模型文件数据结构，用于列表展示与收藏标记
class ModelFile {
  final String name;
  final int sizeBytes;
  final DateTime openedAt;
  bool favorite;
  final String? src; // 资源/文件路径（资产或本地路径）

  ModelFile({
    required this.name,
    required this.sizeBytes,
    required this.openedAt,
    this.favorite = false,
    this.src,
  });

  String get humanSize {
    if (sizeBytes < 1024) return '$sizeBytes B';
    final kb = sizeBytes / 1024;
    if (kb < 1024) return '${kb.toStringAsFixed(1)}KB';
    final mb = kb / 1024;
    return '${mb.toStringAsFixed(1)}MB';
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<ModelFile> _files = [];
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadDefaultModel();
  }

  Future<void> _loadDefaultModel() async {
    try {
      // 从内置资源加载默认模型（例如 assets/models/goku.glb）
      final data = await rootBundle.load('assets/models/goku.glb');
      final now = DateTime.now();
      setState(() {
        _files.add(ModelFile(
          name: 'goku.glb',
          sizeBytes: data.lengthInBytes,
          openedAt: now,
          src: 'assets/models/goku.glb',
        ));
      });
    } catch (_) {
      // 如果资源不存在或加载失败，保持空列表，不影响页面
    }
  }

  Future<void> _importBlendFiles() async {
    // 允许在 Web/桌面/移动端选择 .blend 文件；Web 下使用 input[type=file]
    try {
      // 延迟加载，避免在无插件平台编译期报错
      // ignore: import_of_legacy_library_into_null_safe
      final picker = await Future.value(true);
      // 动态引入以避免分析器警告（仍需在 pubspec 中声明依赖）
      // 使用文件选择器
      // NOTE: 直接使用类型：FileType.custom + allowedExtensions ['glb','gltf']
      // 为了简单，这里采用在运行时导入包的方式书写在注释中；实际编译时静态导入即可。
    } catch (_) {
      // 忽略异常（例如权限或取消选择）
    }
  }

  Future<void> _pickBlendFiles() async {
    // 进入自定义文件浏览页；根据平台返回不同数据结构
    try {
      final result = await Navigator.push(context, MaterialPageRoute(builder: (_) => const FileBrowserPage()));
      if (result == null) return;
      if (result is List<String>) {
        // IO 平台返回的是绝对路径列表
        final now = DateTime.now();
        setState(() {
          for (final p in result) {
            final name = p.split('\\').isNotEmpty ? p.split('\\').last : (p.split('/').isNotEmpty ? p.split('/').last : p);
            _files.add(ModelFile(name: name, sizeBytes: 0, openedAt: now, src: p));
          }
        });
      } else if (result is List) {
        // Web 平台返回的是文件名列表（路径不可用）
        final now = DateTime.now();
        setState(() {
          for (final name in result.cast<String>()) {
            _files.add(ModelFile(name: name, sizeBytes: 0, openedAt: now));
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('导入失败：$e')));
    }
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
          child: _files.isEmpty ? _buildEmptyState(theme, cs, spacing) : _buildHasFiles(theme, cs, spacing),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickBlendFiles,
        backgroundColor: cs.primary,
        child: const Icon(Icons.file_open, color: Colors.white),
      ),
    );
  }

  Widget _buildTopBar(ThemeData theme, ColorScheme cs, AppSpacing spacing) {
    return Padding(
      padding: EdgeInsets.only(bottom: spacing.lg),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('我的3D模型', style: theme.textTheme.titleMedium?.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: cs.primary)),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.search, color: cs.primary),
          )
        ],
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme, ColorScheme cs, AppSpacing spacing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTopBar(theme, cs, spacing),
        Expanded(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(color: cs.primary.withOpacity(0.08), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.all(spacing.md),
                    child: Icon(Icons.view_in_ar, color: cs.primary, size: 64),
                  ),
                ),
                SizedBox(height: spacing.lg),
                Text('还没有导入模型哦～', style: theme.textTheme.titleMedium?.copyWith(fontSize: 18, color: theme.colorScheme.onSurface)),
                SizedBox(height: spacing.sm),
                Text('导入你的 GLB/GLTF 文件，开始3D预览之旅',
                    style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                SizedBox(height: spacing.xl),
                ElevatedButton.icon(
                  onPressed: _pickBlendFiles,
                  icon: const Icon(Icons.add),
                  label: const Text('立即导入模型'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHasFiles(ThemeData theme, ColorScheme cs, AppSpacing spacing) {
    return DefaultTabController(
      length: 2,
      initialIndex: _tabIndex,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(theme, cs, spacing),
          TabBar(
            onTap: (i) => setState(() => _tabIndex = i),
            tabs: const [
              Tab(text: '最近打开'),
              Tab(text: '我的收藏'),
            ],
          ),
          SizedBox(height: spacing.lg),
          Expanded(
            child: TabBarView(
              children: [
                _buildFileList(theme, cs, spacing, _files),
                _buildFileList(theme, cs, spacing, _files.where((f) => f.favorite).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFileList(ThemeData theme, ColorScheme cs, AppSpacing spacing, List<ModelFile> files) {
    if (files.isEmpty) {
      return Center(
        child: Text('暂无文件', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
      );
    }
    return ListView.separated(
      itemCount: files.length,
      separatorBuilder: (_, __) => SizedBox(height: spacing.sm),
      itemBuilder: (context, index) {
        final f = files[index];
        return Card(
          child: InkWell(
            onTap: () => _openModel(f),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(color: cs.primary.withOpacity(0.12), borderRadius: BorderRadius.circular(12)),
                    alignment: Alignment.center,
                    child: Icon(Icons.view_in_ar, color: cs.primary),
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(f.name, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface)),
                        SizedBox(height: spacing.xs),
                        Text('${_fmtDate(f.openedAt)} · ${f.humanSize}',
                            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => f.favorite = !f.favorite),
                    icon: Icon(f.favorite ? Icons.favorite : Icons.favorite_border, color: f.favorite ? cs.primary : theme.colorScheme.onSurface.withOpacity(0.4)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _openModel(ModelFile f) {
    final src = f.src;
    if (src == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('该文件来源不可预览（缺少路径）')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ModelViewerPage(
          title: f.name,
          src: src,
          sizeBytes: f.sizeBytes,
          openedAt: f.openedAt,
        ),
      ),
    );
  }

  String _fmtDate(DateTime dt) {
    return '${dt.year}-${_two(dt.month)}-${_two(dt.day)}';
  }

  String _two(int n) => n < 10 ? '0$n' : '$n';
}
