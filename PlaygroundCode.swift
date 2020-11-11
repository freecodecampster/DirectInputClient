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
    // Type Color() to bring up a color picker
    var body: some View {
        // Seems to be a bug where you can only have 9 buttons in one VStack/Group/Popover etc, create another and add buttons to that
        ScrollView([.horizontal, .vertical]) {
            HStack {
                VStack {
                    MakeButton(title: "Left Shift", messageToSend: [Scancode.VK_LSHIFT], buttonColor: Color(#colorLiteral(red: 0.6, green: 0.6, blue: 0.6, alpha: 1.0)), buttonToggle: true)
                    MakePopover(
                        title: "Keys", 
                        buttons: [
                            MakeButton(title: "Switch Between Open Apps", messageToSend: [Scancode.VK_MENU, Scancode.VK_TAB], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            // Provide a nil argument and the button use default value for that parameter
                            MakeButton(title: "1", messageToSend: [Scancode.VK_1], buttonColor: nil, buttonToggle: nil),
                            MakeButton(title: "A", messageToSend: [Scancode.VK_A], buttonColor: nil, buttonToggle: nil),
                            MakeButton(title: "Volume Up", messageToSend: [Scancode.VK_VOLUME_UP], buttonColor: nil, buttonToggle: nil)
                        ],
                        backgroundColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))
                    )
                    MakePopoverWithPopovers(
                        title: "Windows Keyboard Shortcuts", 
                        popovers: [
                            MakePopover(
                                title: "🖥 Windows Key", 
                                buttons: [
                                    MakeButton(title: "Show Start Menu", messageToSend: [Scancode.VK_LWIN], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0)),buttonToggle: false),
                                    MakeButton(title: "Show Task Switcher", messageToSend: [Scancode.VK_LWIN, Scancode.VK_TAB], buttonColor: nil, buttonToggle: nil)
                                ],
                                backgroundColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))
                            )
                        ], 
                        backgroundColor: Color(#colorLiteral(red: 0.25882352941176473, green: 0.7568627450980392, blue: 0.9686274509803922, alpha: 1.0)))
                }
            }
        }
    }
}

struct MakePopoverWithPopovers: View {
    @State private var showingPopover = false
    var title: String
    var popovers: [MakePopover]
    var font: Font? = .headline
    var backgroundColor: Color? = .blue
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(backgroundColor!).shadow(radius: 5)
            Button(title) {
                self.showingPopover = true
            }.font(font).foregroundColor(.white).popover(isPresented: self.$showingPopover) {
                ScrollView {
                    ForEach (self.popovers) { popover in
                        popover
                    }
                }
            }.padding()
        }.padding()
    }
}


struct MakePopover: View, Identifiable {
    var id: UUID? = UUID()
    @State private var showingPopover = false
    var title: String
    var buttons: [MakeButton]
    var font: Font? = .headline
    var backgroundColor: Color? = .blue
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(backgroundColor!).shadow(radius: 5)
            Button(title) {
                self.showingPopover = true
            }.font(font).foregroundColor(.white).popover(isPresented: self.$showingPopover) {
                ScrollView {
                    ForEach (self.buttons) { button in
                        button
                    }
                }
            }.padding()
        }.padding()
    }
}

