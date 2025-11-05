import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../theme/design_tokens.dart';
import '../main.dart';
import '../utils/cache_utils.dart';
import 'help_page.dart';
import 'feedback_page.dart';
import 'about_page.dart';

/// 设置页（参考原型：10. 设置页）
/// - 主题设置、缓存清理、帮助中心、意见反馈、关于APP
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _cacheSizeBytes = 0;
  bool _loadingCache = true;

  @override
  void initState() {
    super.initState();
    _refreshCacheSize();
  }

  Future<void> _refreshCacheSize() async {
    setState(() => _loadingCache = true);
    final size = await CacheUtils.computeCacheSize();
    if (!mounted) return;
    setState(() {
      _cacheSizeBytes = size;
      _loadingCache = false;
    });
  }

  String _fmtBytes(int bytes) {
    const kb = 1024;
    const mb = kb * 1024;
    const gb = mb * 1024;
    if (bytes >= gb) return '${(bytes / gb).toStringAsFixed(2)} GB';
    if (bytes >= mb) return '${(bytes / mb).toStringAsFixed(2)} MB';
    if (bytes >= kb) return '${(bytes / kb).toStringAsFixed(2)} KB';
    return '$bytes B';
  }

  String _currentThemeLabel() {
    final mode = themeModeNotifier.value;
    if (mode == ThemeMode.light) return '浅色';
    if (mode == ThemeMode.dark) return '深色';
    return '系统';
  }

  Future<void> _chooseTheme() async {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);
    final selected = themeModeNotifier.value;
    await showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.colorScheme.surface,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.all(spacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.brightness_auto, color: cs.primary),
                title: const Text('跟随系统'),
                trailing: selected == ThemeMode.system ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _setThemeMode(ThemeMode.system),
              ),
              ListTile(
                leading: Icon(Icons.light_mode, color: cs.primary),
                title: const Text('浅色模式'),
                trailing: selected == ThemeMode.light ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _setThemeMode(ThemeMode.light),
              ),
              ListTile(
                leading: Icon(Icons.dark_mode, color: cs.primary),
                title: const Text('深色模式'),
                trailing: selected == ThemeMode.dark ? const Icon(Icons.check, color: Colors.green) : null,
                onTap: () => _setThemeMode(ThemeMode.dark),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _setThemeMode(ThemeMode mode) async {
    themeModeNotifier.value = mode;
    final prefs = await SharedPreferences.getInstance();
    final str = switch (mode) { ThemeMode.light => 'light', ThemeMode.dark => 'dark', _ => 'system' };
    await prefs.setString('themeMode', str);
    if (mounted) Navigator.of(context).maybePop();
  }

  Future<void> _clearCache() async {
    final freed = await CacheUtils.clearCache();
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('已清理缓存 ${_fmtBytes(freed)}')),
    );
    await _refreshCacheSize();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final spacing = theme.extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    Widget buildItem({
      required Color badgeColor,
      required IconData badgeIcon,
      required String title,
      String? subtitle,
      Widget? trailing,
      VoidCallback? onTap,
    }) {
      return Card(
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(color: badgeColor.withOpacity(0.18), shape: BoxShape.circle),
                  alignment: Alignment.center,
                  child: Icon(badgeIcon, color: badgeColor),
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: theme.textTheme.titleMedium?.copyWith(color: theme.colorScheme.onSurface)),
                      if (subtitle != null) ...[
                        SizedBox(height: spacing.xs),
                        Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurface.withOpacity(0.6))),
                      ],
                    ],
                  ),
                ),
                trailing ?? const Icon(Icons.chevron_right, color: Colors.grey),
              ],
            ),
          ),
        ),
      );
    }

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
                  Text('设置', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(width: 48),
                ],
              ),

              SizedBox(height: spacing.lg),

              Expanded(
                child: ListView(
                  children: [
                    buildItem(
                      badgeColor: cs.primary,
                      badgeIcon: Icons.palette,
                      title: '主题设置',
                      subtitle: '当前：${_currentThemeLabel()}',
                      trailing: OutlinedButton(onPressed: _chooseTheme, child: const Text('切换')),
                      onTap: _chooseTheme,
                    ),
                    buildItem(
                      badgeColor: Colors.green,
                      badgeIcon: Icons.cleaning_services,
                      title: '缓存清理',
                      subtitle: _loadingCache ? '正在计算缓存大小...' : '当前缓存：${_fmtBytes(_cacheSizeBytes)}',
                      trailing: TextButton(
                        onPressed: _clearCache,
                        child: const Text('清理', style: TextStyle(color: Colors.green)),
                      ),
                      onTap: _clearCache,
                    ),
                    buildItem(
                      badgeColor: Colors.pink,
                      badgeIcon: Icons.help_outline,
                      title: '帮助中心',
                      subtitle: '使用教程与常见问题',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const HelpPage())),
                    ),
                    buildItem(
                      badgeColor: Colors.amber,
                      badgeIcon: Icons.feedback,
                      title: '意见反馈',
                      subtitle: '告诉我们你的想法',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const FeedbackPage())),
                    ),
                    buildItem(
                      badgeColor: Colors.purple,
                      badgeIcon: Icons.info,
                      title: '关于APP',
                      subtitle: '版本信息与版权说明',
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutPage())),
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
}