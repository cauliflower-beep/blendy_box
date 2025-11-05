import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'theme/design_tokens.dart';
import 'pages/startup_page.dart';
import 'pages/onboarding_page_1.dart';
import 'pages/onboarding_page_2.dart';
import 'pages/onboarding_page_3.dart';
import 'pages/onboarding_flow.dart';

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

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // 通过 ThemeExtension 获取统一的间距令牌
    final spacing = Theme.of(context).extension<AppSpacing>() ?? const AppSpacing(xs: 4, sm: 8, md: 12, lg: 16, xl: 24);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blendy Box'),
      ),
      body: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('卡片示例', style: Theme.of(context).textTheme.titleMedium),
                    SizedBox(height: spacing.md),
                    Text(
                      '此卡片与按钮样式来自全局主题与设计令牌，避免硬编码。',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    SizedBox(height: spacing.lg),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          child: const Text('主按钮'),
                        ),
                        SizedBox(width: spacing.md),
                        OutlinedButton(
                          onPressed: () {},
                          child: const Text('次按钮'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: spacing.xl),
            Center(
              child: Text('欢迎使用 Blendy Box', style: Theme.of(context).textTheme.bodyLarge),
            ),
          ],
        ),
      ),
    );
  }
}
