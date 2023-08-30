import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionAmount: Int = Settings.totalQuestionAmount
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    private var alertPresenter: AlertPresenterProtocol?
    private var alertSettings: AlertModel?
    private var statisticService: StatisticServiceProtocol?
    
    @IBOutlet private weak var navigationLeftLabel: UILabel!
    @IBOutlet private weak var navigationRightLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        yesButton.setButton(buttonName: "Да")
        noButton.setButton(buttonName: "Нет")
        navigationLeftLabel.setLabel(text: "Вопрос", type: "NavigationLeft")
        navigationRightLabel.setLabel(text: "1/10", type: "NavigationRight")
        questionLabel.setLabel()
        posterImageView.layer.cornerRadius = Settings.posterImageViewRadius
        
        questionFactory = QuestionFactory(delegate: self)
        alertPresenter = AlertPresenter(viewController: self)
        questionFactory?.requestNextQuestion()
        
        statisticService = StatisticService()
        
    }

    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question = question else { return }
    
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(quiz: viewModel)
        }
    }
    
    @IBAction private func yesButtonAction(_ sender: Any) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == true)
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        guard let currentQuestion else { return }
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == false)
    }

    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        currentQuestionIndex += 1
        let questionStep = QuizStepViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionAmount)"
            )
        return questionStep
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        questionLabel.text = step.question
        navigationRightLabel.text = step.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        self.posterImageView.setBorder(isCorrect: isCorrect)
        buttonsIsEnabled(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + Settings.pauseAfterResponse) { [weak self] in
            guard let self = self else { return }
            self.posterImageView.layer.borderWidth = 0
            self.buttonsIsEnabled(true)
            self.showNextQuestionOrResults()
        }
    }
    
    private func buttonsIsEnabled(_ isEnabled: Bool) {
            yesButton.isEnabled = isEnabled
            noButton.isEnabled = isEnabled
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questionAmount {
        
            let row1 = "Ваш результат \(correctAnswers)\n"
            var row2 = ""
            var row3 = ""
            var row4 = ""
            
            statisticService?.store(correct: correctAnswers, total: questionAmount)
            
            if let gamesCount = statisticService?.gamesCount {
                row2 = "Количество сыгранных квизов: \(gamesCount > 0 ? gamesCount : 1)\n"
            }
            
            if let bestGame = statisticService?.bestGame {
                let correct = bestGame.correct
                let total = bestGame.total
                let date = DateFormatter().dateFormating(bestGame.date)
                row3 = "Рекорд: \(correct)/\(total) (\(date))\n"
            }
            
            if let totalAccuracy = statisticService?.totalAccuracy {
                let row4 = "Средняя точность: \(totalAccuracy)\n"
            }
            
            
            alertSettings = AlertModel(
                title: "Этот раунд окончен!",
                message: row1 + row2 + row3 + row4,
                buttonText: "Сыграть ещё раз") {
                    self.questionFactory?.requestNextQuestion()
            }
            alertPresenter?.showAlert(alertSettings: alertSettings!)
            currentQuestionIndex = 0
            correctAnswers = 0
        } else {
            questionFactory?.requestNextQuestion()
        }
    }
}
