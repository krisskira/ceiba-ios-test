import Foundation

class UserPostsViewModel: ObservableObject {
    @Published var post: [PostModel] = []
    @Published var showLoading: Bool = false
    @Published var showError: Bool = false
    @Published var errorMessage: String? = nil

    var user: UserModel
    private let apiRepository: ApiService
    private let localRepository: StorageService

    var showEmptyList: Bool {
        get {
            return post.isEmpty
        }
    }
    
    init(
        user: UserModel,
        apiRepository: ApiService = JsonPlaceHolderApiService(),
        localRepository: StorageService = LocalStorageService()
    ){
        self.user = user
        self.apiRepository = apiRepository
        self.localRepository = localRepository
    }
    
    func getPost() async {
        DispatchQueue.main.async {
            self.showLoading = true
        }
        defer {
            DispatchQueue.main.async {
                self.showLoading = false
            }
        }
        
        if let post = await getPostFromLocal() {
            self.post = post
            return
        }
        
        if let post = await getPostFromApi() {
            DispatchQueue.main.async { [self] in
                localRepository.save(userId: user.id, post)
                self.post = post
            }
            return
        }
        
        self.post = []
    }
    
    private func getPostFromLocal() async -> [PostModel]? {
        let (posts, _) = (await localRepository.get(endpoint: .UserPosts(user.id))) as ([PostModel]? , Error?)
        return posts
    }
    
    private func getPostFromApi() async -> [PostModel]? {
        let (data, error) = await apiRepository.get(endpoint: .UserPosts(user.id)) as ([PostModel]?, Error?)
        if data != nil { return data }
        
        errorMessage = error?.localizedDescription ?? "Data is unreadable"
        showError = true
        return nil
    }
}
