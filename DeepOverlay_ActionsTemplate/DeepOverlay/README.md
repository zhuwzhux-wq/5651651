
# DeepOverlay (SwiftUI) — 仅UI演示
生成时间：2025-08-11T07:37:51

## 快速打包为 .ipa
1. 打开 `DeepOverlay/DeepOverlay.xcodeproj`（Xcode 14+，iOS 16+）。
2. TARGETS → DeepOverlay：
   - Signing & Capabilities：选择你的 Team；
   - 修改 Bundle Identifier 为唯一值（如 `com.yourname.deepoverlay`）；
   - （可选）General → Display Name 改成你想显示的名称；
3. 连接设备或选择 “Any iOS Device (arm64)”；
4. `Product` → `Archive` → `Distribute App` → `Ad Hoc`/`Development` → 导出 `.ipa`；
5. 用 巨魔(TrollStore) / AltStore / Sideloadly 安装 `.ipa`。

## 做 5 个不同名字的版本
- 在 Xcode 里对 `DeepOverlay` target 右键 `Duplicate` 4 次；
- 分别将 `Display Name` 改为：`deep seek`、`路西法`、`vn`、`zoon`、`谷歌`；
- 将每个 target 的 `Bundle Identifier` 改为不同的唯一值；
- 分别 Archive 导出 .ipa 即可。

## 说明
- 应用内“悬浮窗/自瞄/绘制”等均为**纯 UI 演示**，无实际功能。
- 源码在 `Sources/` 下，图标占位在 `Assets.xcassets/AppIcon.appiconset/`。

