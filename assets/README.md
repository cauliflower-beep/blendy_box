# 项目资源目录（assets）

此目录用于存放应用内置的静态资源，按类型分层：

- `assets/images/`：应用内图片，如占位图、引导页插画等。
- `assets/models/`：内置 3D 模型文件，如 `*.glb`/`*.gltf`。

约定：
- 仅在 `pubspec.yaml` 中注册了的目录会被打包；当前已注册 `assets/images/` 与 `assets/models/`。
- 大体量模型文件建议按功能再分子目录，例如：`assets/models/samples/`、`assets/models/defaults/`。
- 若需添加字体、着色器等，可后续拓展：`assets/fonts/`、`assets/shaders/`。

使用方法（示意）：
```dart
// 加载图片资产：
Image.asset('assets/images/placeholder.png');

// 模型资产路径（后续在 3D 预览页里使用）：
final modelPath = 'assets/models/default.glb';
```