import UIKit

final class MovieQuizViewController: UIViewController, QuestionFactoryDelegate {
    
    private var questionFactory: QuestionFactoryProtocol?
    private var alertPresenter: AlertPresenterProtocol?
    
    private var currentQuestion: QuizQuestion?
    private var alertSettings: AlertModel?
    private var statisticService: StatisticServiceProtocol?
    
    private var currentQuestionIndex: Int = 0
    private var correctAnswers: Int = 0
    private let questionAmount: Int = Settings.totalQuestionAmount
    
    @IBOutlet private weak var navigationLeftLabel: UILabel!
    @IBOutlet private weak var navigationRightLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        questionFactory = QuestionFactory(delegate: self, moviesLoader: MoviesLoader())
        alertPresenter = AlertPresenter(viewController: self)
        statisticService = StatisticService()
        defaultSettings()
        showLoadingIndicator()
        buttonsIsEnabled(false)
        questionFactory?.loadData()
    }
    
    private func defaultSettings() {
        yesButton.setButton(buttonName: Settings.yesButtonText)
        noButton.setButton(buttonName: Settings.noButtonText)
        navigationLeftLabel.setLabel(text: Settings.navigationLeftText, type: "NavigationLeft")
        navigationRightLabel.setLabel(text: "1/\(questionAmount)", type: "NavigationRight")
        questionLabel.setLabel()
        posterImageView.layer.cornerRadius = Settings.posterImageViewRadius
    }
    
    private func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    private func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    private func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertSettings = AlertModel(
            title: Settings.alertErrorTitle,
            message: Settings.alertErrorMessage,
            buttonText: Settings.alertErrorButtonText
        ) {
            self.questionFactory?.requestNextQuestion()
        }
        alertPresenter?.showAlert(alertSettings: alertSettings)
    }
    
    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        showNetworkError(message: error.localizedDescription)
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
        return QuizStepViewModel(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex)/\(questionAmount)")
    }
    
    private func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        questionLabel.text = step.question
        navigationRightLabel.text = step.questionNumber
        hideLoadingIndicator()
        buttonsIsEnabled(true)
        self.posterImageView.layer.borderWidth = 0
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            correctAnswers += 1
        }
        self.posterImageView.setBorder(isCorrect: isCorrect)
        buttonsIsEnabled(false)
        DispatchQueue.main.asyncAfter(deadline: .now() + Settings.pauseAfterResponse) { [weak self] in
            guard let self = self else { return }
            self.showNextQuestionOrResults()
        }
    }
    
    private func buttonsIsEnabled(_ isEnabled: Bool) {
            yesButton.isEnabled = isEnabled
            noButton.isEnabled = isEnabled
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
}
