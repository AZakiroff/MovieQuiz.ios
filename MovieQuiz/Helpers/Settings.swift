//
//  Settings.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 13.08.2023.
//

import UIKit

enum Settings {
    static let buttonsBackgroundColor: UIColor = .ypWhite
    static let buttonsTintColor: UIColor = .ypBlack
    static let buttonsHeight: CGFloat = 60
    static let buttonsWidth: CGFloat = 157
    static let buttonsRadius: CGFloat = 15
    static let buttonsFontSize: CGFloat = 20
    static let buttonsFontWeight: CGFloat = 500
    static let buttonsFontName: String = "YSDisplay-Medium"
    
    static let navigationLabelFontSize: CGFloat = 20
    static let navigationLabelFontName: String = "YSDisplay-Medium"
    static let navigationLeftTextAlignment: NSTextAlignment = .left
    static let navigationRightTextAlignment: NSTextAlignment = .right
    
    static let questionLabelFontSize: CGFloat = 23
    static let questionLabelTextAlignment: NSTextAlignment = .center
    static let questionLabelFontName: String = "YSDisplay-Bold" //"YSDisplay-Bold"
    
    static let posterBorderWidth: CGFloat = 8
    static let posterImageViewRadius: CGFloat = 15
    
    static let pauseAfterResponse: Double = 1.0
    
    static let totalQuestionAmount: Int = 10
}

