import SwiftUI

struct FirstTabView: View {
    @Binding var ipAddress: String
    @Binding var footerText: String
    
    var body: some View {
        VStack {
            // View displays server connection and disconnection button
            ConnectionToServerView(ipAddress: $ipAddress, footerText: $footerText)
            
            VStack {
                
                HStack {
                    CreateButtonsFromArray(footerText: $footerText, buttons: f1f6ButtonsArray, minWidth: 150, maxWidth: 150, minHeight: 150, maxHeight: 150)
                }.padding(.trailing, 15)
                
                HStack {
                    CreateButtonsFromArray(footerText: $footerText, buttons: f7f12ButtonsArray, minWidth: 150, maxWidth: 150, minHeight: 150, maxHeight: 150)
                }.padding(.trailing, 15)
                
            }
            
            FooterView(ipAddress: $ipAddress, footerText: $footerText)
            
        }
    }
}
