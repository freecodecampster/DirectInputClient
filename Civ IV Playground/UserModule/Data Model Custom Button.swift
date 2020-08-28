import SwiftUI

// MARK: - Data Model

/// The definition of the buttons data model. To use with SwiftUI it needs to conform to Identifiable and therefore have an id property.
public struct CustomButton: Identifiable {
    public var id = UUID()
    var imageSystemName: String
    var name: String
    var background: Color
    var messageText: String
    var toggleButton: Bool
}
