// DirectInputClient v2
// 15/07/2020
// Freecodecampster
// https://github.com/freecodecampster/DirectInputClient

import SwiftUI
import PlaygroundSupport
import Foundation
import Network

// MARK: - Server Address

/// Address of Python Server that simulates key presses
let serverIPAddress = "192.168.0.16"

// MARK: - Client Connection

/// Creates a connection to Python Server and sends messages to the server.
public class TCPClient {
    // Singleton pattern
    private static var sharedTCPClient: TCPClient?
    
    let port: NWEndpoint.Port = 10001
    public var connection: NWConnection
    var queue: DispatchQueue
    
    // private init required for singleton
    private init(name: String, serverIPAddress: String) {
        queue = DispatchQueue(label: "TCP Client Queue")
        let params = NWParameters()
        //          params.allowLocalEndpointReuse = true
        let tcp = NWProtocolTCP.Options.init()
        //        tcp.noDelay = true
        //        tcp.enableFastOpen = true
        //        tcp.disableAckStretching = true
        //                tcp.enableKeepalive = true
        //        tcp.connectionDropTime = 1
        //        tcp.maximumSegmentSize = 160
        //        tcp.noPush = true
        //        tcp.connectionTimeout = 1
        params.defaultProtocolStack.transportProtocol = tcp
        // Create the connection
        connection = NWConnection(host: NWEndpoint.Host(serverIPAddress), port: port, using: params)
        
        // Set the state update handler
        connection.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                // Handle connection established
                print("Ready to send")
            //                self.sendInitialFrame()
            case .waiting( _):
                // Handle connection waiting for network
                print("Waiting for connection")
            case .failed(let error):
                // Handle fatal connection error
                print("Client failed with error: \(error)")
            default:
                break
            }
        }
        
        // Start the connection
        connection.start(queue: queue)
    }
    
    // MARK: - Client Accessors
    
    // Required for singleton
    public static func returnSingleton(serverIPAddress: String) -> TCPClient {
        if TCPClient.sharedTCPClient == nil {
            TCPClient.sharedTCPClient = TCPClient(name: "Key Listener", serverIPAddress: serverIPAddress)
        }
        return TCPClient.sharedTCPClient!
    }
    
    // MARK: - Client Functions
    
    public func sendMessage(text: String, isComplete: Bool, on connection: NWConnection) {
        print("Ready to send message")
        
        // This send method works both on xcode playground and ios playground
        // iscomplete needs to be set to false to allow subsequent messages. Only send iscomplete: true after the final message to close the connection and prevent Vicreo Key Listener from crashing in windows 10 because of an abrupt termination
        connection.send(content: text.data(using: .utf8), contentContext: NWConnection.ContentContext.finalMessage, isComplete: isComplete, completion: NWConnection.SendCompletion.contentProcessed({ (error) in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Message sent")
            }
        }))
    }
}

// Initialises TCPClient
let tcpClient = TCPClient.returnSingleton(serverIPAddress: serverIPAddress)

// MARK: - Button Code

/// Call this struct to create a button. You do not have write initialiser(s) for a struct they are automatically generated. Just pass the parameter(s) in the call.
struct ButtonCode: View {
    // footerText State var defined in Parent ButtonView updated by Button actions
    @Binding var footerText: String
    // message to send to server
    var messageText: String = ""
    // should the connection be terminated?
    var isComplete: Bool = false
    // should Button toggle keypresses on and off
    var toggleButton: Bool = false
    // keep track toggle Button state
    @State private var keyToggledOn: Bool = false
    // Button asthetics
    var imageSystemName: String = "house.fill"
    var buttonName: String = ""
    var foregroundColor: Color = .white
    var backgroundColor: Color = .gray
    var font: Font = .system(size: 26)
    var minWidth: CGFloat = 150
    var minHeight: CGFloat = 80
    // You can specify .infinity
    var maxHeight: CGFloat = 80
    var maxWidth: CGFloat = 150
    var padding: CGFloat = 5
    var cornerRadius: CGFloat = 10
    
