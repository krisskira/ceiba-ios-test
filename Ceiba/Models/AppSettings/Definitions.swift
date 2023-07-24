import Foundation

protocol ApiService {
    func get<T: Codable>(endpoint: Endpoint) async -> (T?, Error?)
}

protocol StorageService: ApiService {
    func save(_ users: [UserModel])
    func save(userId: Int, _ post: [PostModel])
}

enum Endpoint {
    case Users
    case UserPosts(_ userId: Int)
    
    func buildUrl(baseUrl: String) -> URL? {
        switch self {
        case .Users:
            return URL(string: "\(baseUrl)/users")
        case .UserPosts(let userId):
            return URL(string: "\(baseUrl)/posts?userId=\(userId)")
        }
    }
}
