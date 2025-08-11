
import SwiftUI

struct RootView: View {
    @State private var showOverlay = false
    @State private var showFakePermission = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color.black.opacity(0.3)],
                           startPoint: .topLeading, endPoint: .bottomTrailing)
            .ignoresSafeArea()

            VStack(spacing: 18) {
                TitleHeader()
                Spacer()
                Card(title: "开启悬浮窗", subtitle: "显示一个可拖动的气泡与面板（仅视觉效果）") {
                    Button(action: { showFakePermission = true }) {
                        Label(showOverlay ? "已开启" : "去开启",
                              systemImage: showOverlay ? "checkmark.seal.fill" : "sparkles")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16, style: .continuous))
                    }
                }

                Card(title: "外观风格", subtitle: "简单 · 高级 · 极简") {
                    HStack(spacing: 12) {
                        StylePill(text: "简约黑")
                        StylePill(text: "半透明玻璃")
                        StylePill(text: "高斯阴影")
                    }
                }

                Card(title: "说明", subtitle: "本应用仅为演示界面，不提供任何实际功能") {
                    Text("所有开关仅为 UI 展示，不会修改其他应用。")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                Spacer(minLength: 40)
            }
            .padding(20)

            if showOverlay {
                OverlayLayer(showOverlay: $showOverlay)
                    .transition(.opacity.combined(with: .scale))
            }
        }
        .sheet(isPresented: $showFakePermission) {
            FakePermissionSheet(showOverlay: $showOverlay)
                .presentationDetents([.fraction(0.35)])
                .presentationDragIndicator(.visible)
        }
    }
}

struct TitleHeader: View {
    var body: some View {
        VStack(spacing: 8) {
            Text("deep seek / 路西法 / vn / zoon / 谷歌")
                .font(.system(size: 22, weight: .semibold, design: .rounded))
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(.ultraThinMaterial, in: Capsule())
            Text("Overlay Demo · 仅UI展示")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
}

struct Card<Content: View>: View {
    var title: String
    var subtitle: String
    @ViewBuilder var content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title).font(.headline)
                Text(subtitle).font(.caption).foregroundStyle(.secondary)
            }
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20).strokeBorder(Color.white.opacity(0.06))
        )
        .shadow(radius: 18, y: 8)
    }
}

struct StylePill: View {
    var text: String
    var body: some View {
        Text(text)
            .font(.subheadline)
            .padding(.horizontal, 12).padding(.vertical, 8)
            .background(.ultraThinMaterial, in: Capsule())
            .overlay(Capsule().strokeBorder(Color.white.opacity(0.08)))
    }
}

// MARK: - Fake permission sheet
struct FakePermissionSheet: View {
    @Environment(\._dismiss) private var dismiss
    @Binding var showOverlay: Bool

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "rectangle.and.hand.point.up.left.filled")
                .font(.system(size: 40))
            Text("开启悬浮窗（演示）")
                .font(.title3.bold())
            Text("iOS 无系统级悬浮窗权限。本开关仅在本应用内显示一个可拖动面板，用于界面演示。")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            Button {
                showOverlay = true
                dismiss()
                Haptics.tap()
            } label: {
                Text("同意并开启（演示）")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
            }
        }
        .padding(20)
    }
}

// MARK: - Overlay layer
struct OverlayLayer: View {
    @Binding var showOverlay: Bool
    @State private var bubblePos: CGPoint = CGPoint(x: 80, y: 140)
    @State private var panelOpen: Bool = true

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // draggable bubble
                DraggableBubble(position: $bubblePos, bounds: geo.size) {
                    panelOpen.toggle()
                }

                if panelOpen {
                    OverlayPanel(closeAction: { showOverlay = false })
                        .frame(width: 280)
                        .position(x: min(max(bubblePos.x + 160, 150), geo.size.width - 140),
                                  y: min(max(bubblePos.y + 0, 120), geo.size.height - 160))
                        .transition(.move(edge: .trailing).combined(with: .opacity))
                }
            }
            .animation(.spring(response: 0.35, dampingFraction: 0.88, blendDuration: 0.2), value: panelOpen)
        }
        .ignoresSafeArea()
    }
}

struct DraggableBubble: View {
    @Binding var position: CGPoint
    let bounds: CGSize
    var tapAction: ()->Void

    @State private var isDragging = false

    var body: some View {
        Circle()
            .fill(.ultraThinMaterial)
            .overlay(
                Image(systemName: "scope")
                    .font(.system(size: 20, weight: .bold))
            )
            .frame(width: 56, height: 56)
            .shadow(radius: 18, y: 8)
            .position(position)
            .gesture(
                DragGesture()
                    .onChanged { v in
                        isDragging = true
                        let nx = min(max(v.location.x, 28), bounds.width - 28)
                        let ny = min(max(v.location.y, 28), bounds.height - 28)
                        position = CGPoint(x: nx, y: ny)
                    }
                    .onEnded { _ in isDragging = false }
            )
            .onTapGesture { tapAction() }
    }
}

struct ToggleRow: View {
    let title: String
    @State private var on = false
    var body: some View {
        HStack {
            Text(title)
            Spacer()
            Toggle("", isOn: $on).labelsHidden()
        }
        .padding(.vertical, 6)
    }
}

struct OverlayPanel: View {
    var closeAction: ()->Void
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                Text("功能面板").font(.headline)
                Spacer()
                Button(action: closeAction) {
                    Image(systemName: "xmark.circle.fill").imageScale(.large)
                }
            }
            .padding(.bottom, 4)

            Group {
                ToggleRow(title: "自瞄 (假)")
                ToggleRow(title: "无后坐力 (假)")
                ToggleRow(title: "方框绘制 (假)")
                ToggleRow(title: "骨骼绘制 (假)")
                ToggleRow(title: "穿墙 (假)")
                ToggleRow(title: "显示血量 (假)")
            }

            Button {
                // purely visual
            } label: {
                Text("一键开启(假)")
                    .frame(maxWidth: .infinity).padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            }
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(RoundedRectangle(cornerRadius: 24).strokeBorder(Color.white.opacity(0.06)))
        .shadow(radius: 24, y: 12)
    }
}

// MARK: - Haptics
enum Haptics {
    static func tap() {
#if canImport(UIKit)
        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
#endif
    }
}

# Previews
struct RootView_Previews: PreviewProvider {
    static var previews: some View {
        RootView()
            .previewDevice("iPhone 15 Pro")
    }
}
