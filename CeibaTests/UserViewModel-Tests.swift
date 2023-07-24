import XCTest
import Combine
@testable import Ceiba

final class UserViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }
    
    func test_ShouldShownListEmpty() async throws {
        let userViewModel = UsersViewModel()
        XCTAssertEqual(userViewModel.users.count, 0, "Should has 0 users")
        XCTAssertTrue(userViewModel.showEmptyList, "Should shown the user is empty")
    }
    
    func test_ShouldFilterUserByName() async throws {
        let mockLocalRepository = LocalStorageServiceMock()
        let userViewModel = UsersViewModel(localRepository: mockLocalRepository)
        await userViewModel.getUsers()
        XCTAssertGreaterThan(userViewModel.users.count, 0, "Should has all amount of mock users")
        userViewModel.findUsersBy(name: USER_DATA.name)
        XCTAssertEqual(userViewModel.users.count, 1, "Should has one mock users")
        XCTAssertEqual(userViewModel.users.first?.name, USER_DATA.name, "Should has the same data that mock users")
    }

    func test_ShouldLoadDataFromAPI() async throws {
        let waiter = XCTWaiter()
        let expectedDataSourcesCalls = XCTestExpectation(description: "The data source services are calleds")
        expectedDataSourcesCalls.expectedFulfillmentCount = 2

        let mockLocalRepository = LocalStorageServiceMock(returnNil: true)
        let mockApiRepository = ApiServiceMock()

        let userViewModel = UsersViewModel(apiRepository: mockApiRepository, localRepository: mockLocalRepository)

        userViewModel.$users.dropFirst().sink(receiveValue: { users in
            XCTAssertGreaterThanOrEqual(users.count, 0)
            expectedDataSourcesCalls.fulfill()
        }).store(in: &cancellables)

        await userViewModel.getUsers()
        await waiter.fulfillment(of: [expectedDataSourcesCalls], timeout: 10)

        XCTAssertTrue(mockLocalRepository.getCalled, "Should call local service")
        XCTAssertTrue(mockApiRepository.getCalled, "Should load data from api server")
        XCTAssertEqual(userViewModel.users.count, LIST_USERS_DATA.count, "Should has the same mount of users")
    }

    func test_ShouldLoadDataFormLocalService() async throws {
        let waiter = XCTWaiter()
        let expectedDataSourcesCalls = XCTestExpectation(description: "The localstorage service load data")
        
        let mockLocalRepository = LocalStorageServiceMock(returnNil: false)
        let mockApiRepository = ApiServiceMock()
        
        let userViewModel = UsersViewModel(apiRepository: mockApiRepository, localRepository: mockLocalRepository)
        
        userViewModel.$users.dropFirst().sink(receiveValue: { users in
            XCTAssertGreaterThanOrEqual(users.count, LIST_USERS_DATA.count)
            expectedDataSourcesCalls.fulfill()
        }).store(in: &cancellables)
        
        await userViewModel.getUsers()
        await waiter.fulfillment(of: [expectedDataSourcesCalls], timeout: 10)
        
        XCTAssertTrue(mockLocalRepository.getCalled, "Should try to load from local")
        XCTAssertFalse(mockApiRepository.getCalled, "Should not load data from api server")
        XCTAssertEqual(userViewModel.users.count, LIST_USERS_DATA.count, "Should has the same mount of users")
    }

}
