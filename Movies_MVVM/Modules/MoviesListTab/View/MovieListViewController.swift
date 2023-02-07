// MovieListViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Screen with movies
final class MovieListViewController: UIViewController {
    // MARK: - Private Constants

    private enum Constants {
        static let placeholderForSearchControllerName = "Поиск..."
        static let popularButtonText = "Популярное"
        static let topRatingButtonText = "Топ"
        static let upComingButtonText = "Скоро"
    }

    private enum UrlComponent {
        static let movieBaseUrlText = "https://api.themoviedb.org/3/"
        static let moviePath = "movie/"
        static let topRatedCategoryUrlText = "top_rated?"
        static let popularCategoryUrlText = "popular?"
        static let upcomingCategoryUrlText = "upcoming?"
    }

    private enum Identifier {
        static let movieCellID = "MovieCollectionViewCell"
    }

    // MARK: - Private enums

    private enum CurrentCategoryOfMovies: String {
        case popular
        case topRating = "top_rated"
        case upComing = "upcoming"
    }

    // MARK: - Public properties

    var viewModel: MovieListViewModelProtocol?

    // MARK: - Private visual components

    private let searchController = UISearchController(searchResultsController: nil)

    private let horizontalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = UIColor(named: Colors.backgroundColorName)
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var moviesCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.backgroundColor = UIColor(named: Colors.backgroundColorName)
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(
            MovieCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.movieCellID
        )
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private lazy var popularButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.popularButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(popularAction), for: .touchUpInside)
        return button
    }()

    private lazy var topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.addTarget(self, action: #selector(topRatingAction), for: .touchUpInside)
        return button
    }()

    private lazy var upComingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.upComingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        if button.isSelected {
            button.layer.borderColor = UIColor(named: Colors.favoriteMovieColorName)?.cgColor
            button.layer.borderWidth = 2
        }
        button.addTarget(self, action: #selector(upComingAction), for: .touchUpInside)
        return button
    }()

    // MARK: - Private properties

    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }

    private var isFiltering: Bool {
        searchController.isActive && !searchBarIsEmpty
    }

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraintsForCollectionView()
        setupConstraintsForStackView()
    }

    // MARK: - Private methods

    private func setupUI() {
        addSubviews()
        createSearchController()
        updateView()
        showErrorAlert()
    }

    private func updateView() {
        viewModel?.successHandler = {
            DispatchQueue.main.async {
                self.moviesCollectionView.reloadData()
            }
        }
    }

    private func showErrorAlert() {
        viewModel?.failureHandler = { error in
            DispatchQueue.main.async {
                // TODO: Make show error alert
                print(error.localizedDescription)
            }
        }
    }

    private func addSubviews() {
        view.addSubview(moviesCollectionView)
        view.addSubview(horizontalStackView)
        horizontalStackView.addArrangedSubview(popularButton)
        horizontalStackView.addArrangedSubview(topRatedButton)
        horizontalStackView.addArrangedSubview(upComingButton)
    }

    private func setupConstraintsForCollectionView() {
        NSLayoutConstraint.activate(
            [
                moviesCollectionView.topAnchor
                    .constraint(equalTo: horizontalStackView.bottomAnchor),
                moviesCollectionView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor),
                moviesCollectionView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor),
                moviesCollectionView.bottomAnchor
                    .constraint(equalTo: view.bottomAnchor),
            ]
        )
    }

    private func setupConstraintsForStackView() {
        NSLayoutConstraint.activate(
            [
                horizontalStackView.topAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                horizontalStackView.leadingAnchor
                    .constraint(equalTo: view.leadingAnchor, constant: 10),
                horizontalStackView.trailingAnchor
                    .constraint(equalTo: view.trailingAnchor, constant: -10),
            ]
        )
    }

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = UIScreen.main.bounds.width / 2.2
        let cellHeightConstant: CGFloat = UIScreen.main.bounds.height / 3
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 1
        layout.minimumLineSpacing = 1
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        return layout
    }

    @objc private func popularAction(_ sender: UIButton) {
        viewModel?.fetchPopularMovies()
    }

    @objc private func topRatingAction() {
        viewModel?.fetchTopRatedMovies()
    }

    @objc private func upComingAction() {
        viewModel?.fetchUpcomingMovies()
    }
}

/// UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating {
    func updateSearchResults(for _: UISearchController) {
        viewModel?.filterContentForSearch(searchController.searchBar.text ?? "")
    }

    private func createSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Constants.placeholderForSearchControllerName
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = false
    }
}

/// UICollectionViewDataSource
extension MovieListViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        guard isFiltering else {
            return viewModel?.movies.count ?? 0
        }
        return viewModel?.filteredMovies?.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifier.movieCellID,
                for: indexPath
            ) as? MovieCollectionViewCell,
            let movie = isFiltering ? viewModel?.filteredMovies?[indexPath.row] : viewModel?
            .movies[indexPath.row],
            let imageService = viewModel?.imageService
        else { return UICollectionViewCell() }
        cell.configure(imageService: imageService, movie: movie)
        return cell
    }

    func collectionView(
        _: UICollectionView,
        willDisplay _: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        guard let movies = viewModel?.movies else { return }
        if indexPath.row == movies.count - 4 {
            viewModel?.fetchMoreMovies()
        }
    }
}

/// UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel?.movies[indexPath.row].id else { return }
        viewModel?.showMovieDetail(id: "\(id)")
    }
}
