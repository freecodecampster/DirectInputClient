import SwiftUI

struct CreateButtonsFromArray: View {
    @Binding var footerText: String
    var buttons: [Buttons]
    // You can also specify the following variables when calling the initialiser
    var imageFontSize: Font = .largeTitle
    var foregroundColor: Color = .white
    var font: Font = .body
    // example: if you pass in a minWidth > default maxWidth Playground will crash, specify a maxWidth as well to avoid
    var minWidth: CGFloat = 100
    var maxWidth: CGFloat = 100
    var minHeight: CGFloat = 80
    var maxHeight: CGFloat = 80
    var padding: CGFloat = 5
    var cornerRadius: CGFloat = 10
    var body: some View {
        Group {
            ForEach (buttons) { button in
                ButtonView(
                    footerText: self.$footerText,
                    messageText: button.messageText,
                    toggleButton: button.toggleButton,
                    imageSystemName: button.imageSystemName,
                    imageFontSize: self.imageFontSize,
                    buttonName: button.name,
                    foregroundColor: self.foregroundColor,
                    backgroundColor: button.background,
                    font: self.font,
                    minWidth: self.minWidth,
                    maxWidth: self.maxWidth,
                    minHeight: self.minHeight,
                    maxHeight: self.maxHeight,
                    padding: self.padding,
                    cornerRadius: self.cornerRadius
                )
            }
        }
    }
}
