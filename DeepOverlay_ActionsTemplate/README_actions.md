
# DeepOverlay · 一键云端出 IPA（适配 TrollStore）
生成时间：2025-08-11T07:39:49

## 最少步骤（全程 Windows 可做）
1. 把这个文件夹 **整体上传** 到一个新的 GitHub 仓库（建议私有）。
2. 进仓库的 **Actions** → 选择 **iOS Build (Unsigned IPA for TrollStore)** → `Run workflow`。
3. 等几分钟，页面底部 **Artifacts** 里下载 `DeepOverlay.ipa`，用 **巨魔** 安装即可。

> 已内置 SwiftUI 工程（DeepOverlay），悬浮窗与“自瞄/绘制”等开关均为**纯 UI 展示**，无实际功能。

## 做 5 个不同名称
- 现在 App 内标题已经包含：deep seek / 路西法 / vn / zoon / 谷歌。
- 如需 5 个独立图标的 IPA：先在本地或云端改工程为 5 个 target，再各自运行工作流生成 5 个 ipa。

