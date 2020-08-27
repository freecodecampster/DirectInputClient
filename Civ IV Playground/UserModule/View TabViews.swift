import SwiftUI
import PlaygroundSupport
import Foundation
import Network

// MARK: - Views

/// Calling TabViews from outside a module such as from a Playground Page requires the struct, initialiser, and body have public scope
public struct TabViews: View {
    @State private var ipAddress: String = serverIPAddress
    @State private var footerText: String = "Messages sent to server"
    public init() {}
    public var body: some View {
        TabView {
            
                // Display F1-F12 buttons
            ScrollView( .vertical, showsIndicators: true) {
                FirstTabView(ipAddress: $ipAddress, footerText: $footerText)
            }.tabItem {
                Image(systemName: "clock.fill")
                Text("Log")
            }
            ScrollView( .vertical, showsIndicators: true) {
                SecondTabView(ipAddress: $ipAddress, footerText: $footerText)
            }.tabItem {
                Image(systemName: "rectangle.grid.3x2")
                Text("Control")
            }
        }
    }
}





