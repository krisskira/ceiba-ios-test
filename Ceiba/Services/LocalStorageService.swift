import Foundation

class LocalStorageService {
    private let USERS_KEY = "users"
    private let POSTS_KEY = "post:userId"
    private let userDefault = UserDefaults.standard
    
    private func save(key: String, value: Codable) {
        guard
            let jssonData = try? JSONEncoder().encode(value),
            let jsonString = String(data: jssonData, encoding: .utf8)
        else  { return }
        userDefault.setValue(jsonString, forKey: key)
    }
    
    private func postKeyBuilder(_ userId: Int) -> String {
        "\(POSTS_KEY):\(userId)"
    }

    func clearAll() {
        userDefault
            .dictionaryRepresentation()
            .keys
            .forEach {
                userDefault.removeObject(forKey: $0)
            }
    }
    
    init(){
        // clearAll()
    }
}

extension LocalStorageService: ApiService {

    func get<T: Codable>(endpoint: Endpoint) async -> (T?, Error?) {
        var data: T? = nil
        // print("\n>>> 🏠 Cargando datos desde local.")
        switch endpoint {
        case .Users:
            guard
                let jsonString = userDefault.string(forKey: USERS_KEY),
                let jsonData = jsonString.data(using: .utf8),
                let jsonObject = try? JSONDecoder().decode([UserModel].self, from: jsonData)
            else {
                return (nil, nil)
            }
            data = jsonObject as? T

        case .UserPosts(let userId):
            guard
                let jsonString = userDefault.string(forKey: postKeyBuilder(userId)),
                let jsonData = jsonString.data(using: .utf8),
                let jsonObject = try? JSONDecoder().decode([PostModel].self, from: jsonData)
            else {
                return (nil, nil)
            }
            data = jsonObject as? T
        }

        return (data, nil)
    }
}

extension LocalStorageService: StorageService {
    func save(_ users: [UserModel]){
        save(key: USERS_KEY, value: users)
    }
    
    func save(userId: Int, _ post: [PostModel]){
        save(key: postKeyBuilder(userId), value: post)
    }
}
