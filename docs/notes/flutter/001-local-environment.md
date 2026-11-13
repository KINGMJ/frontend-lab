# 001 本机 Flutter 环境

记录 2026-11-04 在这台 Mac 上安装 Flutter 的步骤和结果。编辑器是 Cursor，安装顺序参考 [Install Flutter with VS Code](https://docs.flutter.dev/install/with-vs-code)。Cursor 属于文档里说的 Code OSS 编辑器，扩展直接装在 Cursor 里。

国内下载走 [Using Flutter in China](https://docs.flutter.dev/community/china) 列出的 CFUG 镜像 `flutter-io.cn`。

## 本机前提

安装前已经具备：

| 项目 | 状态 |
| --- | --- |
| 系统 | macOS 15.3.1，Apple Silicon（arm64） |
| Git | 2.39.5，Xcode Command Line Tools 已安装 |
| `curl`、`unzip`、`zip` | 系统自带 |
| Chrome | 已安装，用来跑 Web |
| Homebrew | 已安装 |
| JDK | Homebrew 的 OpenJDK 17 和 21。Android 工具链使用 17 |
| Android SDK | 已有，见下一节 |

Xcode 完整应用尚未安装，所以暂时不能编译 iOS 和 macOS 桌面应用。

## 1. 安装编辑器扩展

在 Cursor 中安装 Flutter 扩展。它会同时安装 Dart 扩展。本次装上的版本都是 3.146.0。

```bash
cursor --install-extension Dart-Code.flutter --install-extension Dart-Code.dart-code
```

装完后重载 Cursor 窗口，扩展才会生效。

## 2. 安装 Flutter SDK

官方在编辑器里的做法是 Command Palette → `Flutter: New Project` → `Download SDK`，从 GitHub 克隆 stable 分支。这台机器走国内镜像的稳定版压缩包，避免克隆仓库历史。

当时的 stable 版本是 **3.47.9**（Dart 3.13.7）。arm64 压缩包：

```text
https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.47.9-stable.zip
```

SHA-256：

```text
6545b85938745dc5070e9faf2adf70233c1811009d87fe6d27bfcda5a04b7698
```

下载、校验、解压到家目录，并删掉压缩包：

```bash
mkdir -p "$HOME/development"
curl -fL -o "$HOME/development/flutter_macos_arm64_3.47.9-stable.zip" \
  "https://storage.flutter-io.cn/flutter_infra_release/releases/stable/macos/flutter_macos_arm64_3.47.9-stable.zip"
shasum -a 256 "$HOME/development/flutter_macos_arm64_3.47.9-stable.zip"
unzip "$HOME/development/flutter_macos_arm64_3.47.9-stable.zip" -d "$HOME/development"
rm "$HOME/development/flutter_macos_arm64_3.47.9-stable.zip"
```

解压后的 SDK 位于 `~/development/flutter`。以后查当前 stable 版本，看镜像上的发布清单：

```text
https://storage.flutter-io.cn/flutter_infra_release/releases/releases_macos.json
```

## 3. 写入 shell 环境

把下面几行追加到 `~/.zshrc`。`PATH` 让终端找到 `flutter`。两个镜像变量让引擎产物和 pub 包从 `flutter-io.cn` 下载。

```bash
# Flutter SDK
export PATH="$HOME/development/flutter/bin:$PATH"
export PUB_HOSTED_URL="https://pub.flutter-io.cn"
export FLUTTER_STORAGE_BASE_URL="https://storage.flutter-io.cn"
```

新开一个终端，或执行 `source ~/.zshrc`，然后确认：

```bash
flutter --version
```

期望看到 Flutter 3.47.9 和 Dart 3.13.7。

## 4. 接上已有的 Android SDK

SDK 原本就在：

```text
/Volumes/MiniMate/MacMini/Development/Android/
├── sdk/                         # 平台、构建工具、模拟器、系统镜像
├── homebrew-commandlinetools/   # Homebrew 安装的 cmdline-tools
└── avd/                         # 模拟器 medium_phone
```

另外两处符号链接在安装 Flutter 之前已经存在：

- `~/Library/Android/sdk` → 上面的 `sdk`
- `~/.android/avd` → 上面的 `avd`

`sdk` 里已有 Android 36 平台、build-tools 36.0.0 和 34.0.0、platform-tools、emulator，以及 `system-images/android-36/google_apis_playstore`。

Flutter 只在 SDK 内部寻找命令行工具：

```text
$ANDROID_HOME/cmdline-tools/latest/bin/sdkmanager
```

Homebrew 把这套工具放在 SDK 旁边的 `homebrew-commandlinetools/cmdline-tools`，所以 `flutter doctor` 最初报告缺少 cmdline-tools。用符号链接接进去，不复制文件：

```bash
ln -s \
  "/Volumes/MiniMate/MacMini/Development/Android/homebrew-commandlinetools/cmdline-tools" \
  "/Volumes/MiniMate/MacMini/Development/Android/sdk/cmdline-tools"
```

JDK 使用 Homebrew 的 OpenJDK 17。它是 keg-only，不会自动出现在 `PATH` 里，需要显式指定 `JAVA_HOME`。

再把 Android 相关变量追加到 `~/.zshrc`：

```bash
# Android SDK
export ANDROID_HOME="/Volumes/MiniMate/MacMini/Development/Android/sdk"
export ANDROID_SDK_ROOT="$ANDROID_HOME"
export JAVA_HOME="/opt/homebrew/opt/openjdk@17/libexec/openjdk.jdk/Contents/Home"
export PATH="$JAVA_HOME/bin:$ANDROID_HOME/cmdline-tools/latest/bin:$ANDROID_HOME/platform-tools:$ANDROID_HOME/emulator:$PATH"
```

让 Flutter 自己记住 SDK 和 JDK 的位置。编辑器重启后会读这两项配置：

```bash
flutter config --android-sdk "$ANDROID_HOME"
flutter config --jdk-dir "$JAVA_HOME"
```

接受尚未同意的 Android 许可证：

```bash
flutter doctor --android-licenses
```

已有模拟器是 `medium_phone`（Medium Phone，Android 36，arm64，带 Google Play）。需要时再启动：

```bash
flutter emulators --launch medium_phone
```

## 5. 验收

```bash
flutter doctor
flutter devices
flutter emulators
```

2026-11-04 的结果：

| 检查项 | 结果 |
| --- | --- |
| Flutter 3.47.9 | 通过 |
| Android toolchain，SDK 36.0.0 | 通过 |
| Chrome | 通过 |
| 模拟器 `medium_phone` | 已登记，未启动时不会出现在 `flutter devices` |
| Xcode | 未完成。还不能编译 iOS 和 macOS 应用，CocoaPods 也还没装 |
| 访问 `https://github.com/` | 检查超时。SDK 和包走的是 `flutter-io.cn`，这项不影响当前学习 |

`flutter devices` 在模拟器未启动时看到两台设备：本机 macOS，以及 Chrome。macOS 那一项在装好 Xcode 之前不能用来运行应用。当前可以运行的目标是 **Chrome** 和 **medium_phone**。
