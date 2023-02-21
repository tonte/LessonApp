import Foundation
@testable import LessonApp

class MockDownloadManager: DownloadManagerProtocol {
    var delegate: DownloadManagerDelegate?
    func download(from url: URL) {}
    func cancelDownload(from url: URL) {}

}
