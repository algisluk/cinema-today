//
//  ImageLoader.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import UIKit

class ImageLoader {
    private var loadedImages = [URL: UIImage]()
    private var runningRequests = [UUID: URLSessionDataTask]()
    
    func loadImage(_ url: String, _ completion: @escaping (Result<UIImage, Error>) -> Void) -> UUID? {
        guard let url = URL(string: url) else { return nil }
        
        if let image = loadedImages[url] {
            completion(.success(image))
            return nil
        }
        let uuid = UUID()
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.runningRequests.removeValue(forKey: uuid) }
            
            if let data = data, let image = UIImage(data: data) {
                self.loadedImages[url] = image
                completion(.success(image))
                return
            }
            guard let error = error else { return }
            guard (error as NSError).code == NSURLErrorCancelled else {
                completion(.failure(error))
                return
            }
        }
        task.resume()
        
        runningRequests[uuid] = task
        return uuid
    }
    
    func cancelLoad(_ uuid: UUID) {
        runningRequests[uuid]?.cancel()
        runningRequests.removeValue(forKey: uuid)
    }
}
