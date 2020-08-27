import SwiftUI

// View displays server connection and disconnection button
struct ConnectionToServerView: View {
    @Binding var ipAddress: String
    @Binding var footerText: String
    
    var body: some View {
        // Interface displays IP Address and Stop connnection button
        HStack {
            Button(action: {
                print("globe")
            }) {
                Image(systemName: "globe")
                    .font(.headline)
            }
            Spacer()
            Text(ipAddress)
                .font(.headline)
            Spacer()
            Button(action: {
                // += required otherwise doesn't work with @State var
                self.ipAddress += " Disconnected"
                // Important! end connection by sending isComplete: true otherwise DirectInputServer will crash on Windows
                tcpClient.sendMessage(text: "<STOP>", isComplete: true, on: tcpClient.connection)
            }) {
                Image(systemName: "trash")
                    .font(.headline)
            }
        }.padding(.all, 10).border(Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), width: 1)
    }
}

