//
//  RecordGame.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 30.08.2023.
//

import Foundation

public struct BestGame: Codable {
    let correctAnswers: Int
    let questionAmount: Int
    let date: Date
    
    func whichOneIsBestGame(_ bestGameTwo: BestGame) -> BestGame {
        if self > bestGameTwo {
            return self
        } else {
            return bestGameTwo
        }
    }
}

extension BestGame: Comparable {
    public static func < (lhs: BestGame, rhs: BestGame) -> Bool {
        return lhs.correctAnswers < rhs.correctAnswers
    }
    public static func > (lhs: BestGame, rhs: BestGame) -> Bool {
        return lhs.correctAnswers > rhs.correctAnswers
    }
}
