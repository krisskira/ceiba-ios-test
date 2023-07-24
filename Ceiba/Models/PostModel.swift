import Foundation

struct PostModel: Codable, Identifiable, Hashable {
    let id: Int
    let userId: Int
    let title: String
    let body: String
    
    init(id: Int, userId: Int, title: String, body: String) {
        self.id = id
        self.userId = userId
        self.title = title
        self.body = body
    }
    
    init() {
        self.id = 0
        self.userId = 0
        self.title = ""
        self.body = ""
    }
}
