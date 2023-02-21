import XCTest
@testable import LessonApp

class LessonListViewModelTests: XCTestCase {
    var lessonListViewModel = LessonListViewModel()

    static let sampleLessons: [Lesson] = [
        Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd"),
        Lesson(id: 7991, name: "How To Choose The Correct iPhone Camera Lens", description: "saddhsiasda", thumbnail: "dajdsjnd", videoURL: "adkskdsmak")
    ]

    static let sampleError: WebRequestError = .jsonDecodingError

    func testFetchLessonsReturnsLessons() throws {
        let mockRequestManager = MockLessonsRequestManager()
        mockRequestManager.shouldReturnNegativeResponse = false
        lessonListViewModel = LessonListViewModel(requestManager: mockRequestManager)
        lessonListViewModel.fetchLessons()
        XCTAssert(lessonListViewModel.lessons == LessonListViewModelTests.sampleLessons)
    }

    func testFetchLessonsReturnsError() {
        let mockRequestManager = MockLessonsRequestManager()
        mockRequestManager.shouldReturnNegativeResponse = true
        lessonListViewModel = LessonListViewModel(requestManager: mockRequestManager)
        lessonListViewModel.fetchLessons()
        XCTAssertNotNil(lessonListViewModel.error)
    }

}
