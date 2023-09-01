//
//  UIImageView+setBorder.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 24.08.2023.
//

import UIKit

extension UIImageView {
    public func setBorder(isCorrect: Bool) -> Void {
        self.layer.masksToBounds = true
        self.layer.borderWidth = Settings.posterBorderWidth
        self.layer.borderColor = isCorrect ? UIColor.ypGreen.cgColor : UIColor.ypRed.cgColor
    }
}
