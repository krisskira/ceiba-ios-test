import SwiftUI

struct UserScreen: View {
    @EnvironmentObject var router:  RouterService
    @ObservedObject var viewModel: UserPostsViewModel
    private let accentColor = Color("AccentColor")
    let user: UserModel
    
    init(user: UserModel) {
        self.user = user
        viewModel = UserPostsViewModel(user: user)
        Task { [self] in
            await viewModel.getPost()
        }
    }
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            VStack(alignment: .leading) {
                ZStack(alignment: .top) {
                    Rectangle()
                        .foregroundColor(accentColor)
                        .frame(height: 110)
                        .shadow(color: .black, radius: 1, x: 0, y: 1)
                    HStack(alignment: .top) {
                        VStack (alignment: .leading){
                            HStack {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                                    .foregroundColor(Color("OnAccentColor").opacity(0.7))
                                
                                Text("@\(user.username)".lowercased())
                                    .font(.callout)
                                    .foregroundColor(Color("OnAccentColor").opacity(0.7))
                                    .bold()
                            }
                            HStack {
                                Image(systemName: "envelope.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                                    .foregroundColor(Color("OnAccentColor").opacity(0.7))
                                
                                Text(user.email.lowercased())
                                    .font(.callout)
                                    .foregroundColor(Color("OnAccentColor").opacity(0.7))
                            }
                            HStack {
                                Image(systemName: "phone.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 18)
                                    .foregroundColor(Color("OnAccentColor").opacity(0.7))
                                Text(user.phone)
                                    .font(.callout)
                                    .foregroundColor(Color("OnAccentColor")
                                        .opacity(0.7))
                            }
                        }
                        Spacer()
                    }
                    .padding(.all, 16)
                    .accessibilityIdentifier("user_details")
                }
                VStack {
                    
                    if !viewModel.post.isEmpty {
                        List(viewModel.post) { post in
                            VStack (alignment: .leading) {
                                Text(post.title)
                                    .font(.title3)
                                    .bold()
                                    .padding(.horizontal, 4)
                                    .padding(.vertical, 8 )
                                    
                                Text(post.body)
                            }
                            .accessibilityIdentifier("post_item")
                        }
                        .background(Color("OnAccentColor"))
                        .listStyle(.plain)
                    }
                    
                    if viewModel.post.isEmpty {
                        GeometryReader { content in
                            VStack() {
                                Spacer().frame(height: content.size.height * 0.1)
                                Image("empty-list")
                                    .resizable()
                                    .frame(width: 250, height: 300)
                                Text("\(user.username) aun no tiene\nposts publicados")
                                    .foregroundColor(Color.black.opacity(0.5))
                                    .frame(width: content.size.width, alignment: .center)
                                    .multilineTextAlignment(.center)
                                
                                Spacer()
                            }
                            .frame(width: content.size.width, height: content.size.height)
                        }
                    }
                }
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        router.goBack()
                    } label: {
                        Image(systemName: "chevron.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Color("OnAccentColor"))
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text(user.name)
                        .font(.title)
                        .foregroundColor(Color("OnAccentColor"))
                        .bold()
                        .accessibilityLabel(user.name)
                        .accessibilityIdentifier("user_detail_title")
                }
            }
            .navigationBarBackButtonHidden()
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Color("AccentColor"), for: .navigationBar)
            .toolbarColorScheme(.dark, for:.navigationBar)
            ProgressPopup(show: $viewModel.showLoading)
        }
    }
}

struct UserScreen_Previews: PreviewProvider {
    
    static var previews: some View {
        
        @ObservedObject var router = RouterService()
        
        UserScreen(user: USER_DATA)
            .environmentObject(router)
    }
}
