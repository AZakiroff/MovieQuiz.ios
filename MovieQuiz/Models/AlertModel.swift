//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 28.08.2023.
//

import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
