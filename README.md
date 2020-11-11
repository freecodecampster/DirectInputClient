# DirectInputClient

 Built using Swift Playgrounds. Available for macOS and iPadOS.
 Buttons in Playground send keystrokes to Windows Applications and Games. Create separate Playgrounds for each game. 
 
 Requires DirectInputServer https://github.com/freecodecampster/DirectInputServer
 
 Copy the code from https://github.com/freecodecampster/DirectInputClient/blob/master/PlaygroundCode.swift into a PlaygroundPage to get started.
 
 How it works
 ![How it works](https://github.com/freecodecampster/DirectInputServer/blob/master/images/DI.jpeg)
 
 
http://www.youtube.com/watch?v=7ppZ2OEdLFg
[![Screencast of DirectInputClient and DirectInputServer working together](https://img.youtube.com/vi/7ppZ2OEdLFg/0.jpg)](http://www.youtube.com/watch?v=7ppZ2OEdLFg)

 Install Visual Studio Code and a Python 3 Environment.
 https://code.visualstudio.com
 https://www.python.org

 Install the Python extension for Visual Studio Code.

 Run DirectInputServer.py

 On your Mac or Ipad open Swift Playgrounds and copy in the playground code from https://github.com/freecodecampster/DirectInputClient into your Swift Playground

 Enter your Server IP address
 /// Address of Python Server that simulates HID inputs
let serverIPAddress = "192.168.68.128"

To create a button you call MakeButton with the arguments for the text you want the button to display, messageToSend is an array of Scancodes up to three are supported (look at the code to see all available codes), optional text color and another optional argument whether the key command should toggle on and off.

MakeButton(text: "Switch App", messageToSend: [Scancode.LeftAlt, Scancode.Tab], buttonColor: .red)

MakeButton(text: "Shift Lock", messageToSend: [Scancode.LeftShift], buttonColor: .red, buttonToggle: true)


https://guides.github.com/features/mastering-markdown/
