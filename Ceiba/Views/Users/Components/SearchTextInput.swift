import SwiftUI

struct SearchTextInput: View {
    private let acccentColor = Color("AccentColor")
    
    private var onChange: ((_ text: String) -> Void)? = nil
    private var onPressSearchUserButton: ((_ text: String) -> Void)? = nil
    
    @State var filterInput: String = ""
    
    init(
        onChange: ((_ text: String) -> Void)? = nil,
        onPressSearchUserButton: ((_ text: String) -> Void)? = nil
    ) {
        self.onChange = onChange
        self.onPressSearchUserButton = onPressSearchUserButton
    }
    
    var body: some View {
        VStack (alignment: .leading){
            Text("Buscar usuario")
                .font(.caption)
                .foregroundColor(acccentColor)
            HStack() {
                TextField(
                    "Jon Doe",
                    text: $filterInput
                )
                .autocorrectionDisabled(true)
                .foregroundColor(acccentColor)
                .onChange(of: filterInput) { newValue in
                    onChange?(newValue)
                }
                Button {
                    onPressSearchUserButton?(filterInput)
                } label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .padding(.trailing, 8)
                        .foregroundColor(acccentColor)
                }
            }
            Divider().overlay(acccentColor).padding(.bottom, 4)
        }
    }
}

struct SearchTextInput_Previews: PreviewProvider {
    static var previews: some View {
        SearchTextInput()
            .previewLayout(
                .sizeThatFits
            )
    }
}
