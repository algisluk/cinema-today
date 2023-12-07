//
//  URLSession+Result.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import Foundation

extension URLSession {
    func dataTask(with url: URLRequest, result: @escaping (Result<(URLResponse, Data), Error>) -> Void) -> URLSessionDataTask {
        return dataTask(with: url) { (data, response, error) in
            if let error = error {
                result(.failure(error))
                return
            }
            guard let response = response, let data = data else {
                let error = NSError(domain: "error", code: 0, userInfo: nil)
                result(.failure(error))
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("Status Code: \(httpResponse.statusCode)")
            }
            result(.success((response, data)))
        }
    }
}
