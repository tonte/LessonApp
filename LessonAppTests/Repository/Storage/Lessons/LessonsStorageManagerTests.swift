import Foundation
import XCTest
@testable import LessonApp

class LessonsStorageManagerTests: XCTestCase {
    var lessonsStorageManager: LessonsStorageManager?
    let sampleLesson: Lesson =  Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd")

    func setUpLessonStorageManager(
        storageManager: MockStorageManager = .init()
    ) {
        lessonsStorageManager = .init(storageManager: storageManager)
    }

    func testGenerateFileURLForLessonVideo() {
        let storageManager = MockStorageManager()
        storageManager.storageDirectoryURL = URL(string: "test")
        setUpLessonStorageManager(storageManager: storageManager)
        guard let lessonsStorageManager = lessonsStorageManager else {
            return
        }

        XCTAssertTrue(
            lessonsStorageManager.generateFileURLForLessonVideo(sampleLesson) == URL(string: "test")?.appendingPathComponent("\(sampleLesson.id).mp4")
        )
    }

    func testRetrieveLesson() {
        let storageManager = MockStorageManager()
        storageManager.storedFileUrl = URL(string: "test")
        storageManager.storageDirectoryURL = URL(string: "test")
        setUpLessonStorageManager(storageManager: storageManager)
        guard let lessonsStorageManager = lessonsStorageManager else {
            return
        }
        XCTAssertTrue(lessonsStorageManager.retrieveLesson(sampleLesson) == URL(string: "test"))
    }

    func testStoreLesson() {
        let storageManager = MockStorageManager()
        storageManager.storedFileUrl = URL(string: "test")
        storageManager.storageDirectoryURL = URL(string: "test")
        setUpLessonStorageManager(storageManager: storageManager)
        guard let lessonsStorageManager = lessonsStorageManager else {
            return
        }
        guard let url = URL(string: "test") else { return }
        lessonsStorageManager.storeLesson(sampleLesson, from: url)
        XCTAssertTrue(lessonsStorageManager.retrieveLesson(sampleLesson) == URL(string: "test"))
    }


}
