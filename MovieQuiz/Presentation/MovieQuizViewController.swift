import UIKit

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String)
    func posterImageViewSetBorder(isCorrect: Bool)
    func buttonsIsEnabled(_ isEnabled: Bool)
}

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {

    @IBOutlet private weak var navigationLeftLabel: UILabel!
    @IBOutlet private weak var navigationRightLabel: UILabel!
    @IBOutlet private weak var posterImageView: UIImageView!
    @IBOutlet private weak var questionLabel: UILabel!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = MovieQuizPresenter(viewController: self)
        defaultSettings()
        showLoadingIndicator()
        buttonsIsEnabled(false)
    }
    
    private func defaultSettings() {
        yesButton.setButton(buttonName: Settings.yesButtonText)
        noButton.setButton(buttonName: Settings.noButtonText)
        navigationLeftLabel.setLabel(text: Settings.navigationLeftText, type: "NavigationLeft")
        navigationRightLabel.setLabel(text: "1/\(Settings.totalQuestionAmount)", type: "NavigationRight")
        questionLabel.setLabel()
        posterImageView.layer.cornerRadius = Settings.posterImageViewRadius
    }
    
    public func posterImageViewSetBorder(isCorrect: Bool) {
        posterImageView.setBorder(isCorrect: isCorrect)
    }
    
    public func showLoadingIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    public func hideLoadingIndicator() {
        activityIndicator.isHidden = true
        activityIndicator.startAnimating()
    }
    
    public func showNetworkError(message: String) {
        hideLoadingIndicator()
        let alertSettings = AlertModel(
            title: Settings.alertErrorTitle,
            message: Settings.alertErrorMessage,
            buttonText: Settings.alertErrorButtonText
        ) { [weak self] in
            self?.presenter.requestNextQuestion()
            
        }
        presenter.showAlert(alertSettings: alertSettings)
    }
        
    @IBAction private func yesButtonAction(_ sender: Any) {
        presenter.yesButtonAction()
    }
    
    @IBAction private func noButtonAction(_ sender: Any) {
        presenter.noButtonAction()
    }
    
    public func show(quiz step: QuizStepViewModel) {
        posterImageView.image = step.image
        questionLabel.text = step.question
        navigationRightLabel.text = step.questionNumber
        hideLoadingIndicator()
        buttonsIsEnabled(true)
        self.posterImageView.layer.borderWidth = 0
    }
    
    public func buttonsIsEnabled(_ isEnabled: Bool) {
            yesButton.isEnabled = isEnabled
            noButton.isEnabled = isEnabled
    }
    
}
