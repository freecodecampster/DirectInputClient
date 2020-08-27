import SwiftUI

struct FooterView: View {
    @Binding var ipAddress: String
    @Binding var footerText: String
    
    var body: some View {
        Text(footerText).padding().frame(minWidth: 400, idealWidth: .infinity, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: .infinity, alignment: .center).border(Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), width: 1)
    }
}

