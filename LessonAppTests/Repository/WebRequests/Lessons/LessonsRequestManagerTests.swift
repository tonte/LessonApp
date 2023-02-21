import Foundation
import Foundation
import XCTest
@testable import LessonApp

class LessonsRequestManagerTests: XCTestCase {
    var lessonsRequestManager = LessonsRequestManager()
    var fetchLessonCompleteExpectation: XCTestExpectation?

    func testFetchLessons() {
        fetchLessonCompleteExpectation = self.expectation(description: "fetchingLessons")
        lessonsRequestManager.fetchLessons({[ weak self] result in
            switch result {
            case .success(let lessons):
                self?.fetchLessonCompleteExpectation?.fulfill()
                XCTAssertTrue(lessons.count > 0)
            case .failure(_):
                self?.fetchLessonCompleteExpectation?.fulfill()
                XCTAssert(false)
            }
        })
        waitForExpectations(timeout: 30, handler: nil)
    }
}
