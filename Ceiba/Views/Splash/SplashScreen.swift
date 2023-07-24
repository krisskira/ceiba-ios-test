import Foundation
import SwiftUI

struct SplashScreen: View {
    @EnvironmentObject var router:  RouterService

    var body: some View {
        ZStack{
            Color("OnAccentColor")
            Image("company_logo")
                .resizable()
                .scaledToFit()
                .frame(width: 200)
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .onAppear() {
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
                router.goToUsers()
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        let router = RouterService()
        SplashScreen()
            .environmentObject(router)
    }
}
