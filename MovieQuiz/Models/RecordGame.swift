//
//  RecordGame.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 30.08.2023.
//

import Foundation

public struct GameRecord: Codable {
    let correct: Int
    let total: Int
    let date: Date
    
    func bestGameRecord(oldGameRecord: GameRecord, newGameRecord: GameRecord) -> GameRecord {
        if newGameRecord > oldGameRecord {
            return newGameRecord
        } else {
            return oldGameRecord
        }
    }
    
}

extension GameRecord: Comparable {
    public static func < (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct < rhs.correct
    }
    public static func > (lhs: GameRecord, rhs: GameRecord) -> Bool {
        return lhs.correct > rhs.correct
    }
}
