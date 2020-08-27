// https://github.com/freecodecampster/DirectInputClient
// 27 Aug 2020 v3

import SwiftUI
import PlaygroundSupport
import Foundation
import Network

struct MyPlaygroundView: View {
    var body: some View {
        TabViews()
    }
}

PlaygroundPage.current.setLiveView(MyPlaygroundView().edgesIgnoringSafeArea(.bottom).border(Color.gray))
// iOS Playground only not valid in Xcode Playgrounds
PlaygroundPage.current.wantsFullScreenLiveView = true
