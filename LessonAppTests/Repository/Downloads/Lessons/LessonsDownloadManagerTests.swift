import Foundation
import XCTest
@testable import LessonApp

class LessonsDownloadManagerTests: XCTestCase {
    var lessonDownloadManager: LessonsDownloadManager?

    let sampleLesson: Lesson =  Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd")

    func setupLessonsDownloadManager(
        downloadManager: MockDownloadManager = .init(),
        storageManager: MockLessonsStorageManager = .init()

    ) {
        lessonDownloadManager = .init(
            downloadManager: downloadManager,
            storageManager: storageManager
        )
    }

    func testDownloadLesson() {
        setupLessonsDownloadManager()
        guard let lessonDownloadManager = lessonDownloadManager else {
            return
        }
        lessonDownloadManager.downloadLesson(lesson: sampleLesson)
        XCTAssertTrue(lessonDownloadManager.isLessonDownloading(sampleLesson))
    }

    func testIsLessonDownloading() {
        setupLessonsDownloadManager()
        guard let lessonDownloadManager = lessonDownloadManager else {
            return
        }
        XCTAssertFalse(lessonDownloadManager.isLessonDownloading(sampleLesson))
        lessonDownloadManager.downloadLesson(lesson: sampleLesson)
        XCTAssertTrue(lessonDownloadManager.isLessonDownloading(sampleLesson))
    }

    func testCancelLessonDownload() {
        setupLessonsDownloadManager()
        guard let lessonDownloadManager = lessonDownloadManager else {
            return
        }
        lessonDownloadManager.downloadLesson(lesson: sampleLesson)
        lessonDownloadManager.cancelLessonDownload(lesson: sampleLesson)
        XCTAssertFalse(lessonDownloadManager.isLessonDownloading(sampleLesson))
    }
}
