// 更新源：只从独立维护仓库取 update.json 和包，避免覆盖为上游版本。
import Foundation

public enum UpdateSource: String, Codable, CaseIterable, Sendable {
    /// GitHub Release
    case github

    public var title: String {
        "GitHub"
    }

    public static let repositoryURL = URL(string: "https://github.com/boycott96/snug-intel-mac")!

    /// 最新发布的 update.json
    public var feedURL: URL {
        downloadPage.appendingPathComponent("latest/download/update.json")
    }

    /// 某个版本下的文件
    public func url(of file: String, in version: Version) -> URL {
        downloadPage.appendingPathComponent("download/v\(version)").appendingPathComponent(file)
    }

    /// 自己换不了时，请用户手动下载的地方
    public var downloadPage: URL {
        Self.repositoryURL.appendingPathComponent("releases")
    }
}
