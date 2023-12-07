//
//  MovieViewController.swift
//  CinemaToday
//
//  Created by Algis on 06/12/2023.
//

import UIKit

class MoviesListViewController: UIViewController {

    @IBOutlet weak var noDataLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    weak var refreshControll: UIRefreshControl!
    
    private let viewModel = MoviesViewModel()
    let movieCellReuseIdentifier = "MovieTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Movies list"
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.searchBar.sizeToFit()
        self.searchBar.searchBarStyle = .minimal
        self.searchBar.placeholder = "Search"
        self.searchBar.showsCancelButton = true
        self.searchBar.delegate = self
        self.searchBar.setShowsCancelButton(false, animated: true)
        self.searchBar.searchTextField.clearButtonMode = .never
        self.tableView.register(UINib(nibName: movieCellReuseIdentifier, bundle: nil), forCellReuseIdentifier: movieCellReuseIdentifier)
        
        setupBindings()
        setupRefreshControll()
        viewModel.fetchData(page: viewModel.currentPage)
    }
    
    private func setupRefreshControll() {
        let refreshControll = UIRefreshControl()

        tableView.refreshControl = refreshControll

        self.refreshControll = refreshControll
        self.refreshControll.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
    }
    
    @objc func refresh(sender:AnyObject)
    {
        viewModel.firstLoadData()
        tableView.refreshControl?.endRefreshing()
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func setupBindings() {
        viewModel.reloadTableViewClosure = { [weak self] () in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        viewModel.updateLoadingStatusClosure = { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .loading:
                    self?.activityIndicator.startAnimating()
                    self?.activityIndicator.isHidden = false
                    self?.noDataLabel.isHidden = true
                    self?.tableView.isHidden = false
                case .finished:
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.noDataLabel.isHidden = true
                    self?.tableView.isHidden = false
                case .empty:
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.isHidden = true
                    self?.noDataLabel.isHidden = false
                    self?.tableView.isHidden = true
                }
            }
        }
    }
}

extension MoviesListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellReuseIdentifier, for: indexPath) as! MovieTableViewCell
        cell.selectionStyle = .none
        let movie = viewModel.getData(at: indexPath)
        cell.setup(model: movie)
        
        if indexPath.row == viewModel.numberOfItems - 1 {
            viewModel.loadNextData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieDetailViewController = UIStoryboard(name: "MovieDetailViewController", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
        movieDetailViewController.viewModel.movie = viewModel.getData(at: indexPath)
        movieDetailViewController.actionBlock = { isSelectedFav in
            guard let cell = tableView.cellForRow(at: indexPath) as? MovieTableViewCell else { return }
            let buttonImage = isSelectedFav ? UIImage(named: "heart_filled.png") : UIImage(named: "heart_outline.png")
            cell.starButton.setImage(buttonImage, for: .normal)
        }
        self.navigationController?.pushViewController(movieDetailViewController, animated: true)
    }
}

extension MoviesListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {
            searchBar.resignFirstResponder()
            viewModel.firstLoadData()
            return
        }
        searchBar.setShowsCancelButton(true, animated: true)
        viewModel.firstSearchData(text: searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
        searchBar.resignFirstResponder()
        searchBar.text = ""
        viewModel.firstLoadData()
    }
}
