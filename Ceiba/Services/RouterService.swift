import Foundation
import SwiftUI

class RouterService: ObservableObject {
    
    @Published var route: [Route] = [.Splash]
    
    func goToUsers() {
        route = [.Users]
    }
    
    func goToUserPosts (user: UserModel) {
        route.append(.UserPosts(user: user))
    }
    
    func goBack() {
        let _ = route.popLast()
    }
}

enum Route: Hashable {
    case Splash
    case Users
    case UserPosts(user: UserModel?)
    
    @ViewBuilder
    func getScreen() -> some View {
        switch self {
        case .Splash:
            SplashScreen()
        case .Users:
            UsersScreen()
        case .UserPosts(let user):
            UserScreen(user: user!)
        }
    }
}
