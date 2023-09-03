//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 27.08.2023.
//

import UIKit

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
