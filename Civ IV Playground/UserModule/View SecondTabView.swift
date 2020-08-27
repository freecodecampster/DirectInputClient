import SwiftUI

struct SecondTabView: View {
    @Binding var ipAddress: String
    @Binding var footerText: String
    
    var body: some View {
        VStack {
            // View displays server connection and disconnection button
            ConnectionToServerView(ipAddress: $ipAddress, footerText: $footerText)
            
            HStack {
                VStack {
                    VStack {
                        
                        HStack {
                            CreateButtonsFromArray(footerText: $footerText, buttons: displayButtonsArray, minWidth: 120, maxWidth: 120, minHeight: 100, maxHeight: 100)
                        }.padding(.trailing, 15)
                        
                        HStack {
                            CreateButtonsFromArray(footerText: $footerText, buttons: managementButtonsArray, minWidth: 120, maxWidth: 120, minHeight: 100, maxHeight: 100)
                        }.padding(.trailing, 15)
                        
                        HStack {
                            CreateButtonsFromArray(footerText: $footerText, buttons: viewButtonsArray, minWidth: 120, maxWidth: 120, minHeight: 100, maxHeight: 100)
                        }.padding(.trailing, 15)
                    }
                }
                            
                NumPad(footerText: $footerText)
            }
            
            FooterView(ipAddress: $ipAddress, footerText: $footerText)
    }
}
}

