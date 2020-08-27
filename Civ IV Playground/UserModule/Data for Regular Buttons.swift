import SwiftUI

// MARK: - Data Sources
// Sent string commands should be single space delimited
// "command1 command2 command3"
// A button which sends only one key command can have toggle behaviour useful for the SHIFT key for example
// "<TOGGLEON>command1" presses the key
// "<TOGGLEOFF>command1" releases the key
// "<STOP>" gracefully terminates the connection
let f1f6ButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "house.fill", 
        name: "Domestic", 
        background: Color.red, 
        messageText: "\(Scancode.F1.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "dollarsign.square.fill", 
        name: "Financial", 
        background: Color.init(UIColor.systemYellow), 
        messageText: "\(Scancode.F2.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "person.3.fill", 
        name: "Civics", 
        background: Color.init(red: 255, green: 0, blue: 0), 
        messageText: "\(Scancode.F3.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "tray.full.fill",
        name: "Foreign", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.F4.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "burst.fill",
        name: "Military", 
        background: Color.black, 
        messageText: "\(Scancode.F5.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "bolt.circle.fill",
        name: "Science", 
        background: Color.orange, 
        messageText: "\(Scancode.F6.rawValue)", 
        toggleButton: false
    ),
]

let f7f12ButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "eye.fill",
        name: "Religion", 
        background: Color.pink, 
        messageText: "\(Scancode.F7.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "hand.thumbsup.fill",
        name: "Victory", 
        background: Color.yellow, 
        messageText: "\(Scancode.F8.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "info.circle.fill",
        name: "Info", 
        background: Color.blue, 
        messageText: "\(Scancode.F9.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "bag.fill",
        name: "Capital", 
        background: Color.init(#colorLiteral(red: 0.9607843137254902, green: 0.7058823529411765, blue: 0.2, alpha: 1.0)), 
        messageText: "\(Scancode.F10.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "globe",
        name: "Globe", 
        background: Color.green, 
        messageText: "\(Scancode.F11.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "book.fill",
        name: "Civilopedia", 
        background: Color.init(#colorLiteral(red: 0.8549019607843137, green: 0.25098039215686274, blue: 0.47843137254901963, alpha: 1.0)), 
        messageText: "\(Scancode.F12.rawValue)", 
        toggleButton: false
    )
]

let displayButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "bookmark.fill", 
        name: "Log", 
        background: Color.init(#colorLiteral(red: 0.2196078431372549, green: 0.00784313725490196, blue: 0.8549019607843137, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.Tab.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "app", 
        name: "Tiles", 
        background: Color.init(#colorLiteral(red: 0.4666666666666667, green: 0.7647058823529411, blue: 0.26666666666666666, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.T.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "bookmark.fill", 
        name: "Bare Map", 
        background: Color.init(#colorLiteral(red: 0.5843137254901961, green: 0.8235294117647058, blue: 0.4196078431372549, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.B.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "cart.fill", 
        name: "Yields", 
        background: Color.init(#colorLiteral(red: 0.27450980392156865, green: 0.48627450980392156, blue: 0.1411764705882353, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.Y.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "archivebox.fill", 
        name: "Resources", 
        background: Color.init(#colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.R.rawValue)", 
        toggleButton: false
    )
]

let managementButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "hammer.fill", 
        name: "Worker", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.ForwardSlash.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "person.fill", 
        name: "Prev Unit", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.BackSlash.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "person.crop.square", 
        name: "Next Unit", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Period.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "control", 
        name: "Cycle", 
        background: Color.init(#colorLiteral(red: 0.807843137254902, green: 0.027450980392156862, blue: 0.3333333333333333, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue)", 
        toggleButton: true
    ),
    Buttons(
        imageSystemName: "mappin", 
        name: "Cities", 
        background: Color.init(#colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Insert.rawValue)", 
        toggleButton: false
    )
]

let viewButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "arrow.clockwise.circle.fill", 
        name: "Lock 45°", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.LeftArrow.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "arrow.counterclockwise.circle.fill", 
        name: "Lock 45°", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.RightArrow.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "squares.below.rectangle", 
        name: "Hide UI", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftAlt.rawValue) \(Scancode.I.rawValue)", 
        toggleButton: false
    ),
    Buttons(
        imageSystemName: "person.circle", 
        name: "Center", 
        background: Color.blue, 
        messageText: "\(Scancode.C.rawValue)", 
        toggleButton: false
    )
]


