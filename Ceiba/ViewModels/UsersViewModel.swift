import SwiftUI
import Combine

class UsersViewModel: ObservableObject {
    @Published var users: [UserModel] = []
    @Published var showLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil
    private var allUsers: [UserModel] = []
    
    private let apiRepository: ApiService
    private let localRepository: StorageService
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        apiRepository: ApiService = JsonPlaceHolderApiService(),
        localRepository: StorageService = LocalStorageService()
    ){
        self.apiRepository = apiRepository
        self.localRepository = localRepository
    }
    
    var showEmptyList: Bool {
        get {
            return users.isEmpty
        }
    }
    
    func getUsers() async {
        withAnimation {
            self.showLoading = true
        }
        defer {
            DispatchQueue.main.async {
                withAnimation {
                    self.showLoading =  false
                } 
            }
        }
        
        if let users = await getUsersFromLocal() {
            self.users = users
            self.allUsers = users
            return
        }
        
        if let users = await getUsersFromApi() {
            self.users = users
            self.allUsers = users
            return
        }
        
        self.users = []
        self.allUsers = []
    }
    
    func findUsersBy(name: String) {
        if name.isEmpty {
            users = allUsers
            return
        }
        users = allUsers.filter {
            $0.name.lowercased().contains(name.lowercased())
        }
    }
    
    private func getUsersFromLocal() async -> [UserModel]? {
        let (users, _) = (await localRepository.get(endpoint: .Users)) as ([UserModel]?, Error?)
        return users
    }
    
    private func getUsersFromApi() async -> [UserModel]? {
        let (users, error) = await apiRepository.get(endpoint: .Users) as ([UserModel]?, Error?)
        if let users = users {
            localRepository.save(users)
            return users
        }
        
        errorMessage = error?.localizedDescription ?? "Data is unreadable"
        showError = true
        return nil
    }
}
