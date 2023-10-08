//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Антон Закиров on 08.10.2023.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: UIViewController, MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    func showLoadingIndicator() {}
    func hideLoadingIndicator() {}
    func showNetworkError(message: String) {}
    func posterImageViewSetBorder(isCorrect: Bool) {}
    func buttonsIsEnabled(_ isEnabled: Bool) {}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
} 
