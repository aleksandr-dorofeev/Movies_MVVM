// MovieListViewController.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import UIKit

/// Screen with movies
final class MovieListViewController: UIViewController {
    // MARK: - Private Constants

    private enum Constants {
        static let placeholderForSearchControllerName = "Поиск..."
        static let popularButtonText = "Популярное"
        static let topRatingButtonText = "Топ"
        static let upComingButtonText = "Скоро"
        static let errorTitle = "Error"
        static let reloadTitleButton = "Reload"
        static let emptyString = ""
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

    private let activityIndicator: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView()
        activity.startAnimating()
        activity.color = .systemPink
        activity.translatesAutoresizingMaskIntoConstraints = false
        return activity
    }()

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
        button.tag = 0
        button.addTarget(self, action: #selector(chooseCategoryAction), for: .touchUpInside)
        return button
    }()

    private lazy var topRatedButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.topRatingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.tag = 1
        button.addTarget(self, action: #selector(chooseCategoryAction), for: .touchUpInside)
        return button
    }()

    private lazy var upComingButton: UIButton = {
        let button = UIButton()
        button.setTitle(Constants.upComingButtonText, for: .normal)
        button.backgroundColor = UIColor(named: Colors.buttonColorName)
        button.layer.cornerRadius = 10
        button.tag = 2
        if button.isSelected {
            button.layer.borderColor = UIColor(named: Colors.favoriteMovieColorName)?.cgColor
            button.layer.borderWidth = 2
        }
        button.addTarget(self, action: #selector(chooseCategoryAction), for: .touchUpInside)
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

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        switch viewModel?.movieListState {
        case .initial:
            setupUI()
            activityIndicator.startAnimating()
            activityIndicator.isHidden = false
            moviesCollectionView.isHidden = true
        case .success:
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
            moviesCollectionView.isHidden = false
            moviesCollectionView.reloadData()
        case let .failure(error):
            showErrorAlert(error: error)
        default:
            break
        }
    }

    // MARK: - Private methods

    private func setupUI() {
        addSubviews()
        callApiAlertHandler()
        viewModel?.getApiKey()
        reloadBind()
        createSearchController()
        setupConstraintsForCollectionView()
        setupConstraintsForStackView()
        setupConstraintsActivityView()
    }

    private func callApiAlertHandler() {
        viewModel?.apiKeyHandler = { [weak self] in
            guard let self = self else { return }
            self.apiKeyAlertBind()
        }
    }

    private func apiKeyAlertBind() {
        DispatchQueue.main.async {
            self.showApiKeyAlert(
                title: "",
                message: "",
                actionTitle: "Загрузить"
            ) { [weak self] text in
                guard let self = self else { return }
                self.viewModel?.setApiKey(text: text)
            }
        }
    }

    private func reloadBind() {
        viewModel?.reloadViewHandler = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.view.setNeedsLayout()
            }
        }
    }

    private func showErrorAlert(error: Error) {
        DispatchQueue.main.async {
            self.showAlert(
                title: Constants.errorTitle,
                message: error.localizedDescription,
                actionTitle: Constants.reloadTitleButton
            ) { [weak self] _ in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.moviesCollectionView.reloadData()
                }
            }
        }
    }

    private func addSubviews() {
        view.addSubview(moviesCollectionView)
        view.addSubview(horizontalStackView)
        view.addSubview(activityIndicator)
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

    private func setupConstraintsActivityView() {
        NSLayoutConstraint.activate(
            [
                activityIndicator.centerXAnchor
                    .constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor
                    .constraint(equalTo: view.centerYAnchor),
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

    @objc private func chooseCategoryAction(_ sender: UIButton) {
        viewModel?.fetchSpecificCategory(tag: sender.tag)
    }
}

/// UISearchResultsUpdating
extension MovieListViewController: UISearchResultsUpdating {
    // MARK: - Public methods

    func updateSearchResults(for _: UISearchController) {
        viewModel?.filterContentForSearch(searchController.searchBar.text ?? Constants.emptyString)
    }

    // MARK: - Private methods

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
    // MARK: - Public methods

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
            let movie = isFiltering ? viewModel?.filteredMovies?[indexPath.row] : viewModel?.movies[indexPath.row],
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
        guard
            let movies = viewModel?.movies,
            indexPath.row == movies.count - 4
        else { return }
        viewModel?.fetchMoreMovies()
    }
}

/// UICollectionViewDelegate
extension MovieListViewController: UICollectionViewDelegate {
    // MARK: - Public methods

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let id = viewModel?.movies[indexPath.row].id else { return }
        viewModel?.showMovieDetail(id: "\(id)")
    }
}