    var body: some View {
        Button(action: {
            print(self.buttonName)
            var stringSentToServer: String = ""
            if self.toggleButton {
                if self.keyToggledOn {
                    stringSentToServer = "<TOGGLEOFF>" + self.messageText
                    self.keyToggledOn.toggle()
                } else {
                    stringSentToServer += "<TOGGLEON>" + self.messageText
                    self.keyToggledOn.toggle()
                }
            } else {
                stringSentToServer = self.messageText
            }
            self.footerText = stringSentToServer
            tcpClient.sendMessage(text: stringSentToServer, isComplete: self.isComplete, on: tcpClient.connection)
        }, label: {
            VStack {
                Image(systemName: imageSystemName)
                    .font(.largeTitle)
                    .padding(.top)
                Spacer()
                Text(self.buttonName)
                    .font(.subheadline)
            }
            .padding(padding)
            .frame(minWidth: minWidth, maxWidth: maxWidth, minHeight: minHeight, maxHeight: maxHeight)
            .foregroundColor(foregroundColor)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.white, lineWidth: 2.0)
                    .background(backgroundColor
                        .cornerRadius(cornerRadius))
            )
                .opacity(toggleButton ? keyToggledOn ? 1.0 : 0.5 : 1.0)
                .shadow(radius: 5)
        })
    }
}

// MARK: - Data Model

/// The definition of the buttons data model. To use with SwiftUI it needs to conform to Identifiable and therefore have an id property.
struct Buttons: Identifiable {
    var id = UUID()
    var imageSystemName: String
    var name: String
    var background: Color
    var messageText: String
    var toggleButton: Bool
}

// MARK: - Data Sources
// Sent string commands should be single space delimited
// "command1 command2 command3"
// A button which sends only one key command can have toggle behaviour useful for the SHIFT key for example
// "<TOGGLEON>command1" presses the key
// "<TOGGLEOFF>command1" releases the key
// "<STOP>" gracefully terminates the connection
let firstButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "house.fill", 
        name: "Domestic", 
        background: Color.red, 
        messageText: "\(Scancode.F1.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "dollarsign.square.fill", 
        name: "Financial", 
        background: Color.init(UIColor.systemYellow), 
        messageText: "\(Scancode.F2.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "person.3.fill", 
        name: "Civics", 
        background: Color.init(red: 255, green: 0, blue: 0), 
        messageText: "\(Scancode.F3.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "tray.full.fill",
        name: "Foreign", 
        background: Color.init( colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.F4.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "burst.fill",
        name: "Military", 
        background: Color.black, 
        messageText: "\(Scancode.F5.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "bolt.circle.fill",
        name: "Science", 
        background: Color.orange, 
        messageText: "\(Scancode.F6.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "eye.fill",
        name: "Religion", 
        background: Color.pink, 
        messageText: "\(Scancode.F7.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "hand.thumbsup.fill",
        name: "Victory", 
        background: Color.yellow, 
        messageText: "\(Scancode.F8.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "info.circle.fill",
        name: "Info", 
        background: Color.blue, 
        messageText: "\(Scancode.F9.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "bag.fill",
        name: "Capital", 
        background: Color.init( colorLiteral(red: 0.9607843137254902, green: 0.7058823529411765, blue: 0.2, alpha: 1.0)), 
        messageText: "\(Scancode.F10.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "globe",
        name: "Globe", 
        background: Color.green, 
        messageText: "\(Scancode.F11.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "book.fill",
        name: "Civilopedia", 
        background: Color.init( colorLiteral(red: 0.8549019607843137, green: 0.25098039215686274, blue: 0.47843137254901963, alpha: 1.0)), 
        messageText: "\(Scancode.F12.rawValue)", 
        toggleButton: false)
]

let secondButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "bookmark.fill", 
        name: "Log", 
        background: Color.init( colorLiteral(red: 0.2196078431372549, green: 0.00784313725490196, blue: 0.8549019607843137, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.Tab.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "app", 
        name: "Tiles", 
        background: Color.init( colorLiteral(red: 0.4666666666666667, green: 0.7647058823529411, blue: 0.26666666666666666, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.T.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "bookmark.fill", 
        name: "Bare Map", 
        background: Color.init( colorLiteral(red: 0.5843137254901961, green: 0.8235294117647058, blue: 0.4196078431372549, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.B.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "cart.fill", 
        name: "Yields", 
        background: Color.init( colorLiteral(red: 0.27450980392156865, green: 0.48627450980392156, blue: 0.1411764705882353, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.Y.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "archivebox.fill", 
        name: "Resources", 
        background: Color.init( colorLiteral(red: 0.7215686274509804, green: 0.8862745098039215, blue: 0.592156862745098, alpha: 1.0)), 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.R.rawValue)", 
        toggleButton: false)
]

let thirdButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "hammer.fill", 
        name: "Worker", 
        background: Color.init( colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.ForwardSlash.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "person.fill", 
        name: "Prev Unit", 
        background: Color.init( colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.BackSlash.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "person.crop.square", 
        name: "Next Unit", 
        background: Color.init( colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Period.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "mappin", 
        name: "Cities", 
        background: Color.init( colorLiteral(red: 0.803921568627451, green: 0.803921568627451, blue: 0.803921568627451, alpha: 1.0)), 
        messageText: "\(Scancode.Insert.rawValue)", 
        toggleButton: false)
]

let fourthButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "arrow.clockwise.circle.fill", 
        name: "Lock 45°", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.LeftArrow.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "arrow.counterclockwise.circle.fill", 
        name: "Lock 45°", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftControl.rawValue) \(Scancode.RightArrow.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "squares.below.rectangle", 
        name: "Hide UI", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftAlt.rawValue) \(Scancode.I.rawValue)", 
        toggleButton: false),
    Buttons(
        imageSystemName: "person.circle", 
        name: "Center", 
        background: Color.blue, 
        messageText: "\(Scancode.C.rawValue)", 
        toggleButton: false)
]

let fifthButtonsArray: [Buttons] = [
    Buttons(
        imageSystemName: "arrow.clockwise.circle.fill", 
        name: "Switch App", 
        background: Color.blue, 
        messageText: "\(Scancode.LeftAlt.rawValue) \(Scancode.Tab.rawValue)", 
        toggleButton: false)
    
]

struct Preview: View {
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            ButtonView()
        }
    }
    
}

/// Calling ButtonView() in another View requires a public scope initialiser and returns a ButtonView
public struct ButtonView: View {
    @State private var ipAddress: String = serverIPAddress
    @State private var footerText: String = "Messages sent to server"
    
    public init() {}
    
    public var body: some View {
        Group {
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
            }.padding(.all, 10)
            HStack {
                VStack {
                    ForEach (firstButtonsArray) { button in
                        ButtonCode(
                            footerText: self.$footerText,
                            messageText: button.messageText,
                            toggleButton: button.toggleButton,
                            buttonName: button.name, 
                            backgroundColor: button.background)
                    }
                    // Spacer ensures button are pushed to the top not centred in the VStack
                    Spacer()
                }.padding(.trailing, 15)
                VStack {
                    ForEach (secondButtonsArray) { button in
                        ButtonCode(
                            footerText: self.$footerText,
                            messageText: button.messageText,
                            toggleButton: button.toggleButton,
                            buttonName: button.name, 
                            backgroundColor: button.background)
                    }
                    Spacer()
                }.padding(.trailing, 15)
                VStack {
                    ForEach (thirdButtonsArray) { button in
                        ButtonCode(
                            footerText: self.$footerText,
                            messageText: button.messageText,
                            toggleButton: button.toggleButton,
                            buttonName: button.name, 
                            backgroundColor: button.background)
                    }
                    Spacer()
                }.padding(.trailing, 15)
                VStack {
                    ForEach (fourthButtonsArray) { button in
                        ButtonCode(
                            footerText: self.$footerText,
                            messageText: button.messageText,
                            toggleButton: button.toggleButton,
                            buttonName: button.name, 
                            backgroundColor: button.background)
                    }
                    Spacer()
                }.padding(.trailing, 15)
                VStack {
                    ForEach (fifthButtonsArray) { button in
                        ButtonCode(
                            footerText: self.$footerText,
                            messageText: button.messageText,
                            toggleButton: button.toggleButton,
                            buttonName: button.name, 
                            backgroundColor: button.background)
                    }
                    Spacer()
                }.padding(.trailing, 15)
            }.padding()
            // State variable footerText updates this view
            HStack {
                Text(footerText)
            }.padding().frame(minWidth: 400, idealWidth: 600, maxWidth: .infinity, minHeight: 30, idealHeight: 30, maxHeight: .infinity, alignment: .center)
        }
    }
}

PlaygroundPage.current.setLiveView(Preview())

// iOS Playground only not valid in Xcode Playgrounds
PlaygroundPage.current.wantsFullScreenLiveView = true