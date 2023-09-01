//
//  DateFormatter+extension.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 30.08.2023.
//

import Foundation

extension DateFormatter {
    public func dateFormating(_ date: Date) -> String {
        let dateFormatter = self
        dateFormatter.dateFormat = "d.MM.Y hh:mm"
        dateFormatter.locale = Locale(identifier: "ru_RU")
        let date = dateFormatter.string(from: date)
        
        return date
    }
}
