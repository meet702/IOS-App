//
//  SudokuDifficulty.swift
//  Match the Pairs Test
//
//  Created by SDC-USER on 28/11/25.
//

enum SudokuDifficulty {
    case easy, medium, hard

    var clueCount: Int {
        switch self {
        case .easy: return 40   // more numbers present
        case .medium: return 34
        case .hard: return 28   // least numbers present
        }
    }
    var displayName: String {
        switch self {
        case .easy: return "Easy"
        case .medium: return "Medium"
        case .hard: return "Hard"
        }
    }
}
