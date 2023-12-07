//
//  Movie.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import Foundation

struct Movie: Codable {
    let id: Int
    let overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title: String?
    let voteAverage: Double?

    enum CodingKeys: String, CodingKey {
        case id
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title
        case voteAverage = "vote_average"
    }
}

struct MovieResults: Codable {
    let page: Int
    let results: [Movie]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}
