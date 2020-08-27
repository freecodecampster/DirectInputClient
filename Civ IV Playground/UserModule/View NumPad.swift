import SwiftUI

struct NumPad: View {
    @Binding var footerText: String
    var body: some View {
        HStack {
            VStack {
                HStack {
                    VStack {
                        CreateButtonsFromArray(footerText: self.$footerText, buttons: numpadColumn1ButtonsArray, font: .system(size: 36), minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80)
                        Spacer()
                    }
                    VStack {
                        CreateButtonsFromArray(footerText: self.$footerText, buttons: numpadColumn2ButtonsArray, font: .system(size: 36), minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80)
                        Spacer()
                    }
                }
                    
                // 0 button placed below 2 VStacks in a HStack in a VStack
                    
                // Best way to figure out layout is play with coloured Rectangles in a Playground
                ButtonView(
                    footerText: self.$footerText,
                    messageText: Scancode.Numpad0.rawValue,
                    toggleButton: false,
                    imageSystemName: "",
                    imageFontSize: .largeTitle,
                    buttonName: "0",
                    foregroundColor: .white,
                    backgroundColor: .gray,
                    font: .system(size: 36),
                    minWidth: 160,
                    maxWidth: 160,
                    minHeight: 80,
                    maxHeight: 80,
                    padding: 5,
                    cornerRadius: 10
                )
                Spacer()
            }
            VStack {
                CreateButtonsFromArray(footerText: self.$footerText, buttons: numpadColumn3ButtonsArray, font: .system(size: 36), minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80)
                Spacer()
            }
            
            // Column 4 has an enter button
            VStack {
                CreateButtonsFromArray(footerText: self.$footerText, buttons: numpadColumn4ButtonsArray, font: .system(size: 36), minWidth: 80, maxWidth: 80, minHeight: 80, maxHeight: 80)
                // Enter Button requires unique dimensions
                ButtonView(
                    footerText: self.$footerText,
                    messageText: Scancode.NumpadEnter.rawValue,
                    toggleButton: false,
                    imageSystemName: "projective",
                    imageFontSize: .largeTitle,
                    buttonName: "",
                    foregroundColor: .white,
                    backgroundColor: .gray,
                    font: .system(size: 36),
                    minWidth: 80,
                    maxWidth: 80,
                    minHeight: 260,
                    maxHeight: 260,
                    padding: 5,
                    cornerRadius: 10
                )
                Spacer()
            }
        }
    }
}
