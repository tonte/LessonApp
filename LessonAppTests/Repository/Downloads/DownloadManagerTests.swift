import Foundation
import XCTest

@testable import LessonApp

class DownloadManagerTests: XCTestCase {

    var downloadManager: DownloadManager = DownloadManager()
    var downloadComplete: Bool = false
    var downloadPercentage: Float = 0.0

    let sampleLesson: Lesson =  Lesson(
        id: 950,
        name: "The Key To Success In iPhone Photography",
        description: "adssad",
        thumbnail: "https://embed-ssl.wistia.com/deliveries/b57817b5b05c3e3129b7071eee83ecb7.jpg?image_crop_resized=1000x560",
        videoURL: "adsasdasd"
    )
    var downloadCompleteExpectation: XCTestExpectation?
    var downloadProgressExpectation: XCTestExpectation?

    func testCancelDownload() {
        guard let url = URL(string: self.sampleLesson.thumbnail) else { return }
        downloadManager.download(from: url)
        downloadManager.cancelDownload(from: url)
        XCTAssertTrue(downloadManager.currentDownloads.isEmpty)
    }

    func testImageDownloadComplete() {
            self.downloadManager.delegate = self
            guard let url = URL(string: self.sampleLesson.thumbnail) else { return }
            downloadCompleteExpectation = self.expectation(description: "downloading")
            self.downloadManager.download(from: url)
            waitForExpectations(timeout: 10, handler: nil)
            XCTAssertTrue(self.downloadComplete)
    }

    func testDownloadProgress() {
        self.downloadManager.delegate = self
        guard let url = URL(string: self.sampleLesson.thumbnail) else { return }
        downloadCompleteExpectation = self.expectation(description: "downloading")
        self.downloadManager.download(from: url)
        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(self.downloadPercentage > 0.0)
    }
}

extension DownloadManagerTests: DownloadManagerDelegate {
    func downloadProgressChanged(percentage: Float, downloadUrl: URL?) {
        if percentage > 0.0 {
            self.downloadPercentage = percentage
            downloadProgressExpectation?.fulfill()
        }
    }

    func downloadComplete(from: URL?, to: URL?) {
        downloadComplete = true
        downloadCompleteExpectation?.fulfill()
    }


}
