//
//  Game.swift
//  MineGame
//
//  Created by lemonshark on 2022/12/29.
//

import Foundation

class Game: ObservableObject {
    
    @Published var settings: GameSetting

    @Published var board: [[Cell]]

    @Published var showResult: Bool = false
    @Published var isWon: Bool = false;

    init(from settings: GameSetting) {
        self.settings = settings
        board = Self.generateBoard(from: settings)
    }

    func isPlayerWon() -> Bool{
        for row in 0..<settings.numOfRows {
            for col in 0..<settings.numOfColumns{
                if(board[row][col].status == .normal){
                    return false;
                }
            }
        }
        return true;
    }

    func click(on cell: Cell) {
        
        if case Cell.Status.exposed( _ ) = cell.status {
          return
        }

        if (cell.isFlagged){
            return;
        }
        
        if cell.status == .bomb {
            cell.isOpened = true
            showResult = true
            isWon = false;
        } else {
            reveal(for: cell)
        }
        if(isPlayerWon()){
            showResult = true
            isWon = true
        }

        self.objectWillChange.send()
    }

    func toggleFlag(on cell: Cell) {
        guard !cell.isOpened else {
            return
        }

        cell.isFlagged = !cell.isFlagged
        if(isPlayerWon()){
            showResult = true
            isWon = true
        }

        self.objectWillChange.send()
    }

    func reset() {
        board = Self.generateBoard(from: settings)
        showResult = false
        isWon = false
    }

    private func reveal(for cell: Cell) {
        guard !cell.isOpened else {
            return
        }

        guard !cell.isFlagged else {
            return
        }

        guard cell.status != .bomb else {
            return
        }

        let exposedCount = getExposedCount(for: cell)

        if cell.status != .bomb {
            cell.status = .exposed(exposedCount)
            cell.isOpened = true
        }

        if (exposedCount == 0) {
            
            for i in -1...1 {
                for j in -1...1 {
                    var x = cell.row+i;
                    if(x>board.count-1){
                        x = board.count-1;
                    }
                    if(x<0){ x = 0;}
                    var y = cell.column+j;
                    if(y>board[0].count-1){
                        y = board[0].count-1;
                    }
                    if(y<0){ y = 0;}
                    let clickCell = board[x][y]
                    if(!clickCell.isOpened){
                        reveal(for: clickCell)
                    }
                }
            }
        }
    }

    private func getExposedCount(for cell: Cell) -> Int {
        let row = cell.row
        let col = cell.column

        let minRow = max(row - 1, 0)
        let minCol = max(col - 1, 0)
        let maxRow = min(row + 1, board.count - 1)
        let maxCol = min(col + 1, board[0].count - 1)

        var totalBombCount = 0
        for row in minRow...maxRow {
            for col in minCol...maxCol {
                if board[row][col].status == .bomb {
                    totalBombCount += 1
                }
            }
        }

        return totalBombCount
    }

    private static func generateBoard(from settings: GameSetting) -> [[Cell]] {
        var newBoard = [[Cell]]()

        for row in 0..<settings.numOfRows {
            var column = [Cell]()

            for col in 0..<settings.numOfColumns {
                column.append(Cell(row: row, column: col))
            }

            newBoard.append(column)
        }

        var numberOfBombsPlaced = 0
        while numberOfBombsPlaced < settings.numberOfBombs {
            
            let randomRow = Int.random(in: 0..<settings.numOfRows)
            let randomCol = Int.random(in: 0..<settings.numOfColumns)

            let currentRandomCellStatus = newBoard[randomRow][randomCol].status
            if currentRandomCellStatus != .bomb {
                newBoard[randomRow][randomCol].status = .bomb
                numberOfBombsPlaced += 1
            }
        }

        return newBoard
    }
}

