import Foundation

class ApiServiceMock: ApiService {
    var getCalled: Bool = false
    
    func get<T: Codable>(endpoint: Endpoint) async -> (T?, Error?) {
        getCalled = true
        
        var data: T?
        switch endpoint {
        case .Users:
            data = LIST_USERS_DATA  as? T
        case .UserPosts(let userId):
            let _data = LIST_POST_DATA.filter{ $0.userId == userId}
            data = _data as? T
        }
        return (data, nil) as (T?, Error?)
    }
}

class LocalStorageServiceMock: ApiService, StorageService {
    var getCalled: Bool = false
    var saveUsersCalled: Bool = false
    var savePostsCalled: Bool = false
    private var returnNilMock: Bool = false
    
    init() { }

    init(returnNil: Bool? = false) {
        returnNilMock = returnNil ?? false
    }
    
    func save(_ users: [UserModel]) {
        saveUsersCalled = true
    }
    
    func save(userId: Int, _ post: [PostModel]) {
        savePostsCalled = true
    }
    
    func get<T: Codable>(endpoint: Endpoint) async -> (T?, Error?) {
        getCalled = true

        if(self.returnNilMock) {
            switch endpoint {
            case .Users:
                return (nil, nil) as (T?, Error?)
            case .UserPosts(_):
                return (nil, nil) as (T?, Error?)
            }
        }

        var data: T?
        switch endpoint {
        case .Users:
            data = LIST_USERS_DATA  as? T
        case .UserPosts(let userId):
            let _data = LIST_POST_DATA.filter{ $0.userId == userId}
            data = _data as? T
        }
        return (data, nil) as (T?, Error?)
    }
}

class UsersViewModelMock: UsersViewModel {
    
    var findByUserCalled: Bool = false
    var getUsersCalled: Bool = false
    var getLocal: Bool = false

    init() {
        let apiRepository = ApiServiceMock()
        let localRepository = LocalStorageServiceMock()
        
        super.init(
            apiRepository: apiRepository,
            localRepository: localRepository
        )
    }
    
    override func findUsersBy(name: String) {
        findByUserCalled = true
        super.findUsersBy(name: name)
    }
    
    override func getUsers() async {
        getUsersCalled = true
        await super.getUsers()
    }
    
}
