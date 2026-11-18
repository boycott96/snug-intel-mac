import Foundation
import SnugCore
import Testing
@testable import Snug

@Suite("UU 推流观测的系统兼容")
@MainActor
struct CaptureObservationTests {
    @Test("Ventura 切屏没有新日志时仍识别连接，但不把开头的主屏当成当前选屏")
    func activeCapture() {
        let began = Date(timeIntervalSince1970: 1_000)
        var state = CaptureSessionState()
        state.apply(CaptureLogRecord(date: began, event: .displayDescribed(1)))
        state.apply(CaptureLogRecord(date: began.addingTimeInterval(0.1), event: .captureStarted))
        // 本机实测：手机切到虚拟屏后，没有新的选屏或推流开始事件。
        let sample = CaptureLogWatcher.observation(of: state, at: began.addingTimeInterval(30))
        #expect(sample.active)
        if #available(macOS 14, *) {
            #expect(sample.display == 1)
        } else {
            #expect(sample.display == nil)
            let app = AppState()
            app.streamedDisplay = sample.display
            #expect(app.streamedDisplay == nil || app.phoneInUse)
        }
    }

    @Test("未知选屏和已结束的推流不报告屏幕；停止信号仍然生效")
    func unknownAndStoppedCapture() {
        let began = Date(timeIntervalSince1970: 1_000)
        var state = CaptureSessionState()
        state.apply(CaptureLogRecord(date: began, event: .captureStarted))
        let unknown = CaptureLogWatcher.observation(of: state, at: began.addingTimeInterval(1))
        #expect(unknown.active && unknown.display == nil)

        state.apply(CaptureLogRecord(date: began.addingTimeInterval(2), event: .captureStopped))
        let stopped = CaptureLogWatcher.observation(of: state, at: began.addingTimeInterval(10))
        #expect(!stopped.active && stopped.display == nil)
    }
}
