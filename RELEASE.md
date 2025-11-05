# Blendy Box 发布到 GitHub Releases（APK）

本文档指导将项目打包为 Android APK，并在 GitHub 仓库的 Releases 页面发布下载，初始版本号为 `1.0.0`。

## 环境准备
- 安装并配置 `Flutter`（稳定版）与 Android 开发环境（Android SDK、Platform Tools、Java 11）。
- 终端运行 `flutter doctor -v`，确保所有项通过或只剩可忽略项。
- 若在国内网络环境，可临时设置镜像以降低拉取失败概率：
  - PowerShell 会话设置：
    - `$env:PUB_HOSTED_URL="https://pub.flutter-io.cn"`
    - `$env:FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"`

## 版本号设置（1.0.0）
- 编辑 `pubspec.yaml`，设置版本：
  - `version: 1.0.0+1`
  - `1.0.0` 为 `versionName`，`+1` 为 `versionCode`（整数，递增即可）。
- 当前 Android 配置已从 Flutter 自动同步：
  - `android/app/build.gradle.kts` 使用 `versionCode = flutter.versionCode` 与 `versionName = flutter.versionName`。

## 生成发布签名（首次）
为了生成可分发的正式版 APK，需要使用你自己的签名证书（Keystore）。

1) 生成 keystore（在项目根目录执行）：
```
keytool -genkey -v -keystore key.jks -keyalg RSA -keysize 2048 -validity 36500 -alias upload
```
- 建议将 `key.jks` 放在项目根目录或 `android/` 目录下（不要提交到 Git）。

2) 新建 `key.properties`（路径：项目根目录），内容示例：
```
storeFile=../key.jks
storePassword=你的证书密码
keyAlias=upload
keyPassword=你的证书密码
```
- 如果将 `key.jks` 放在项目根目录，`storeFile=key.jks`；若在 `android/` 下，建议写相对路径。
- 将 `key.properties` 也加入 `.gitignore`，避免泄露。

3) 配置 Gradle 签名（`android/app/build.gradle.kts`）
在 `android { ... }` 代码块前读取 `key.properties`，并在 `signingConfigs` 与 `buildTypes.release` 中引用：

```kotlin
// 顶部或 android {} 之前添加：
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = java.util.Properties()
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
}

android {
    // ... 现有配置保持不变

    signingConfigs {
        create("release") {
            val storeFilePath = keystoreProperties.getProperty("storeFile")
            if (storeFilePath != null) {
                storeFile = file(storeFilePath)
            }
            storePassword = keystoreProperties.getProperty("storePassword")
            keyAlias = keystoreProperties.getProperty("keyAlias")
            keyPassword = keystoreProperties.getProperty("keyPassword")
        }
    }

    buildTypes {
        release {
            // 使用正式签名，而非 debug
            signingConfig = signingConfigs.getByName("release")
            // 如需混淆：
            // isMinifyEnabled = true
            // proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        }
    }
}
```

> 说明：默认模板里 `release` 使用 `debug` 签名，上述修改将其切换到正式签名。

## 构建发布 APK
确保依赖已安装：

```
flutter pub get
```

构建正式发布包：

```
flutter build apk --release
```

- 输出路径：`build/app/outputs/flutter-apk/app-release.apk`
- 如需快速验证设备安装，也可构建调试包：`flutter build apk --debug`（不用于发布）。

## 在 GitHub 创建 Release 并上传 APK
你的仓库地址为：`git@github.com:cauliflower-beep/blendy_box.git`

### 方式 A：通过 GitHub Web 页面（推荐新手）
1) 打开仓库页面 → 点击 `Releases` → `Draft a new release`。
2) 填写：
   - `Tag`：`v1.0.0`（如无则新建）
   - `Release title`：`Blendy Box 1.0.0`
   - `Description`：简单介绍本次发布内容（可选）。
3) 在 `Attach binaries by dropping them here or selecting them` 位置上传 `app-release.apk`。
4) 点击 `Publish release`。
5) 验证 Release 页面展示 APK 下载按钮是否可用。

### 方式 B：使用 GitHub CLI（gh）命令行
先安装并登录 `gh` 工具，然后在项目根目录执行：

```
gh release create v1.0.0 build/app/outputs/flutter-apk/app-release.apk \
  --title "Blendy Box 1.0.0" \
  --notes "初始稳定发布版本"
```

执行完成后，访问仓库的 Releases 页面即可看到对应条目与 APK 附件。

## 可选：自动化构建与发布（CI）
如果希望后续打标签自动构建并发布 APK，可考虑使用 GitHub Actions（仅示意）：

```
.github/workflows/release.yml
```
内容可参考：
```
name: Build APK on Release Tag
on:
  push:
    tags:
      - 'v*'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      - run: flutter pub get
      - run: flutter build apk --release
      - uses: softprops/action-gh-release@v1
        with:
          files: build/app/outputs/flutter-apk/app-release.apk
        env:
          GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

> 注意：如需私有签名，需在 CI 环境配置 `key.jks` 与 `key.properties`（通常通过 GitHub Encrypted Secrets + runtime 解密方式），或使用 Play/AppCenter 等分发渠道。

## 版本迭代建议
- 每次发布前更新 `pubspec.yaml` 的 `version`：如 `1.0.1+2`、`1.1.0+3` 等。
- 打新标签：`v1.0.1`、`v1.1.0` 等，与版本号一致，便于追踪。
- Release 说明里记录改动点（功能、修复、兼容性说明）。

## 常见问题
- Gradle 下载失败：考虑使用上文镜像或重试；检查网络/代理/证书。
- 未配置签名仍可生成 APK：默认使用 debug 签名，浏览器或商店下载不建议使用，需按文档配置正式签名。
- 应用 ID（`applicationId`）：当前为 `com.example.blendy_box`，如需上架或避免冲突，请在 `android/app/build.gradle.kts` 的 `defaultConfig` 中修改为你的域名反转形式（如 `com.yourcompany.blendybox`）。

——
完成以上步骤后，你的 `v1.0.0` 发布即可在 GitHub Releases 页面显示，并提供 `app-release.apk` 供用户直接下载使用。