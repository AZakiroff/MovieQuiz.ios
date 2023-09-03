//
//  NetworkClient.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 01.09.2023.
//

import UIKit

struct NetworkClient {

    private enum NetworkError: Error {
        case codeError
    }
    
    func fetch(url: URL, handler: @escaping (Result<Data, Error>) -> Void) {
    
        let request = URLRequest(url: url)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                handler(.failure(error))
                return
            }
            
            if let response = response as? HTTPURLResponse,
            response.statusCode < 200 || response.statusCode >= 300 {
                print(response.statusCode)
                handler(.failure(NetworkError.codeError))
            }
            
            guard let data = data else { return }
            handler(.success(data))
            
        }
        
        task.resume()
    }
}
