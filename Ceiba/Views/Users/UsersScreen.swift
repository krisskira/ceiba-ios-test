import SwiftUI

struct UsersScreen: View {
    
    @EnvironmentObject var router: RouterService
    @ObservedObject var viewModel = UsersViewModel()

    func onFilterBy(keyword: String) -> Void {
        viewModel.findUsersBy(name: keyword)
    }
    
    var body: some View {
        VStack {
            ZStack{
                VStack {
                    VStack {
                        SearchTextInput(
                            onChange: { viewModel.findUsersBy(name: $0) }
                        )
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 12)

                    if !viewModel.users.isEmpty {
                        
                        List(viewModel.users) {
                            ListUserCellView($0) { router.goToUserPosts(user: $0) }
                                .listRowSeparator(.hidden)
                        }
                        .listStyle(.plain)
                    }
                    
                    if viewModel.users.isEmpty {
                        GeometryReader { content in
                            VStack() {
                                // Spacer().frame(height: content.size.height * 0.1)
                                Image("empty-list")
                                    .resizable()
                                    .frame(width: 250, height: 300)
                                Text("No hay usuarios para listar.")
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .frame(width: content.size.width, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .frame(width: content.size.width, height: content.size.height)
                        }
                        Spacer()
                    }
                }
                ProgressPopup(show: $viewModel.showLoading)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Text("Prueba de Ingreso")
                    .foregroundColor(Color("OnAccentColor"))
                    .font(.title3)
                    .bold()
            }
        }
        .navigationBarBackButtonHidden()
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarBackground(Color("AccentColor"), for: .navigationBar)
        .toolbarColorScheme(.dark, for:.navigationBar)
        .onAppear() {
            Task {  [self] in
                await self.viewModel.getUsers()
            }
        }
    }
}

struct UsersListView_Previews: PreviewProvider {
    static var previews: some View {
        @ObservedObject var router = RouterService()
        UsersScreen()
            .environmentObject(router)
    }
}


