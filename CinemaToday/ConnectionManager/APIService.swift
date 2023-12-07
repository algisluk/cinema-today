//
//  APIService.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import Foundation

public enum APIServiceError: Error {
    case apiError
    case invalidEndpoint
    case invalidResponse
    case noData
    case decodeError
}
protocol APIServiceProtocol {
    func fetchMovies(page: Int, completion: @escaping (Result<MovieResults, APIServiceError>) -> Void)
}

class APIService: APIServiceProtocol {
    public static let shared = APIService()
    private let session: URLSession = URLSession(configuration: .default)
    
    let headers = [
      "accept": "application/json",
      "Authorization": "Bearer \(AppConstants.readAccessToken)"
    ]
    
    public func fetchMovies(page: Int, completion: @escaping (Result<MovieResults, APIServiceError>) -> Void)  {
        
        guard URL(string: AppConstants.getMovieNowPlayingURL()) != nil else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var components = URLComponents(string: AppConstants.getMovieNowPlayingURL())
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: String(page))
        ]

        components?.queryItems = queryItems
        
        
        guard let url = components?.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        self.session.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values: MovieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.apiError))
            }
        }.resume()
    }
    
    public func searchMovies(text: String, page: Int, completion: @escaping (Result<MovieResults, APIServiceError>) -> Void)  {
        
        guard URL(string: AppConstants.getMovieNowPlayingURL()) != nil else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var components = URLComponents(string: AppConstants.getSearchMovieURL())
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "query", value: text),
            URLQueryItem(name: "language", value: "en-US"),
            URLQueryItem(name: "page", value: String(page))
        ]

        components?.queryItems = queryItems
        
        
        guard let url = components?.url else {
            completion(.failure(.invalidEndpoint))
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        self.session.dataTask(with: request) { (result) in
            switch result {
            case .success(let (response, data)):
                guard let statusCode = (response as? HTTPURLResponse)?.statusCode, 200..<299 ~= statusCode else {
                    completion(.failure(.invalidResponse))
                    return
                }
                do {
                    let values: MovieResults = try JSONDecoder().decode(MovieResults.self, from: data)
                    completion(.success(values))
                } catch {
                    completion(.failure(.decodeError))
                }
            case .failure(let error):
                print(error.localizedDescription)
                completion(.failure(.apiError))
            }
        }.resume()
    }
}
