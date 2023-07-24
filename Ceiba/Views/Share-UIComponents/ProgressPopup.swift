import SwiftUI

struct ProgressPopup: View {
    @Binding var show: Bool
    @State var showBackdrop: Bool = false
    @State var alphaBackdrop = 0.0
    @State var alphaModalBody = 0.0
    @State var scaleModalBody = 2.0
    
    var body: some View {
        VStack {
            if showBackdrop {
                ZStack{
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                    HStack(spacing: 16) {
                        ProgressView()
                        Text("Por favor espere.")
                    }
                    .padding(8)
                    .frame(width: 250, height: 100)
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 4)
                    .scaleEffect(x: scaleModalBody, y: scaleModalBody)
                    .opacity(alphaModalBody)
                }
                .opacity(alphaBackdrop)
                .animation(.spring(), value: 1)
            }
        }
        .onChange(of: show, perform: { newValue in
            if (newValue) {
                alphaModalBody = 0
                scaleModalBody = 2
                showBackdrop = true
                withAnimation(.easeInOut(duration: 0.5)) {
                    alphaBackdrop = 1
                    DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            alphaModalBody = 1
                            scaleModalBody = 1
                        }
                    }
                }
                return
            }
            
            scaleModalBody = 1
            alphaModalBody = 1
            alphaBackdrop = 1
            withAnimation {
                alphaModalBody = 0
                scaleModalBody = 2
                alphaBackdrop = 0
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                    withAnimation {
                        showBackdrop = false
                    }
                }
            }
            return
        })
    }
}

struct Popup_Previews: PreviewProvider {
    static var previews: some View {
        @State var show: Bool = true
        ProgressPopup(show: $show)
    }
}
