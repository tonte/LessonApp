import XCTest

class LessonListViewTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testNavigationTitleExists() {
        let app = XCUIApplication()
        app.launch()
        let timeout = 60

        let navigationTitle =  app.navigationBars["Lessons"].staticTexts["Lessons"]
        XCTAssertTrue(navigationTitle.waitForExistence(timeout: TimeInterval(timeout)))
        
    }

    func testNavigateToDetailsScreen() {
        let app = XCUIApplication()
        app.launch()
        let timeout = 60
        let firstButton = app.tables.cells["The Key To Success In iPhone Photography"].buttons["The Key To Success In iPhone Photography"]
        XCTAssertTrue(firstButton.waitForExistence(timeout: TimeInterval(timeout)))
    }

    func testDetailsScreenDisplay() {
        let app = XCUIApplication()
        app.launch()
        let timeout = 60

        // Navigate To Details Screen

        let firstButton = app.tables.cells["The Key To Success In iPhone Photography"].buttons["The Key To Success In iPhone Photography"]
        firstButton.tap()

        //check if title is displayed
        let titleLabel =  app.staticTexts["The Key To Success In iPhone Photography"]
        XCTAssertTrue(titleLabel.waitForExistence(timeout: TimeInterval(timeout)))

        // check if next lesson button is displayed
        let nextLessonButton =  app.buttons["Next Lesson"].staticTexts["Next Lesson"]
        XCTAssertTrue(nextLessonButton.waitForExistence(timeout: TimeInterval(timeout)))

        // navigate to next lesson
        nextLessonButton.tap()

        // check if navigation to next lesson worked
        let nextLessonTitle = app.staticTexts["How To Choose The Correct iPhone Camera Lens"]
        XCTAssertTrue(nextLessonTitle.waitForExistence(timeout: TimeInterval(timeout)))

    }

}
