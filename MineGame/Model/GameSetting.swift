//
//  GameSetting.swift
//  MineGame
//
//  Created by lemonshark on 2022/12/29.
//

import Foundation
import SwiftUI

class GameSetting: ObservableObject {
    // the number of rows on the board
    @Published var numOfRows = 14
    
    // the number of columns on the board
    @Published var numOfColumns = 14
    
    // the number of rows on the board
    @Published var numberOfBombs = 22
    
    var squareSize: CGFloat {
        UIScreen.main.bounds.width/CGFloat(numOfColumns)
    }
}
