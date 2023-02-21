import Foundation
@testable import LessonApp

class MockLessonsRequestManager: LessonsRequestManagerProtocol {
    var shouldReturnNegativeResponse: Bool = false

    func fetchLessons(_ completion: @escaping WebRequestCompletionHandler<[Lesson]>) {
        if shouldReturnNegativeResponse {
            completion(.failure(LessonListViewModelTests.sampleError))
        } else {
            completion(.success(LessonListViewModelTests.sampleLessons))
        }
    }
}
