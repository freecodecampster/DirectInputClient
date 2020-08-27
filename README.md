# DirectInputClient

 Built using Swift Playgrounds. Available for macOS and iPadOS.
 Buttons in Playground send keystrokes to Windows Applications and Games. Create separate Playgrounds for each game. 
 
 Requires DirectInputServer https://github.com/freecodecampster/DirectInputServer
 
 How it works
 ![How it works](https://github.com/freecodecampster/DirectInputServer/blob/master/images/DI.jpeg)
 
 Playground Screenshot v3
![Playground Screenshot](https://github.com/freecodecampster/DirectInputClient/blob/master/Playgroundv3.jpeg)

Example provided works with Civilization IV.

 The application/game needs to be the foremost window to receive the commands.

## Requirements

iPad running iOS 13+ Playgrounds and Windows 10. The Python server runs on Windows 10. A pre-built executable is available. Make sure the latest versions of both DirectInputClient and DirectInputServer are used as how commands are processed is likely to have changed.

## Usage

The code provided is an example of how to use SwiftUI Buttons in a Playground to send textual commands to a Python server. You are expected to know enough Swift to edit it for your own purposes. There is an abundance of SwiftUI tutorials available on Apple Developer, and Youtube. SwiftUI is the easiest interface API I have come across I'd say it's even easier to implement than HTML and JavaScript.

A SwiftUI interface is composed of a hierarchy of views. You might have a TabView at the very top. Then each tab view contains another view and so on.

You can download a release and open it in a Playground or build up a Playground from the source files. 

# What each Swift file does

## PlaygroundPage.swift 

The root SwiftUI view is defined here. It calls another view which is inside a user module. Keeping all the Swift files in a user module has the benefit that all the code is available amongst these files without having to modify file access levels. The view you call from root has to be marked as Public as well as its initialiser and body.

# Code placed in a user module

## Connection To Server.swift

This defines the serverIPAddress - make sure it matches the IP address of the computer hosting the Python server DirectInputServer. The class TCPClient creates a connection to the server so the Playground can communicate to the server. Every time a message is sent it is sent with sharedTCPClient of which only one instance is created.

## Data Model Buttons.swift

It's easier to define data in one place and use separate code to define presentation. Arrays of buttons are used and their properties are defined here.

## Data NumPad Buttons.swift

Array of buttons that will be used with CreateButtonsFromArray to create a keyboard number pad.

## Data for Regular Buttons.swift

Arrays of buttons that will be used with CreateButtonsFromArray to create stacks of buttons.

## Enum Scancodes.swift

Defines every keystroke that can be sent

## View ButtonView.swift

This view defines a SwiftUI button and its properties that can be modified.

## View Connection to Server.swift

A row that displays the Server IP address and a button to gracefully stop the connection.

## View CreateButtonsFromArray.swift

Pass an array of type buttons to this struct and for each array item a SwiftUI button will be created.

## View FirstTabView.swift

This view provides the presentation for the first tab.

## View FooterView.swift

This row shows messages sent to DirectInputServer.

## View NumPad.swift

Call NumPad() in a containing view and a number pad on a keyboard will be created.

## View SecondTabView.swift

This view provides the presentation for the second tab.

## View TabViews.swift

This is called from the PlaygroundPage and creates a TabView. Here you can define how many tabs, their icons and tab names. For each tab you can define its content.

# Basics of implementation

Specify the IP Address of the Server - run ipconfig at the command prompt on Windows to find the ipv4 address

// MARK: - Server Address

/// Address of Python Server that simulates key presses
let serverIPAddress = "192.168.0.16"

Next tell the playground what buttons need to be displayed and their properties that is name, key to press, image to display and so on. A Swift array is used for each stack buttons.

If I wanted two buttons in the first stack:

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

Each button can display an image as defined by https://developer.apple.com/design/human-interface-guidelines/sf-symbols/overview/

You can then pass this array to CreateButtonsFromArray which create a SwiftUI button for each array item. Embed these in a stack or other suitable view.

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

## Test Environment
iPad Pro 9.7 on iOS 14 beta running Swift Playgrounds and Windows 10 v2004.
Local Wireless Network.

## Results 
Very quick from button press to executing the key press in game. Playgrounds have a very small file size. Robust, reliable communication with Network API.
