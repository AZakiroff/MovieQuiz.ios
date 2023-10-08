//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 28.08.2023.
//

import UIKit

protocol AlertPresenterProtocol {
    var viewController: UIViewController {get}
    var correctAnswers: Int {get}
    func showAlert(alertSettings: AlertModel)
}

class AlertPresenter: AlertPresenterProtocol {

    var viewController: UIViewController
    var correctAnswers: Int = 100
    
    public func showAlert(alertSettings: AlertModel) {
        
        let alert = UIAlertController(
            title: alertSettings.title,
            message: alertSettings.message,
            preferredStyle: .alert)
        let action = UIAlertAction(title: alertSettings.buttonText, style: .default) { _ in
            alertSettings.completion()
        }
        alert.view.accessibilityIdentifier = "Results"
        alert.addAction(action)
        viewController.present(alert, animated: true, completion: nil)
    }
    
    init(viewController: UIViewController){
        self.viewController = viewController
    }
}
