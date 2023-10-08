//
//  NetworkRoutingProtocol.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 05.10.2023.
//

import Foundation

protocol NetworkRoutingProtocol {
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void)
}
