import SwiftUI

// MARK: - Data Sources
// Sent string commands should be single space delimited
// "command1 command2 command3"
// A button which sends only one key command can have toggle behaviour useful for the SHIFT key for example
// "<TOGGLEON>command1" presses the key
// "<TOGGLEOFF>command1" releases the key
// "<STOP>" gracefully terminates the connection

// Arrays to create a number pad
let numpadColumn1ButtonsArray: [CustomButton] = [
    CustomButton(
        imageSystemName: "lock", 
        name: "", 
        background: Color.init(#colorLiteral(red: 0.25882352941176473, green: 0.7568627450980392, blue: 0.9686274509803922, alpha: 1.0)), 
        messageText: "\(Scancode.NumLock.rawValue)", 
        toggleButton: true
    ),
    CustomButton(
        imageSystemName: "", 
        name: "7", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad7.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "4", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad4.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "1", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad1.rawValue)", 
        toggleButton: false
    ),
]
let numpadColumn2ButtonsArray: [CustomButton] = [
    CustomButton(
        imageSystemName: "divide", 
        name: "", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.NumpadDivide.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "8", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad8.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "5", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad5.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "2", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad2.rawValue)", 
        toggleButton: false
    ),
]
let numpadColumn3ButtonsArray: [CustomButton] = [
    CustomButton(
        imageSystemName: "multiply", 
        name: "", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.NumpadMultiply.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "9", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad9.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "6", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad6.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: "3", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Numpad3.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "", 
        name: ".", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.NumpadPeriod.rawValue)", 
        toggleButton: false
    ),
]
let numpadColumn4ButtonsArray: [CustomButton] = [
    CustomButton(
        imageSystemName: "minus", 
        name: "", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.NumpadMinus.rawValue)", 
        toggleButton: false
    ),
    CustomButton(
        imageSystemName: "plus", 
        name: "", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.NumpadPlus.rawValue)", 
        toggleButton: false
    ),
]
