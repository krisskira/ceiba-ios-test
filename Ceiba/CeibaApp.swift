import SwiftUI

@main
struct CeibaApp: App {
    @ObservedObject private var router = RouterService()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.route) {
                HStack {
                    SplashScreen()
                        .navigationDestination(for: Route.self) { $0.getScreen() }
                }
            }
            .environmentObject(router)
            .preferredColorScheme(.light)
        }
    }
}
