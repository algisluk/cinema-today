//
//  MovieDetailViewController.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var posterImageView: UIImageView!
    
    var viewModel = MovieDetailViewModel()
    var isSelectedFav = false
    
    var actionBlock: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.posterImageView.image = nil
        self.posterImageView.cancelImageLoad()
    }
    
    private func setupViews() {
        guard let movie = viewModel.movie else {
            self.titleLabel.text = "-"
            self.overviewLabel.text = ""
            self.rateLabel.text = ""
            self.releaseDateLabel.text = ""
            self.popularityLabel.text = ""
            return
        }
        self.titleLabel.text = movie.title
        self.overviewLabel.text = movie.overview
        if let voteAverage = movie.voteAverage {
            self.rateLabel.text = "Rate: \(voteAverage)"
        } else {
            self.rateLabel.text = "Rate: -"
        }
        self.releaseDateLabel.text = "Release date: " + (movie.releaseDate ?? "-")
        if let popularity = movie.popularity {
            self.popularityLabel.text = "Popularity: \(popularity)"
        } else {
            self.popularityLabel.text = "Popularity: -"
        }
        self.posterImageView.loadImage(at: AppConstants.getImageURL(path: movie.posterPath ?? ""))
        
        guard let favMovies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] else { return }
        isSelectedFav = favMovies.contains(movie.id)
        let buttonImage = isSelectedFav ? UIImage(named: "heart_filled.png") : UIImage(named: "heart_outline.png")
        starButton.setImage(buttonImage, for: .normal)
    }
    
    @IBAction func didTapStarButton(_ sender: Any) {
        actionBlock?(true)
        guard let id = viewModel.movie?.id else { return }
        guard var favMovies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] else {
            let favMovies = [id]
            UserDefaults.standard.set(favMovies, forKey: "favMovies")
            starButton.setImage(UIImage(named: "heart_filled.png"), for: .normal)
            actionBlock?(true)
            return
        }
        if let index = favMovies.firstIndex(of: id) {
            favMovies.remove(at: index)
            starButton.setImage(UIImage(named: "heart_outline.png"), for: .normal)
            actionBlock?(false)
        } else {
            favMovies.append(id)
            starButton.setImage(UIImage(named: "heart_filled.png"), for: .normal)
            actionBlock?(true)
        }
        UserDefaults.standard.set(favMovies, forKey: "favMovies")
    }
}
