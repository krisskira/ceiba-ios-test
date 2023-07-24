import XCTest
import Combine
@testable import Ceiba

final class PostViewModelTests: XCTestCase {
    var cancellables = Set<AnyCancellable>()
    
    override func setUpWithError() throws { }
    override func tearDownWithError() throws { }
    
    func test_ShouldLoadDataFromAPI() async throws {
        let waiter = XCTWaiter()
        let expectedDataSourcesCalls = XCTestExpectation(description: "The data source services are calleds")
        expectedDataSourcesCalls.expectedFulfillmentCount = 2
        
        let mockLocalRepository = LocalStorageServiceMock(returnNil: true)
        let mockApiRepository = ApiServiceMock()
        let userPostsViewModel = UserPostsViewModel(user: USER_DATA, apiRepository: mockApiRepository, localRepository: mockLocalRepository)
        
        userPostsViewModel.$post.dropFirst().sink(receiveValue: { posts in
            XCTAssertGreaterThanOrEqual(posts.count, 0, "First call the number of post is 0 and then is the mockup amount")
            expectedDataSourcesCalls.fulfill()
        }).store(in: &cancellables)
        
        await userPostsViewModel.getPost()
        await waiter.fulfillment(of: [expectedDataSourcesCalls], timeout: 10)

        XCTAssertTrue(mockLocalRepository.getCalled, "Should call local service")
        XCTAssertTrue(mockApiRepository.getCalled, "Should load data from api server")
        XCTAssertEqual(userPostsViewModel.post.count, LIST_POST_DATA.filter { $0.userId == USER_DATA.id}.count, "Should has the same mount of posts")
    }
    
    func test_ShouldLoadDataFormLocalService() async throws {
        let waiter = XCTWaiter()
        let expectedDataSourcesCalls = XCTestExpectation(description: "The data source services are calleds")
        
        let mockLocalRepository = LocalStorageServiceMock()
        let mockApiRepository = ApiServiceMock()
        
        let userPostsViewModel = UserPostsViewModel(user: USER_DATA, apiRepository: mockApiRepository, localRepository: mockLocalRepository)
        
        userPostsViewModel.$post.dropFirst().sink(receiveValue: { posts in
            let totalPosts = LIST_POST_DATA.filter { $0.userId == USER_DATA.id}.count
            XCTAssertEqual(posts.count, totalPosts, "First call the number of post is 0 and then is the mockup amount")
            expectedDataSourcesCalls.fulfill()
        }).store(in: &cancellables)
        
        await userPostsViewModel.getPost()
        await waiter.fulfillment(of: [expectedDataSourcesCalls], timeout: 10)
        
        XCTAssertTrue(mockLocalRepository.getCalled, "Should call local service")
        XCTAssertFalse(mockApiRepository.getCalled, "Should load data from api server")
        XCTAssertEqual(userPostsViewModel.post.count, LIST_POST_DATA.filter { $0.userId == USER_DATA.id}.count, "Should has the same mount of posts")
    }
    
}
