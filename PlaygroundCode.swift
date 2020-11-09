import SwiftUI
import PlaygroundSupport
import Foundation
import Network

// MARK: - Server Address

/// Address of Python Server that simulates HID inputs
let serverIPAddress = "192.168.68.128"

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
        //        params.allowLocalEndpointReuse = true
        let tcp = NWProtocolTCP.Options.init()
        //        tcp.noDelay = true
        //        tcp.enableFastOpen = true
        //        tcp.disableAckStretching = true
        //        tcp.enableKeepalive = true
        //        tcp.connectionDropTime = 1
        //        tcp.maximumSegmentSize = 160
        //        tcp.noPush = true
        //        tcp.connectionTimeout = 1
        params.defaultProtocolStack.transportProtocol = tcp
        // Create the connection
        connection = NWConnection(host: NWEndpoint.Host(serverIPAddress), port: port, using: params)
        
        // Set the state update handler
        connection.stateUpdateHandler = { (newState) in
            switch(newState) {
            case .ready:
                // Handle connection established
                print("Ready to send")
            //                self.sendInitialFrame()
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

// Tab Views cause synchronisation errors with observed objects
struct MakePlaygroundView: View {
    @State private var showingPopover1 = false
    @State private var showingPopover2 = false
    
    var body: some View {
        // Seems to be a bug where you can only have 9 buttons in one VStack/Group/Popover etc, create another and add buttons to that
        ScrollView([.horizontal, .vertical]) {
            HStack {
                VStack {
                    MakeButton(title: "Left Shift Toggle", messageToSend: [Scancode.LeftShift], buttonColor: .gray, buttonToggle: true)
                    MakePopover(
                        title: "I'm a popover", 
                        buttons: [
                            MakeButton(title: "Switch App", messageToSend: [Scancode.LeftAlt, Scancode.Tab], buttonColor: .green), 
                            MakeButton(title: "I am the character A", messageToSend: [Scancode.A]),
                            MakeButton(title: "I'm a button that presses B", messageToSend: [Scancode.B], buttonColor: .blue)
                        ],
                        foregroundColor: .red
                    )
                }
                VStack {
                    MakeButton(title: "I'm a button that presses C", messageToSend: [Scancode.C], buttonColor: .blue)
                    MakePopover(
                        title: "I'm another popover", 
                        buttons: [
                            MakeButton(title: "I press D", messageToSend: [Scancode.D], buttonColor: .green)
                        ],
                        foregroundColor: .red
                    )
                }
            }
        }
    }
}

struct MakePopover: View {
    @State private var showingPopover = false
    var title: String
    var buttons: [MakeButton]
    var font: Font? = .headline
    var foregroundColor: Color? = .blue
    var body: some View {
        Button(title) {
            self.showingPopover = true
        }.font(font).foregroundColor(foregroundColor).popover(isPresented: self.$showingPopover) {
            ScrollView {
                ForEach (self.buttons) { button in
                    button
                }
            }
        }.padding()
    }
}

struct MakeButton: View, Identifiable {
    var id: UUID? = UUID()
    var title: String
    var messageToSend: [Scancode]?
    var buttonColor: Color?
    var buttonToggle: Bool?
    @State private var keyToggledOn: Bool = false
    var buttonAction: String {
        var serverString: String = ""
        for scancode in messageToSend! {
            serverString += scancode.rawValue + " "
        }
        return serverString
    }
    
    var body: some View {
        VStack {
            Button(title, action: {
                var stringSentToServer: String = ""
                if self.buttonToggle ?? false {
                    if self.keyToggledOn {
                        stringSentToServer = "<TOGGLEOFF>" + self.buttonAction
                    } else {
                        stringSentToServer = "<TOGGLEON>" + self.buttonAction
                    }
                    self.keyToggledOn.toggle()
                } else {
                    stringSentToServer = self.buttonAction
                }
                // Send message to server
                tcpClient.sendMessage(text: stringSentToServer, isComplete: false, on: tcpClient.connection)
            }).accentColor(buttonColor).font(.headline)
            // Display keys pressed
            Text(self.buttonAction).font(.caption).foregroundColor(.gray)
        }.padding().opacity(buttonToggle ?? false ? keyToggledOn ? 1.0 : 0.5 : 1.0)
    }
    
}

// These keys can be used with DirectInputServer
// Use Scancode.Escape.rawValue to return a string
enum Scancode: String {
    case Escape
    case Keyboard1
    case Keyboard2
    case Keyboard3
    case Keyboard4
    case Keyboard5
    case Keyboard6
    case Keyboard7
    case Keyboard8
    case Keyboard9
    case Keyboard0
    case Minus
    case Equals
    case Backspace
    case Tab
    case Q
    case W
    case E
    case R
    case T
    case Y
    case U
    case I
    case O
    case P
    case LeftBracket
    case RightBracket
    case Enter
    case LeftControl
    case A
    case S
    case D
    case F
    case G
    case H
    case J
    case K
    case L
    case Semicolon
    case Apostrophe
    case Tilde
    case LeftShift
    case BackSlash
    case Z
    case X
    case C
    case V
    case B
    case N
    case M
    case Comma
    case Period
    case ForwardSlash
    case RightShift
    case NumpadMultiply
    case LeftAlt
    case Spacebar
    case CapsLock
    case F1
    case F2
    case F3
    case F4
    case F5
    case F6
    case F7
    case F8
    case F9
    case F10
    case NumLock
    case ScrollLock
    case Numpad7
    case Numpad8
    case Numpad9
    case NumpadMinus
    case Numpad4
    case Numpad5
    case Numpad6
    case NumpadPlus
    case Numpad1
    case Numpad2
    case Numpad3
    case Numpad0
    case NumpadPeriod
    case F11
    case F12
    case NumpadEnter
    case RightControl
    case NumpadDivide
    case RightAlt
    case Home
    case UpArrow
    case PageUp
    case LeftArrow
    case RightArrow
    case End
    case DownArrow
    case PageDown
    case Insert
    case Delete
    case LeftMouseButton
    case RightMouseButton
    case MiddleMouseWheel
    case MouseButton3
    case MouseButton4
    case MouseButton5
    case MouseButton6
    case MouseButton7
    case MouseWheelUp
    case MouseWheelDown
}

PlaygroundPage.current.setLiveView(MakePlaygroundView().border(Color.gray))
PlaygroundPage.current.wantsFullScreenLiveView = true