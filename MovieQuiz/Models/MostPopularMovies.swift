//
//  MostPopularMovies.swift
//  MovieQuiz
//
//  Created by Антон Закиров on 01.09.2023.
//

import UIKit

struct MostPopularMovies: Codable {
    let errorMessage: String
    let items: [MostPopularMovie]
}

struct MostPopularMovie: Codable {
    let title: String
    let rating: String
    let imageURL: URL
    
    var resizedImageURL: URL {
        let oldImageUrlString = imageURL.absoluteString
        let newImageUrlString = oldImageUrlString.components(separatedBy: "._")[0] + "._V0_UX600_.jpg"
        
        guard let newImageUrl = URL(string: newImageUrlString) else {
            return imageURL
        }
        
        return newImageUrl
    }
    
    private enum CodingKeys: String, CodingKey {
        case title = "fullTitle"
        case rating = "imDbRating"
        case imageURL = "image"
    }
}
