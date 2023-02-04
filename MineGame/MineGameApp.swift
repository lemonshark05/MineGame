//
//  MineGameApp.swift
//  MineGame
//
//  Created by lemonshark on 2022/12/30.
//

import SwiftUI

@main
struct MineGameApp: App {
    var gameSettings = GameSetting()
    var body: some Scene {
        WindowGroup {
            BoardView()
                .environmentObject(Game(from: gameSettings))
        }
    }
}
