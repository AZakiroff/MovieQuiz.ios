//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 29.08.2023.
//

import UIKit

protocol StatisticServiceProtocol {
    var totalAccuracy: Int { get }
    var totalGame: Int { get }
    var totalQuestionAmount: Int { get }
    var totalCorrectAnswers: Int { get }
    var bestGame: BestGame? { get }
    
    func store(correctAnswers: Int, questionAmount: Int)
}

final public class StatisticService: StatisticServiceProtocol {

    private enum Keys: String {
        case totalCorrectAnswers, totalQuestionAmount, bestGame, totalGame
    }
    
    var totalGame: Int {
        get { getInteger(key: Keys.totalGame) }
        set { setAny(value: newValue, key: Keys.totalGame) }
    }
    
    var totalAccuracy: Int {
        guard totalQuestionAmount > 0 else { return 0 }
        return Int(Double(totalCorrectAnswers) / Double(totalQuestionAmount) * 100)
    }
    
    var totalQuestionAmount: Int {
        get { getInteger(key: Keys.totalQuestionAmount) }
        set { setAny(value: newValue, key: Keys.totalQuestionAmount) }
    }
    
    var totalCorrectAnswers: Int {
        get { getInteger(key: Keys.totalCorrectAnswers) }
        set { setAny(value: newValue, key: Keys.totalCorrectAnswers) }
    }
    
    var bestGame: BestGame? {
        get {
            guard let data = getData(key: Keys.bestGame) else { return nil }
            return try! JSONDecoder().decode(BestGame.self, from: data)
        }
        set {
            guard let data = try? JSONEncoder().encode(newValue) else {
                print("Невозможно сохранить результат")
                return
            }
            setAny(value: data, key: Keys.bestGame)
        }
    }
        
    private func getInteger(key: Keys) -> Int {
        UserDefaults.standard.integer(forKey: key.rawValue)
    }
    
    private func getData(key: Keys) -> Data? {
        guard let data = UserDefaults.standard.data(forKey: key.rawValue) else { return nil }
        return data
    }
    
    private func setAny(value: Any, key: Keys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
        
    func store(correctAnswers: Int, questionAmount: Int) {
        totalCorrectAnswers = totalCorrectAnswers + correctAnswers
        totalQuestionAmount = totalQuestionAmount + questionAmount
        totalGame = totalGame + 1
        let newBestGame = BestGame(correctAnswers: correctAnswers, questionAmount: questionAmount, date: Date())
        
        if let oldBestGame = bestGame {
            bestGame = oldBestGame.whichOneIsBestGame(newBestGame)
        } else {
            bestGame = newBestGame
        }
    }
    
}