struct MakeButton: View, Identifiable {
    var id: UUID? = UUID()
    var title: String
    var messageToSend: [Scancode]? = []
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
    case VK_LBUTTON // Left mouse button
    case VK_RBUTTON // Right mouse button
    case VK_CANCEL // Control-break processing
    case VK_MBUTTON // Middle mouse button (three-button mouse)
    case VK_XBUTTON1 // X1 mouse button
    case VK_XBUTTON2 // X2 mouse button
    case VK_BACK // BACKSPACE key
    case VK_TAB // TAB key
    case VK_CLEAR // CLEAR key
    case VK_RETURN // ENTER key
    case VK_SHIFT // SHIFT key
    case VK_CONTROL // CTRL key
    case VK_MENU // ALT key
    case VK_PAUSE // PAUSE key
    case VK_CAPITAL // CAPS LOCK key
    case VK_KANA // IME Kana mode
    case VK_HANGUEL // IME Hanguel mode (maintained for compatibility; use VK_HANGUL)
    case VK_HANGUL // IME Hangul mode
    case VK_IME_ON // IME On
    case VK_JUNJA // IME Junja mode
    case VK_FINAL // IME final mode
    case VK_HANJA // IME Hanja mode
    case VK_KANJI // IME Kanji mode
    case VK_IME_OFF // IME Off
    case VK_ESCAPE // ESC key
    case VK_CONVERT // IME convert
    case VK_NONCONVERT // IME nonconvert
    case VK_ACCEPT // IME accept
    case VK_MODECHANGE // IME mode change request
    case VK_SPACE // SPACEBAR
    case VK_PRIOR // PAGE UP key
    case VK_NEXT // PAGE DOWN key
    case VK_END // END key
    case VK_HOME // HOME key
    case VK_LEFT // LEFT ARROW key
    case VK_UP // UP ARROW key
    case VK_RIGHT // RIGHT ARROW key
    case VK_DOWN // DOWN ARROW key
    case VK_SELECT // SELECT key
    case VK_PRINT // PRINT key
    case VK_EXECUTE // EXECUTE key
    case VK_SNAPSHOT // PRINT SCREEN key
    case VK_INSERT // INS key
    case VK_DELETE // DEL key
    case VK_HELP // HELP key
    case VK_0 // 0 key
    case VK_1 // 1 key
    case VK_2 // 2 key
    case VK_3 // 3 key
    case VK_4 // 4 key
    case VK_5 // 5 key
    case VK_6 // 6 key
    case VK_7 // 7 key
    case VK_8 // 8 key
    case VK_9 // 9 key
    case VK_A // A key
    case VK_B // B key
    case VK_C // C key
    case VK_D // D key
    case VK_E // E key
    case VK_F // F key
    case VK_G // G key
    case VK_H // H key
    case VK_I // I key
    case VK_J // J key
    case VK_K // K key
    case VK_L // L key
    case VK_M // M key
    case VK_N // N key
    case VK_O // O key
    case VK_P // P key
    case VK_Q // Q key
    case VK_R // R key
    case VK_S // S key
    case VK_T // T key
    case VK_U // U key
    case VK_V // V key
    case VK_W // W key
    case VK_X // X key
    case VK_Y // Y key
    case VK_Z // Z key
    case VK_LWIN // Left Windows key (Natural keyboard)
    case VK_RWIN // Right Windows key (Natural keyboard)
    case VK_APPS // Applications key (Natural keyboard)
    case VK_SLEEP // Computer Sleep key
    case VK_NUMPAD0 // Numeric keypad 0 key
    case VK_NUMPAD1 // Numeric keypad 1 key
    case VK_NUMPAD2 // Numeric keypad 2 key
    case VK_NUMPAD3 // Numeric keypad 3 key
    case VK_NUMPAD4 // Numeric keypad 4 key
    case VK_NUMPAD5 // Numeric keypad 5 key
    case VK_NUMPAD6 // Numeric keypad 6 key
    case VK_NUMPAD7 // Numeric keypad 7 key
    case VK_NUMPAD8 // Numeric keypad 8 key
    case VK_NUMPAD9 // Numeric keypad 9 key
    case VK_MULTIPLY // Multiply key
    case VK_ADD // Add key
    case VK_SEPARATOR // Separator key
    case VK_SUBTRACT // Subtract key
    case VK_DECIMAL // Decimal key
    case VK_DIVIDE // Divide key
    case VK_F1 // F1 key
    case VK_F2 // F2 key
    case VK_F3 // F3 key
    case VK_F4 // F4 key
    case VK_F5 // F5 key
    case VK_F6 // F6 key
    case VK_F7 // F7 key
    case VK_F8 // F8 key
    case VK_F9 // F9 key
    case VK_F10 // F10 key
    case VK_F11 // F11 key
    case VK_F12 // F12 key
    case VK_F13 // F13 key
    case VK_F14 // F14 key
    case VK_F15 // F15 key
    case VK_F16 // F16 key
    case VK_F17 // F17 key
    case VK_F18 // F18 key
    case VK_F19 // F19 key
    case VK_F20 // F20 key
    case VK_F21 // F21 key
    case VK_F22 // F22 key
    case VK_F23 // F23 key
    case VK_F24 // F24 key
    case VK_NUMLOCK // NUM LOCK key
    case VK_SCROLL // SCROLL LOCK key
    case VK_LSHIFT // Left SHIFT key
    case VK_RSHIFT // Right SHIFT key
    case VK_LCONTROL // Left CONTROL key
    case VK_RCONTROL // Right CONTROL key
    case VK_LMENU // Left MENU key
    case VK_RMENU // Right MENU key
    case VK_BROWSER_BACK // Browser Back key
    case VK_BROWSER_FORWARD // Browser Forward key
    case VK_BROWSER_REFRESH // Browser Refresh key
    case VK_BROWSER_STOP // Browser Stop key
    case VK_BROWSER_SEARCH // Browser Search key
    case VK_BROWSER_FAVORITES // Browser Favorites key
    case VK_BROWSER_HOME // Browser Start and Home key
    case VK_VOLUME_MUTE // Volume Mute key
    case VK_VOLUME_DOWN // Volume Down key
    case VK_VOLUME_UP // Volume Up key
    case VK_MEDIA_NEXT_TRACK // Next Track key
    case VK_MEDIA_PREV_TRACK // Previous Track key
    case VK_MEDIA_STOP // Stop Media key
    case VK_MEDIA_PLAY_PAUSE // Play/Pause Media key
    case VK_LAUNCH_MAIL // Start Mail key
    case VK_LAUNCH_MEDIA_SELECT // Select Media key
    case VK_LAUNCH_APP1 // Start Application 1 key
    case VK_LAUNCH_APP2 // Start Application 2 key
    case VK_OEM_1 // Used for miscellaneous characters; it can vary by keyboard.For the US standard keyboard, the ';:' key
    case VK_OEM_PLUS // For any country/region, the '+' key
    case VK_OEM_COMMA // For any country/region, the ',' key
    case VK_OEM_MINUS // For any country/region, the '-' key
    case VK_OEM_PERIOD // For any country/region, the '.' key
    case VK_OEM_2 // Used for miscellaneous characters; it can vary by keyboard.For the US standard keyboard, the '/?' key
    case VK_OEM_3 // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '`~' key
    case VK_OEM_4 // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '[{' key
    case VK_OEM_5 // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '\|' key
    case VK_OEM_6 // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ']}' key
    case VK_OEM_7 // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the 'single-quote/double-quote' key
    case VK_OEM_8 // Used for miscellaneous characters; it can vary by keyboard.
    case VK_OEM_102 // Either the angle bracket key or the backslash key on the RT 102-key keyboard
    case VK_PROCESSKEY // IME PROCESS key
    case VK_PACKET // Used to pass Unicode characters as if they were keystrokes. The VK_PACKET key is the low word of a 32-bit Virtual Key value used for non-keyboard input methods. For more information, see Remark in KEYBDINPUT, SendInput, WM_KEYDOWN, and WM_KEYUP
    case VK_ATTN // Attn key
    case VK_CRSEL // CrSel key
    case VK_EXSEL // ExSel key
    case VK_EREOF // Erase EOF key
    case VK_PLAY // Play key
    case VK_ZOOM // Zoom key
    case VK_NONAME // Reserved
    case VK_PA1 // PA1 key
    case VK_OEM_CLEAR // Clear key
}

PlaygroundPage.current.setLiveView(MakePlaygroundView().border(Color.gray))
PlaygroundPage.current.wantsFullScreenLiveView = true