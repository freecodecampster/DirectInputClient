# DirectInputClient
 Press buttons on screen that send keystrokes from an iPad Playground to Windows DirectX Games.
 
 Requires DirectInputServer https://github.com/freecodecampster/DirectInputServer
 
 The code examples below may be out of sync with the latest source code. Check the source code for up to date examples.
 
 How it works
 ![How it works](https://github.com/freecodecampster/DirectInputServer/blob/master/images/DI.jpeg)
 
 Playground Screenshot v3
![Playground Screenshot](https://github.com/freecodecampster/DirectInputClient/blob/master/Playgroundv3.jpeg)

 
 The game needs to be the foremost window to receive the commands.

## Requirements

iPad running iOS 13+ Playgrounds and Windows 10. The Python server runs on Windows 10. A pre-built executable is available. Make sure the latest versions of both DirectInputClient and DirectInputServer are used as how commands are processed is likely to have changed.

This repository is built using Visual Studio 2019 Community Edition. If you're comfortable with Python in another environment the only file required is DirectInputServer.py.

## Usage

Copy the contents of DirectInputClient.swift into a Swift Playground Page on iPadOS. Choose the blank template not the Xcode template as you need to edit the manifest.plist to get the playground to extend beyond the screen's safe area - this plist file doesn't exist in Xcode templates. Also copy the contents of Scancodes.swift into a file of the same name located in the sources folder.

Specify the IP Address of the Server - run ipconfig at the command prompt on Windows to find the ipv4 address

// MARK: - Server Address

/// Address of Python Server that simulates key presses
let serverIPAddress = "192.168.0.16"

Next tell the playground what buttons need to be displayed and their properties that is name, key to press, image to display and so on. A Swift array is used for each vertical column or VStack of buttons.

If I wanted two buttons in the first column:

Swift Code:

```
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
]
```
Each button can display an image as defined by https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/

The messageText is a String that is sent to DirectInputServer which then processes the String and carries out the key commands. Look at DirectInputServer.swift for button examples.

```
// MARK: - Data Sources
// Sent string commands should be single space delimited
// "command1 command2 command3"
// A button which sends only one key command can have toggle behaviour useful for the SHIFT key for example
// "<TOGGLEON>command1" presses the key
// "<TOGGLEOFF>command1" releases the key
// "<STOP>" gracefully terminates the connection
```
In Swift Playgrounds run the playground, tap the buttons and have fun! When it is time to stop press the trash can icon in the top right to close the connection - otherwise your Python Server will just crash. No harm is done it just means you'll have to start the Python Server again if you wish to continue.

## Getting the Playground live view to go beyond the safe area
In Finder go to the playground file and right-click show package contents.

Navigate to the playground page where you want the live view to run. It is buried a few levels deep. For a playground named "My Playground" here is the path.

Blank.playgroundbook/Contents/Chapters/Chapter1.playgroundchapter/Pages/My Playground.playgroundpage/Manifest.plist

With Xcode you can edit the Manifest.plist. Add a key to the root named "LiveViewEdgeToEdge" of type Boolean and set its value to 1(YES).

As an alternative you can download the playground I have uploaded which has the Manifest.plist already edited.

![Liveview Screenshot](https://github.com/freecodecampster/DirectInputClient/blob/master/liveview.jpeg)

## Test Environment
iPad Pro 9.7 on iOS 14 beta running Swift Playgrounds and Windows 10 v2004.
Local Wireless Network.

## Results 
Very quick from button press to executing the key press in game. Playgrounds have a very small file size. Robust, reliable communication with Network API.
 
## An Example

Sending P for pause from iPad Playground. 
DirectInputClient
An enum called Scancode enumerates every possible command. rawValue returns a string that DirectInputServer acts upon.

Swift code:

```swift
Button(action: {
    tcpClient.sendMessage(text: "\(Scancode.P.rawValue)", isComplete: false, on: tcpClient.connection)
}) {
    Text("Pause")
}
```
Sending Ctrl-P.

Swift code:

```swift
Button(action: {
    // Note commands are space separated
    tcpClient.sendMessage(text: "\(Scancode.LeftControl.rawValue) \(Scancode.P.rawValue)", isComplete: false, on: tcpClient.connection)
}) {
    Text("Ctrl-P")
}
```
Implementation of TCP Connection

Swift code:
```swift
import Foundation
import Network

public class TCPClient {
    // Singleton pattern
    private static var sharedTCPClient: TCPClient?
    
    let port: NWEndpoint.Port = 10001
    public let host: NWEndpoint.Host = "192.168.68.105"
    public var connection: NWConnection
    var queue: DispatchQueue
    
    // private init required for singleton
    private init(name: String) {
        queue = DispatchQueue(label: "TCP Client Queue")
        let params = NWParameters()
        let tcp = NWProtocolTCP.Options.init()
        params.defaultProtocolStack.transportProtocol = tcp
        // Create the connection
        connection = NWConnection(host: host, port: port, using: params)
        
        // Set the state update handler
        connection.stateUpdateHandler = { (newState) in 
            switch(newState) {
            case .ready:
                // Handle connection established
                print("Ready to send")
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
    
    // MARK: - Accessors
    
    // Required for singleton
    public static func shared() -> TCPClient {
        if TCPClient.sharedTCPClient == nil {
            TCPClient.sharedTCPClient = TCPClient(name: "Vicreo Key Listener")
        }
        return TCPClient.sharedTCPClient!
    }
    
    // MARK: - Functions
    
    public func sendMessage(text: String, isComplete: Bool, on connection: NWConnection) {
        print("Ready to send message")
        
        // iscomplete needs to be set to false to allow subsequent messages. Only send iscomplete: true after the final message to close the connection.
        connection.send(content: text.data(using: .utf8), contentContext: NWConnection.ContentContext.finalMessage, isComplete: isComplete, completion: NWConnection.SendCompletion.contentProcessed({ (error) in
            if let error = error {
                print("Send error: \(error)")
            } else {
                print("Message sent")
            }
        }))
    }
}
```

The server is implemented by a single python file.

```python
# Create a TCP/IP socket
sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
# Bind the socket to the port
ipAddress = socket.gethostbyname(socket.getfqdn())
port = 10001
server_address = (ipAddress, port)
print("Starting up on ip address %s port %s" % server_address)
sock.bind(server_address)
# Listen for incoming connections
sock.listen(1)
# Receive data
data = connection.recv(160)
tcpString = data.decode()
# Sent string commands should be seperated by single space delimiters
# "command1 command2 command3"
list = tcpString.split()
# Find first command
# Check for empty string
if len(list[0]) > 0:
    command1 = scancodes.get(list[0], "error")
if command1 != "error":
    pressKey(command1)
    releaseKey(command1)
else:
    print("Wrong key")
```


https://guides.github.com/features/mastering-markdown/
