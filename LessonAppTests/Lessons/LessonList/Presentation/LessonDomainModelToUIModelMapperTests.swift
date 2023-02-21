import XCTest
@testable import LessonApp

class LessonDomainModelToUIModelMapperTests: XCTestCase {
    let mapper = LessonDomainModelToUiModelMapper()

    let sampleLesson: Lesson =  Lesson(id: 950, name: "The Key To Success In iPhone Photography", description: "adssad", thumbnail: "addasd", videoURL: "adsasdasd")

    let sampleUiModel: LessonView.UiModel = .init(name: "The Key To Success In iPhone Photography", thumbnail: "addasd")


    
    func testMapFunction() {
        let newOutput = mapper.map(sampleLesson)
        XCTAssertTrue(newOutput.name == sampleUiModel.name)
        XCTAssertTrue(newOutput.thumbnail == sampleUiModel.thumbnail)
    }
}
