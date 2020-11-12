import SwiftUI
import PlaygroundSupport
import Foundation
import Network

// MARK: - Server Address

/// Address of Python Server that simulates HID inputs
let serverIPAddress = "192.168.68.126"

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
                    MakePopover(
                        title: "System", 
                        buttons: [
                            MakeButton(title: "Open Magnifier", messageToSend: [Scancode.LeftWindows, Scancode.KeyEquals]),
                            MakeButton(title: "Open Action center", messageToSend: [Scancode.LeftWindows, Scancode.A]),
                            MakeButton(title: "Set focus in the notification area", messageToSend: [Scancode.LeftWindows, Scancode.B]),
                            MakeButton(title: "Open Cortana in listening mode", messageToSend: [Scancode.LeftWindows, Scancode.C]),
                            MakeButton(title: "Display date and time", messageToSend: [Scancode.LeftWindows, Scancode.Alt, Scancode.D]),
                            MakeButton(title: "Open File Explorer", messageToSend: [Scancode.LeftWindows, Scancode.E]),
                            MakeButton(title: "Open Feedback Hub and take a screenshot", messageToSend: [Scancode.LeftWindows, Scancode.F]),
                            MakeButton(title: "Open Game Bar", messageToSend: [Scancode.LeftWindows, Scancode.G]),
                            MakeButton(title: "Start dictation", messageToSend: [Scancode.LeftWindows, Scancode.F]),
                            MakeButton(title: "Open Settings", messageToSend: [Scancode.LeftWindows, Scancode.I]),
                            MakeButton(title: "Choose a display mode", messageToSend: [Scancode.LeftWindows, Scancode.P]),
                            MakeButton(title: "Open Quick Assist", messageToSend: [Scancode.LeftWindows, Scancode.CTRL, Scancode.Q]),
                            MakeButton(title: "Open Run", messageToSend: [Scancode.LeftWindows, Scancode.R]),
                            MakeButton(title: "Open Search", messageToSend: [Scancode.LeftWindows, Scancode.S]),
                            MakeButton(title: "Take a screenshot", messageToSend: [Scancode.LeftWindows, Scancode.Shift, Scancode.S]),
                            MakeButton(title: "Open Ease of Access Center", messageToSend: [Scancode.LeftWindows, Scancode.U]),
                            MakeButton(title: "Cycle through notifications", messageToSend: [Scancode.LeftWindows, Scancode.Shift, Scancode.V]),
                            MakeButton(title: "Open the Quick Link menu", messageToSend: [Scancode.LeftWindows, Scancode.X]),
                            MakeButton(title: "Display the System Properties dialog box", messageToSend: [Scancode.LeftWindows, Scancode.Pause]),
                            MakeButton(title: "Search for PCs (if you're on a network", messageToSend: [Scancode.LeftWindows, Scancode.CTRL, Scancode.F]),
                            MakeButton(title: "Take a screenshot and copy it to the clipboard", messageToSend: [Scancode.PrintScreen])
                        ],
                        backgroundColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))
                    )
                    MakePopover(
                        title: "File Explorer", 
                        buttons: [
                            // Assumes File Explorer in position 1 on taskbar
                            MakeButton(title: "File Explorer Jump List", messageToSend: [Scancode.LeftWindows, Scancode.Alt, Scancode.Key1]),
                            MakeButton(title: "File Explorer new instance", messageToSend: [Scancode.LeftWindows, Scancode.Shift, Scancode.Key1]),
                            MakeButton(title: "Rename the selected item", messageToSend: [Scancode.F2]
                            ),
                            MakeButton(title: "Search for a file or folder", messageToSend: [Scancode.F3]
                            ),
                            MakeButton(title: "Display the address bar list", messageToSend: [Scancode.F4]
                            ),
                            MakeButton(title: "Refresh the active window", messageToSend: [Scancode.F5] ),
                            MakeButton(title: "Dislay properties for the selected item", messageToSend: [Scancode.Alt, Scancode.ReturnOrEnter]
                            ),
                            MakeButton(title: "Delete the selected item and move it to the Recycle Bin", messageToSend: [Scancode.CTRL, Scancode.D]
                            )
                        ],
                        backgroundColor: Color(#colorLiteral(red: 0.9529411764705882, green: 0.6862745098039216, blue: 0.13333333333333333, alpha: 1.0))
                    )
                    MakePopover(
                        title: "Text Commands", 
                        buttons: [
                            MakeButton(title: "Open emoji panel", messageToSend: [Scancode.LeftWindows, Scancode.KeyPeriod]),
                            MakeButton(title: "Open the clipboard", messageToSend: [Scancode.LeftWindows, Scancode.V]),
                            MakeButton(title: "Switch input language and keyboard layout", messageToSend: [Scancode.LeftWindows, Scancode.Spacebar], buttonColor: Color(#colorLiteral(red: 0.9254901960784314, green: 0.23529411764705882, blue: 0.10196078431372549, alpha: 1.0))),
                            MakeButton(title: "Cut", messageToSend: [Scancode.CTRL, Scancode.X], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Copy", messageToSend: [Scancode.CTRL, Scancode.C], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Paste", messageToSend: [Scancode.CTRL, Scancode.C], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Undo", messageToSend: [Scancode.CTRL, Scancode.Z], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Redo an action", messageToSend: [Scancode.CTRL, Scancode.Y], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Move the cursor to the beginning of the next word", messageToSend: [Scancode.CTRL, Scancode.Right], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Move the cursor to the beginning of the previous word", messageToSend: [Scancode.CTRL, Scancode.Left], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Move the cursor to the beginning of the next paragraph", messageToSend: [Scancode.CTRL, Scancode.Down], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))),
                            MakeButton(title: "Move the cursor to the beginning of the previous paragraph", messageToSend: [Scancode.CTRL, Scancode.Up], buttonColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0)))
                        ],
                        backgroundColor: Color(#colorLiteral(red: 0.4745098039215686, green: 0.8392156862745098, blue: 0.9764705882352941, alpha: 1.0))
                    )
                    MakePopover(
                        title: "Window Controls", 
                        buttons: [
                            MakeButton(title: "Temporarily peek at the desktop", messageToSend: [Scancode.LeftWindows, Scancode.KeyComma]),
                            MakeButton(title: "Cycle through apps on the taskbar", messageToSend: [Scancode.LeftWindows, Scancode.T]),
                            MakeButton(title: "Open Task Manager", messageToSend: [Scancode.CTRL, Scancode.Shift, Scancode.Escape]),
                            MakeButton(title: "Display the shortcut menu for the selected item", messageToSend: [Scancode.Shift, Scancode.F10]),
                            MakeButton(title: "Close the active document", messageToSend: [Scancode.CTRL, Scancode.F4]),
                            MakeButton(title: "Close app", messageToSend: [Scancode.Alt, Scancode.F4]),
                            MakeButton(title: "Cycle through screen elements", messageToSend: [Scancode.F6]),
                            MakeButton(title: "Activate the Menu bar in the active app", messageToSend: [Scancode.F10]),
                            MakeButton(title: "Cycle through items in the order in which they were opened", messageToSend: [Scancode.Alt, Scancode.Escape]),
                            MakeButton(title: "Open the shortcut menu for the active windows", messageToSend: [Scancode.Alt, Scancode.Spacebar])
                        ], 
                        backgroundColor: Color(#colorLiteral(red: 0.9254901960784314, green: 0.23529411764705882, blue: 0.10196078431372549, alpha: 1.0))
                    )
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
    var scancodeString: String {
        var scancodeString: String = ""
        for scancode in messageToSend! {
            scancodeString += String(describing: scancode) + " "
        }
        return scancodeString
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
            Text(self.scancodeString).font(.caption).foregroundColor(.gray)
        }.padding().opacity(buttonToggle ?? false ? keyToggledOn ? 1.0 : 0.5 : 1.0)
    }
    
}

// These keys can be used with DirectInputServer
// VK_OEM_PLUS is the EQUALS key
// https://docs.microsoft.com/en-us/uwp/api/Windows.System.VirtualKey?view=winrt-19041
// Use Scancode.Escape.rawValue to return a string
enum Scancode: String {
    case LeftMouse = "VK_LBUTTON" // Left mouse button
    case RightMouse = "VK_RBUTTON" // Right mouse button
    case Cancel = "VK_CANCEL" // Control-break processing
    case MiddleMouse = "VK_MBUTTON" // Middle mouse button (three-button mouse)
    case X1Mouse = "VK_XBUTTON1" // X1 mouse button
    case X2Mouse = "VK_XBUTTON2" // X2 mouse button
    case Backspace = "VK_BACK" // BACKSPACE key
    case Tab = "VK_TAB" // TAB key
    case Clear = "VK_CLEAR" // CLEAR key
    case ReturnOrEnter = "VK_RETURN" // ENTER key
    case Shift = "VK_SHIFT" // SHIFT key
    case CTRL = "VK_CONTROL" // CTRL key
    case Alt = "VK_MENU" // ALT key
    case Pause = "VK_PAUSE" // PAUSE key
    case CapsLock = "VK_CAPITAL" // CAPS LOCK key
    case Kana = "VK_KANA" // IME Kana mode
    case Hanguel = "VK_HANGUEL" // IME Hanguel mode (maintained for compatibility; use VK_HANGUL)
    case Hangul = "VK_HANGUL" // IME Hangul mode
    case IMEOn = "VK_IME_ON" // IME On
    case Junja = "VK_JUNJA" // IME Junja mode
    case Final = "VK_FINAL" // IME final mode
    case Hanja = "VK_HANJA" // IME Hanja mode
    case Kanji = "VK_KANJI" // IME Kanji mode
    case IMEOff = "VK_IME_OFF" // IME Off
    case Escape = "VK_ESCAPE" // ESC key
    case Convert = "VK_CONVERT" // IME convert
    case NonConvert = "VK_NONCONVERT" // IME nonconvert
    case Accept = "VK_ACCEPT" // IME accept
    case ModeChange = "VK_MODECHANGE" // IME mode change request
    case Spacebar = "VK_SPACE" // SPACEBAR
    case PageUp = "VK_PRIOR" // PAGE UP key
    case PageDown = "VK_NEXT" // PAGE DOWN key
    case End = "VK_END" // END key
    case Home = "VK_HOME" // HOME key
    case Left = "VK_LEFT" // LEFT ARROW key
    case Up = "VK_UP" // UP ARROW key
    case Right = "VK_RIGHT" // RIGHT ARROW key
    case Down = "VK_DOWN" // DOWN ARROW key
    case Select = "VK_SELECT" // SELECT key
    case Print = "VK_PRINT" // PRINT key
    case Execute = "VK_EXECUTE" // EXECUTE key
    case PrintScreen = "VK_SNAPSHOT" // PRINT SCREEN key
    case Insert = "VK_INSERT" // INS key
    case Delete = "VK_DELETE" // DEL key
    case Help = "VK_HELP" // HELP key
    case Key0 = "VK_0" // 0 key
    case Key1 = "VK_1" // 1 key
    case Key2 = "VK_2" // 2 key
    case Key3 = "VK_3" // 3 key
    case Key4 = "VK_4" // 4 key
    case Key5 = "VK_5" // 5 key
    case Key6 = "VK_6" // 6 key
    case Key7 = "VK_7" // 7 key
    case Key8 = "VK_8" // 8 key
    case Key9 = "VK_9" // 9 key
    case A = "VK_A" // A key
    case B = "VK_B" // B key
    case C = "VK_C" // C key
    case D = "VK_D" // D key
    case E = "VK_E" // E key
    case F = "VK_F" // F key
    case G = "VK_G" // G key
    case H = "VK_H" // H key
    case I = "VK_I" // I key
    case J = "VK_J" // J key
    case K = "VK_K" // K key
    case L = "VK_L" // L key
    case M = "VK_M" // M key
    case N = "VK_N" // N key
    case O = "VK_O" // O key
    case P = "VK_P" // P key
    case Q = "VK_Q" // Q key
    case R = "VK_R" // R key
    case S = "VK_S" // S key
    case T = "VK_T" // T key
    case U = "VK_U" // U key
    case V = "VK_V" // V key
    case W = "VK_W" // W key
    case X = "VK_X" // X key
    case Y = "VK_Y" // Y key
    case Z = "VK_Z" // Z key
    case LeftWindows = "VK_LWIN" // Left Windows key (Natural keyboard)
    case RightWindows = "VK_RWIN" // Right Windows key (Natural keyboard)
    case Apps = "VK_APPS" // Applications key (Natural keyboard)
    case Sleep = "VK_SLEEP" // Computer Sleep key
    case Num0 = "VK_NUMPAD0" // Numeric keypad 0 key
    case Num1 = "VK_NUMPAD1" // Numeric keypad 1 key
    case Num2 = "VK_NUMPAD2" // Numeric keypad 2 key
    case Num3 = "VK_NUMPAD3" // Numeric keypad 3 key
    case Num4 = "VK_NUMPAD4" // Numeric keypad 4 key
    case Num5 = "VK_NUMPAD5" // Numeric keypad 5 key
    case Num6 = "VK_NUMPAD6" // Numeric keypad 6 key
    case Num7 = "VK_NUMPAD7" // Numeric keypad 7 key
    case Num8 = "VK_NUMPAD8" // Numeric keypad 8 key
    case Num9 = "VK_NUMPAD9" // Numeric keypad 9 key
    case NumMultiply = "VK_MULTIPLY" // Multiply key
    case NumAdd = "VK_ADD" // Add key
    case NumSeparator = "VK_SEPARATOR" // Separator key
    case NumSubtract = "VK_SUBTRACT" // Subtract key
    case NumDecimal = "VK_DECIMAL" // Decimal key
    case NumDivide = "VK_DIVIDE" // Divide key
    case F1 = "VK_F1" // F1 key
    case F2 = "VK_F2" // F2 key
    case F3 = "VK_F3" // F3 key
    case F4 = "VK_F4" // F4 key
    case F5 = "VK_F5" // F5 key
    case F6 = "VK_F6" // F6 key
    case F7 = "VK_F7" // F7 key
    case F8 = "VK_F8" // F8 key
    case F9 = "VK_F9" // F9 key
    case F10 = "VK_F10" // F10 key
    case F11 = "VK_F11" // F11 key
    case F12 = "VK_F12" // F12 key
    case F13 = "VK_F13" // F13 key
    case F14 = "VK_F14" // F14 key
    case F15 = "VK_F15" // F15 key
    case F16 = "VK_F16" // F16 key
    case F17 = "VK_F17" // F17 key
    case F18 = "VK_F18" // F18 key
    case F19 = "VK_F19" // F19 key
    case F20 = "VK_F20" // F20 key
    case F21 = "VK_F21" // F21 key
    case F22 = "VK_F22" // F22 key
    case F23 = "VK_F23" // F23 key
    case F24 = "VK_F24" // F24 key
    case NumLock = "VK_NUMLOCK" // NUM LOCK key
    case ScrollLock = "VK_SCROLL" // SCROLL LOCK key
    case LeftShift = "VK_LSHIFT" // Left SHIFT key
    case RightShift = "VK_RSHIFT" // Right SHIFT key
    case LeftCtrl = "VK_LCONTROL" // Left CONTROL key
    case RightCtrl = "VK_RCONTROL" // Right CONTROL key
    case LeftAlt = "VK_LMENU" // Left MENU key
    case RightAlt = "VK_RMENU" // Right MENU key
    case BrowserBack = "VK_BROWSER_BACK" // Browser Back key
    case BrowserForward = "VK_BROWSER_FORWARD" // Browser Forward key
    case BrowserRefresh = "VK_BROWSER_REFRESH" // Browser Refresh key
    case BrowserStop = "VK_BROWSER_STOP" // Browser Stop key
    case BrowserSearch = "VK_BROWSER_SEARCH" // Browser Search key
    case BrowserFavorites = "VK_BROWSER_FAVORITES" // Browser Favorites key
    case BrowserHome = "VK_BROWSER_HOME" // Browser Start and Home key
    case VolumeMute = "VK_VOLUME_MUTE" // Volume Mute key
    case VolumeDown = "VK_VOLUME_DOWN" // Volume Down key
    case VolumeUp = "VK_VOLUME_UP" // Volume Up key
    case NextTrack = "VK_MEDIA_NEXT_TRACK" // Next Track key
    case PrevTrack = "VK_MEDIA_PREV_TRACK" // Previous Track key
    case Stop = "VK_MEDIA_STOP" // Stop Media key
    case PlayPause = "VK_MEDIA_PLAY_PAUSE" // Play/Pause Media key
    case LaunchMail = "VK_LAUNCH_MAIL" // Start Mail key
    case LaunchMedia = "VK_LAUNCH_MEDIA_SELECT" // Select Media key
    case LaunchApp1 = "VK_LAUNCH_APP1" // Start Application 1 key
    case LaunchApp2 = "VK_LAUNCH_APP2" // Start Application 2 key
    case Semicolon = "VK_OEM_1" // Used for miscellaneous characters; it can vary by keyboard.For the US standard keyboard, the ';:' key
    case KeyEquals = "VK_OEM_PLUS" // For any country/region, the '+' key
    case KeyComma = "VK_OEM_COMMA" // For any country/region, the ',' key
    case KeyMinus = "VK_OEM_MINUS" // For any country/region, the '-' key
    case KeyPeriod = "VK_OEM_PERIOD" // For any country/region, the '.' key
    case KeyForwardSlash = "VK_OEM_2" // Used for miscellaneous characters; it can vary by keyboard.For the US standard keyboard, the '/?' key
    case KeyAccentGrave = "VK_OEM_3" // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '`~' key
    case LeftSquareBracket = "VK_OEM_4" // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '[{' key
    case BackSlash = "VK_OEM_5" // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the '\|' key
    case RightSquareBracket = "VK_OEM_6" // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the ']}' key
    case SingleQuote = "VK_OEM_7" // Used for miscellaneous characters; it can vary by keyboard. For the US standard keyboard, the 'single-quote/double-quote' key
    case OEM_8 = "VK_OEM_8" // Used for miscellaneous characters; it can vary by keyboard.
    case AngleOrBackSlash = "VK_OEM_102" // Either the angle bracket key or the backslash key on the RT 102-key keyboard
    case ProcessKey = "VK_PROCESSKEY" // IME PROCESS key
    case Packet = "VK_PACKET" // Used to pass Unicode characters as if they were keystrokes. The VK_PACKET key is the low word of a 32-bit Virtual Key value used for non-keyboard input methods. For more information, see Remark in KEYBDINPUT, SendInput, WM_KEYDOWN, and WM_KEYUP
    case Attn = "VK_ATTN" // Attn key
    case Crsel = "VK_CRSEL" // CrSel key
    case Exsel = "VK_EXSEL" // ExSel key
    case EraseEOF = "VK_EREOF" // Erase EOF key
    case Play = "VK_PLAY" // Play key
    case Zoom = "VK_ZOOM" // Zoom key
    case Noname = "VK_NONAME" // Reserved
    case PA1 = "VK_PA1" // PA1 key
    case OEM_Clear = "VK_OEM_CLEAR" // Clear key
}

PlaygroundPage.current.setLiveView(MakePlaygroundView().border(Color.gray))
PlaygroundPage.current.wantsFullScreenLiveView = true