//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 08.10.2023.
//

import UIKit

final class MovieQuizPresenter: QuestionFactoryDelegate {

    private var currentQuestionIndex: Int = 0
    private let questionAmount: Int = Settings.totalQuestionAmount
    private var statisticService: StatisticServiceProtocol?
    private var correctAnswers: Int = 0
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    private var viewController: MovieQuizViewControllerProtocol?
    private var currentQuestion: QuizQuestion?
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        statisticService = StatisticService()
        alertPresenter = AlertPresenter(viewController: viewController as! UIViewController)
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        questionFactory?.loadData()
    }
    
    public func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.viewController?.show(quiz: viewModel)
        }
    }
    
    public func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    public func didFailToLoadData(with error: Error) {
        viewController?.showNetworkError(message: error.localizedDescription)
    }
    
    public func showAlert(alertSettings: AlertModel) {
        alertPresenter?.showAlert(alertSettings: alertSettings)
    }
    
    public func requestNextQuestion() {
        questionFactory?.requestNextQuestion()
    }
    
    public func yesButtonAction() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    public func noButtonAction() {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }
    
    public func convert(model: QuizQuestion) -> QuizStepViewModel {
        currentQuestionIndex += 1
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionAmount)")
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount {
            statisticService?.store(correctAnswers: correctAnswers, questionAmount: questionAmount)
            var message = "\(Settings.alertResultTitle) \(correctAnswers)/\(questionAmount)\n"
            if let totalGame = statisticService?.totalGame {
                message += "\(Settings.alertResultMessageTotalGames): \(totalGame > 0 ? totalGame : 1)\n"
            }
            if let bestGame = statisticService?.bestGame {
                message += "\(Settings.alertResultMessageBestGame): \(bestGame.correctAnswers)/\(bestGame.questionAmount) (\(DateFormatter().dateFormating(bestGame.date)))\n"
            }
            if let totalAccuracy = statisticService?.totalAccuracy {
                message += "\(Settings.alertResultMessageTotalAccuracy): \(totalAccuracy)%\n"
            }
            let alertSettings = AlertModel(
                title: Settings.alertResultTitle,
                message: message,
                buttonText: Settings.alertResultButtonText) {
                    self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.showAlert(alertSettings: alertSettings)
            currentQuestionIndex = 0
            correctAnswers = 0
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        viewController?.posterImageViewSetBorder(isCorrect: isCorrect)
        viewController?.buttonsIsEnabled(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + Settings.pauseAfterResponse) { [weak self] in
            guard let self = self else { return }
            showNextQuestionOrResults()
        }
    }
    
    
}
