import Foundation
@testable import LessonApp
class MockLessonsStorageManager: LessonsStorageManagerProtocol {
    var lessonUrl: URL?

    func generateFileURLForLessonVideo(_ lesson: Lesson) -> URL? {
        return lessonUrl
    }

    func retrieveLesson(_ lesson: Lesson) -> URL? {
        return lessonUrl
    }

    func storeLesson(_ lesson: Lesson, from: URL) {}
}

