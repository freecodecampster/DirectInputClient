# DirectInputClient
 Send keystrokes from an iPad Playground to Windows DirectX Games.
 
 ![Playground Screenshot](https://github.com/freecodecampster/DirectInputServer/blob/master/images/DI.jpeg)
 
## An Example

Sending P for pause from iPad Playground. Enum Scancode enumerates every possible command. rawValue returns a string.

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

The singleton pattern is used extensively in this Swift playground.

To keep the playground from slowing down place as much Swift code in the sources folder as this allows the compiler to precompile these files as it knows they won't be edited during execution.

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
The game needs to be the foremost window to receive the commands.

## Requirements

iPad running iOS 13 Playgrounds and
Windows Desktop.


## Test Environment
iPad Pro 9.7 running iOS 13 Playgrounds
and Windows 10 v1909.
Local Wireless Network.

## Results 
Very quick from button press to executing the key press in game. Playgrounds have a very small file size. Robust, reliable communication with Network API.

https://guides.github.com/features/mastering-markdown/
