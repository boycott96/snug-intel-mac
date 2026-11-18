// 截图的系统实现：ScreenCaptureKit 截窗口，CGImage 裁剪，NSPasteboard 写剪贴板。
// 截窗口要「录屏与系统录音」权限，和辅助功能是两项；这里只读权限状态，授权引导在设置页（PermissionFlow）
import AppKit
@preconcurrency import ScreenCaptureKit
import SnugCore

@MainActor
public final class ScreenshotService: ScreenshotControl {
    public init() {}

    public var trusted: Bool { CGPreflightScreenCaptureAccess() }

    public func capture(_ window: WindowKey) async throws(CaptureFailure) -> CapturedImage {
        guard trusted else { throw .noPermission }
        let content: SCShareableContent
        do {
            // 不限在屏上的窗口：刚铺满手机屏、还没画完的也找得到，按编号认
            content = try await SCShareableContent.excludingDesktopWindows(false, onScreenWindowsOnly: false)
        } catch {
            // 没权限时这里也会失败（SCStreamErrorDomain -3801），和别的原因分开报
            Log.warn("截窗口 #\(window.id)：列不出可截的窗口：\(error)")
            throw trusted ? .unavailable : .noPermission
        }
        guard let target = content.windows.first(where: { $0.windowID == window.id }) else { throw .windowGone }
        let image: CGImage
        if #available(macOS 14, *) {
            do {
                image = try await Self.captureImage(target)
            } catch {
                Log.warn("截窗口 #\(window.id) 失败：\(error)")
                throw trusted ? .unavailable : .noPermission
            }
        } else {
            // Ventura 没有 SCScreenshotManager；按窗口编号截原始像素，排除阴影和鼠标。
            guard let captured = CGWindowListCreateImage(.null, .optionIncludingWindow, window.id,
                                                        [.boundsIgnoreFraming, .bestResolution]) else {
                Log.warn("截窗口 #\(window.id) 失败：CoreGraphics 未返回图像")
                throw trusted ? .unavailable : .noPermission
            }
            image = captured
        }
        guard let png = Self.png(image) else {
            Log.warn("截窗口 #\(window.id)：\(image.width)×\(image.height) 编不成 PNG")
            throw .unavailable
        }
        return CapturedImage(png: png, pixelWidth: image.width, pixelHeight: image.height)
    }

    public func crop(_ image: CapturedImage, to rect: CGRect) -> CapturedImage? {
        guard let source = NSBitmapImageRep(data: image.png)?.cgImage,
              let cropped = source.cropping(to: rect),
              let png = Self.png(cropped) else { return nil }
        return CapturedImage(png: png, pixelWidth: cropped.width, pixelHeight: cropped.height)
    }

    public func copy(_ image: CapturedImage) -> Bool {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        return pasteboard.setData(image.png, forType: .png)
    }

    private static func png(_ image: CGImage) -> Data? {
        NSBitmapImageRep(cgImage: image).representation(using: .png, properties: [:])
    }

    @available(macOS 14, *)
    private static func captureImage(_ window: SCWindow) async throws -> CGImage {
        let filter = SCContentFilter(desktopIndependentWindow: window)
        // 窗口的点尺寸乘屏幕倍率：截出来就是 Retina 原画，不是放大过的。
        let scale = CGFloat(filter.pointPixelScale)
        let configuration = SCStreamConfiguration()
        configuration.width = max(1, Int((window.frame.width * scale).rounded()))
        configuration.height = max(1, Int((window.frame.height * scale).rounded()))
        configuration.showsCursor = false
        return try await SCScreenshotManager.captureImage(contentFilter: filter, configuration: configuration)
    }
}
