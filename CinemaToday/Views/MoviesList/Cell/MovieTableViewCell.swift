//
//  MovieTableViewCell.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import UIKit

class MovieTableViewCell: UITableViewCell {

    @IBOutlet weak var starButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    var isSelectedFav = false
    var movie: Movie?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        isSelectedFav = false
        starButton.setImage(UIImage(named: "heart_outline.png"), for: .normal)
    }
    
    func setup(model: Movie) {
        self.movie = model
        self.titleLabel.text = model.title
        if let voteAverage = model.voteAverage {
            self.rateLabel.text = "Rate: \(voteAverage)"
        } else {
            self.rateLabel.text = "Rate: -"
        }
        self.releaseDateLabel.text = "Release date: " + (model.releaseDate ?? "")
        
        guard let favMovies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] else { return }
        isSelectedFav = favMovies.contains(model.id)
        let buttonImage = isSelectedFav ? UIImage(named: "heart_filled.png") : UIImage(named: "heart_outline.png")
        starButton.setImage(buttonImage, for: .normal)
    }
    @IBAction func didTapButton(_ sender: UIButton) {
        guard let id = movie?.id else { return }
        guard var favMovies = UserDefaults.standard.array(forKey: "favMovies") as? [Int] else {
            let favMovies = [id]
            UserDefaults.standard.set(favMovies, forKey: "favMovies")
            starButton.setImage(UIImage(named: "heart_filled.png"), for: .normal)
            return
        }
        if let index = favMovies.firstIndex(of: id) {
            favMovies.remove(at: index)
            starButton.setImage(UIImage(named: "heart_outline.png"), for: .normal)
        } else {
            favMovies.append(id)
            starButton.setImage(UIImage(named: "heart_filled.png"), for: .normal)
        }
        UserDefaults.standard.set(favMovies, forKey: "favMovies")
    }
    
}
