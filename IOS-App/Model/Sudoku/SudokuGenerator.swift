//
//  sudokuGenerator.swift
//  Match the Pairs Test
//
//  Created by SDC-USER on 28/11/25.
//
import Foundation

struct SudokuGenerator {
    // Generate a full solved board (81 Int?) using backtracking
    static func generateFullBoard() -> [Int?] {
        var board = Array<Int?>(repeating: nil, count: 81)
        _ = SudokuSolver.solve(&board)
        return board
    }

    // Generate puzzle: create full board, then remove numbers until targetClues remains.
    // If ensureUnique is true, we revert removals that make multiple solutions (slower).
    static func generatePuzzle(targetClues: Int, ensureUnique: Bool = false) -> (puzzle: [Int?], solution: [Int?]) {
        var solution = generateFullBoard()
        var puzzle = solution
        var positions = Array(0..<81).shuffled()
        var currentClues = 81
        while currentClues > targetClues && !positions.isEmpty {
            let pos = positions.removeFirst()
            let backup = puzzle[pos]
            puzzle[pos] = nil
            if ensureUnique {
                let count = SudokuSolver.countSolutions(puzzle, limit: 2)
                if count != 1 {
                    puzzle[pos] = backup // revert
                } else {
                    currentClues -= 1
                }
            } else {
                currentClues -= 1
            }
        }
        return (puzzle, solution)
    }
}

