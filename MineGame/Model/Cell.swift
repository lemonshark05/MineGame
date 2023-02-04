//
//  Cell.swift
//  MineGame
//
//  Created by lemonshark on 2022/12/30.
//

import SwiftUI

class Cell: ObservableObject {
    /// The row of the cell on the board
    var row: Int

    /// The column of the cell on the board
    var column: Int

    @Published var status: Status

    @Published var isOpened: Bool
    
    @Published var isFlagged: Bool
    
    var image: Image {
        if !isOpened && isFlagged {
            return Image("flag")
        }

        switch status {
        case .bomb:
            if isOpened {
                return Image("bomb")
            }

            return Image("normal")
        case .normal:
            return Image("normal")
        case .exposed(let total):
            if !isOpened {
                return Image("normal")
            }
            if total == 0 {
                return Image("empty")
            }
            return Image("\(total)")
        }
    }
    init(row: Int, column: Int) {
        self.row = row
        self.column = column
        self.status = .normal
        self.isOpened = false
        self.isFlagged = false
    }
}

extension Cell {
    
    enum Status: Equatable {
        
        case normal

        case exposed(Int)

        case bomb
    }
}
