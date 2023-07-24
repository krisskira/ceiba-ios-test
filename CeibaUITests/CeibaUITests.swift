import XCTest

final class CeibaUITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws { }

    func testNavigateToPosts() throws {
        let app = XCUIApplication()
        
        let labelUserNameExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts.matching(identifier: "card_users_name").firstMatch, handler: nil
        )
        let buttonSeePublicationExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.buttons["VER PUBLICACIONES"].firstMatch, handler: nil
        )
       
        wait(
            for: [labelUserNameExpectation, buttonSeePublicationExpectation],
            timeout: 5
        )
        
        let cardLabelUserName = app.staticTexts.matching(identifier: "card_users_name").firstMatch
        let seePublicationsButton = app.buttons["VER PUBLICACIONES"].firstMatch

        XCTAssertTrue(cardLabelUserName.exists, "Should shown a user name")
        XCTAssertTrue(seePublicationsButton.exists, "Should shown VER PUBLICACIONES button")

        let usernameString = cardLabelUserName.label

        seePublicationsButton.tap()
        
        let titleUserDetailExpectation = expectation(
            for: NSPredicate(format: "exists == true"),
            evaluatedWith: app.staticTexts[usernameString],
            handler: nil
        )

        wait(
            for: [titleUserDetailExpectation],
            timeout: 5
        )

        let userDetailTitle = app.staticTexts[usernameString]

        XCTAssertTrue(userDetailTitle.exists, "Should shown the user name")
        XCTAssertEqual(userDetailTitle.label, usernameString, "Should shown the samee username the prevous model selected")
    }
    
    func testFilterByName() throws {
        XCTAssertTrue(true, "TODO Should shown one mock user filter")
    }
    
    func testShownListEmpty() throws {
        XCTAssertTrue(true, "TODO Should shown the list is empty")
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
