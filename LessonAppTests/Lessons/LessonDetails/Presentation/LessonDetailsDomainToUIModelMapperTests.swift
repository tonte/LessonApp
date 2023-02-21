import Foundation
import XCTest
@testable import LessonApp

class LessonDetailsDomainToUIModelMapperTests: XCTestCase {

    let mapper = LessonDetailsDomainToUIModelMapper()

    let sampleLesson: Lesson =  Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd")

    let expectedUiModel: LessonDetailsView.UiModel = .init(
        thumbnailUrl: "addasd",
        titleLabel: "The Key To Success In iPhone Photography",
        descriptionLabel: "adssad",
        videoURL: "adsasdasd"
    )

    func testMap() {
        let testUiModel =  mapper.map(sampleLesson)
        XCTAssertTrue(testUiModel.thumbnailUrl == expectedUiModel.thumbnailUrl)
        XCTAssertTrue(testUiModel.titleLabel == expectedUiModel.titleLabel)
        XCTAssertTrue(testUiModel.descriptionLabel == expectedUiModel.descriptionLabel)
        XCTAssertTrue(testUiModel.videoURL == expectedUiModel.videoURL)
    }
}
