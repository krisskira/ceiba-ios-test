import SwiftUI

struct ListUserCellView: View {
    let user: UserModel
    var onSelect: ((UserModel) -> Void)?
    
    init(_ user: UserModel, _ onSelect: ((UserModel) -> Void)? = nil) {
        self.user = user
        self.onSelect = onSelect
    }
    
    var body: some View {
        
        
        //            Rectangle()
        //                .background(Color.red)
        //                .frame(height: 150)
        
        ZStack {
            Color.white
            VStack(alignment: .leading) {
                Text(user.name)
                    .font(Font.title3)
                    .foregroundColor(Color("AccentColor"))
                    .bold()
                    .padding(.bottom, 4)
                    .accessibilityIdentifier("card_users_name")
                HStack {
                    Image(systemName: "phone.fill")
                        .padding(.trailing, 8)
                        .foregroundColor(Color("AccentColor"))
                    Text(user.phone)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
                .padding(.vertical, 1)
                HStack {
                    Image(systemName: "envelope.fill")
                        .padding(.trailing, 8)
                        .foregroundColor(Color("AccentColor"))
                    Text(user.email)
                        .foregroundColor(.black)
                        .font(.system(size: 14))
                }
                HStack {
                    Spacer()
                    Button {
                        onSelect?(user)
                    }
                label: {
                    Text("VER PUBLICACIONES")
                        .foregroundColor(Color("AccentColor"))
                        .font(.caption)
                        .bold()
                }
                .buttonStyle(.plain)
                }
                .padding(.vertical, 8)
            }
            .padding(16)
        }
        .background(Color("OnAccentColor"))
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 2, x: 0, y: 4)
        .frame(height: 150)
    }
    
}

struct ListUserCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListUserCellView(USER_DATA) { user in }
            .previewLayout(.sizeThatFits)
    }
}

