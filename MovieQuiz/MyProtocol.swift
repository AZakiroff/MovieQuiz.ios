//
//  MyProtocol.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 29.08.2023.
//

import Foundation

protocol MyProtocol {
    var myProperty: String {get set}
}

class MyClass: MyProtocol {
    private var privatProperty: String
    
    var myProperty: String {
        get {
            return privatProperty
        }
        set {
            privatProperty = newValue
        }
    }
    
    init(privatProperty: String) {
        self.privatProperty = privatProperty
    }
}
