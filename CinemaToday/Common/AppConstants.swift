//
//  AppConstants.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import Foundation

class AppConstants{
    static let apiKey = "78b6df6be51f94a925bebb6545468002"
    static let readAccessToken = "eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI3OGI2ZGY2YmU1MWY5NGE5MjViZWJiNjU0NTQ2ODAwMiIsInN1YiI6IjY1NmU1YjNjODg2MzQ4MDBhZGU0YmRiZSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.ruZitWhNhDK4l4kp7cBgg8JwaoAuXVT7b6pnFJt6nKA"
    
    static let BASE_URL = "https://api.themoviedb.org/3"
    static let IMAGES_URL = "https://image.tmdb.org/t/p/w185"
    
    static let MOVIE_NOW_PLAYING = "/movie/now_playing"
    static let SEARCH_MOVIE = "/search/movie"
    
    static func getMovieNowPlayingURL()-> String{
        let movieNowPlayingURL = AppConstants.BASE_URL +  AppConstants.MOVIE_NOW_PLAYING
        return movieNowPlayingURL
    }
    
    static func getSearchMovieURL()-> String{
        let searchMovieURL = AppConstants.BASE_URL +  AppConstants.SEARCH_MOVIE
        return searchMovieURL
    }
    
    static func getImageURL(path: String)-> String{
        return AppConstants.IMAGES_URL +  path
    }
}
