//
//  MoviesViewModels.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import Foundation

class MoviesViewModel {
    
    enum State: Equatable {
        case loading
        case finished
        case empty
    }
    
    var reloadTableViewClosure: (()->())?
    var updateLoadingStatusClosure: ((State)->())?
    
    private var movies: [Movie] = [Movie]() {
        didSet {
            self.reloadTableViewClosure?()
        }
    }
    
    var state: State = .loading {
        didSet {
            self.updateLoadingStatusClosure?(state)
        }
    }
    
    var numberOfItems: Int {
        return movies.count
    }
    
    var searchMode = false
    var query = ""
    var currentPage: Int = 1
    var totalPages: Int = 1
    
    func fetchData(page: Int) {
        self.state = .loading
        APIService.shared.fetchMovies(page: page) { [weak self] (result: Result<MovieResults, APIServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let movieResults):
                self.currentPage += 1
                self.appendData(results: movieResults)
//                self?.movies = movieResults.results
                (self.movies.count == 0) ? (self.state = .empty) : (self.state = .finished)
            case .failure(let error):
                (self.movies.count == 0) ? (self.state = .empty) : (self.state = .finished)
                print(error.localizedDescription)
            }
        }
    }
    
    func searchData(text: String, page: Int) {
        self.state = .loading
        APIService.shared.searchMovies(text: text, page: page) { [weak self] (result: Result<MovieResults, APIServiceError>) in
            guard let self = self else { return }
            switch result {
            case .success(let movieResults):
                self.currentPage += 1
                self.appendData(results: movieResults)
//                self?.movies = movieResults.results
                (self.movies.count == 0) ? (self.state = .empty) : (self.state = .finished)
            case .failure(let error):
                (self.movies.count == 0) ? (self.state = .empty) : (self.state = .finished)
                print(error.localizedDescription)
            }
        }
    }
    
    func getData(at indexPath: IndexPath ) -> Movie {
        return movies[indexPath.row]
    }
    
    func loadNextData() {
        guard currentPage < totalPages, self.state == .finished else { return }
        if searchMode {
            searchData(text: query, page: currentPage + 1)
        } else {
            fetchData(page: currentPage + 1)
        }
    }
    
    func firstLoadData() {
        resetPages()
        searchMode = false
        query = ""
        fetchData(page: currentPage + 1)
    }
    
    func firstSearchData(text: String) {
        resetPages()
        searchMode = true
        query = text
        searchData(text: text, page: currentPage + 1)
    }
    
    private func appendData(results: MovieResults) {
        currentPage = results.page
        totalPages = results.totalPages
        movies.append(contentsOf: results.results)
    }
    
    private func resetPages() {
        currentPage = 0
        totalPages = 1
        movies.removeAll()
    }
}
