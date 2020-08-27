import SwiftUI

// MARK: - Button View

/// Call this struct to create a button. You do not have write initialiser(s) for a struct they are automatically generated. Just pass the parameter(s) in the call.
struct ButtonView: View {
    // footerText State var defined in Parent ButtonView updated by Button actions
    @Binding var footerText: String
    // message to send to server
    var messageText: String = ""
    // should the connection be terminated?
    var isComplete: Bool = false
    // should Button toggle keypresses on and off
    var toggleButton: Bool = false
    // keep track toggle Button state
    @State private var keyToggledOn: Bool = false
    // Button asthetics
    var imageSystemName: String = "keyboard"
    var imageFontSize: Font = .largeTitle
    var buttonName: String = ""
    var foregroundColor: Color = .white
    var backgroundColor: Color = .gray
    var font: Font = .body
    // example: if you pass in a minWidth > default maxWidth Playground will crash, specify a maxWidth as well to avoid
    var minWidth: CGFloat = .infinity
    var maxWidth: CGFloat = .infinity
    var minHeight: CGFloat = .infinity
    var maxHeight: CGFloat = .infinity
    var padding: CGFloat = 5
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        Button(action: {
            print(self.buttonName)
            var stringSentToServer: String = ""
            if self.toggleButton {
                if self.keyToggledOn {
                    stringSentToServer = "<TOGGLEOFF>" + self.messageText
                    self.keyToggledOn.toggle()
                } else {
                    stringSentToServer += "<TOGGLEON>" + self.messageText
                    self.keyToggledOn.toggle()
                }
            } else {
                stringSentToServer = self.messageText
            }
            self.footerText = stringSentToServer
            tcpClient.sendMessage(text: stringSentToServer, isComplete: self.isComplete, on: tcpClient.connection)
        }, label: {
            VStack {
                ZStack {
                    Image(systemName: imageSystemName)
                        .font(self.imageFontSize).offset(x: 0, y: maxHeight/5)
                    ZStack {
                        Text(self.buttonName)
                            .font(self.font).baselineOffset(self.maxHeight/2)
                            .shadow(radius: 1, x: 1, y: 1)
                    }
                }
            }
            .padding([.leading, .trailing], padding)
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .foregroundColor(foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2.0)
                    .background(backgroundColor
                        .cornerRadius(cornerRadius).opacity(toggleButton ? keyToggledOn ? 1.0 : 0.5 : 1.0))
            )
                .shadow(radius: 2)
        })
    }
}
