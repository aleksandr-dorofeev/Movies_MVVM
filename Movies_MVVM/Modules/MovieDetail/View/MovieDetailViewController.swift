// MovieDetailViewController.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Screen with detail of selected movie
final class MovieDetailViewController: UIViewController {
    // MARK: - Private Constants

    private enum Identifier {
        static let posterCellID = "PosterCell"
        static let infoCellID = "InfoCell"
        static let overviewCellID = "OverviewCell"
        static let genreCellID = "GenreCell"
        static let castCellID = "CastCell"
    }

    private enum Constants {
        static let backButtonImageName = "chevron.backward"
        static let bottomShadowImageName = "bottomShadow"
        static let castUrlComponent = "/credits"
        static let errorTitle = "Error"
    }

    private enum TypeOfCell {
        case poster
        case info
        case genre
        case overview
        case actors
    }

    // MARK: - Public properties

    var viewModel: MovieDetailViewModelProtocol?

    // MARK: - Private properties

    private let typesOfCell: [TypeOfCell] = [.poster, .info, .genre, .overview, .actors]

    // MARK: - Private visual components

    private lazy var movieTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.scrollsToTop = false
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private lazy var backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: Constants.backButtonImageName, withConfiguration: config)
        button.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        button.setImage(image, for: .normal)
        button.tintColor = UIColor(named: Colors.favoriteMovieColorName)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar(isHidden: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        configureNavigationBar(isHidden: false)
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        setupConstraintsForBackButton()
        createConstraintsForTableView()
    }

    // MARK: - Private methods

    private func setupUI() {
        view.addSubview(movieTableView)
        view.addSubview(backButton)
        registerCells()
        updateView()
        showErrorAlert()
    }

    private func updateView() {
        viewModel?.successDetailHandler = {
            DispatchQueue.main.async {
                self.movieTableView.reloadData()
            }
        }
    }

    private func showErrorAlert() {
        viewModel?.failureDetailHandler = { error in
            DispatchQueue.main.async {
                self.showAlert(
                    title: Constants.errorTitle,
                    message: error.localizedDescription,
                    actionTitle: nil,
                    handler: nil
                )
            }
        }
    }

    private func registerCells() {
        movieTableView.register(
            PosterMovieTableViewCell.self,
            forCellReuseIdentifier: Identifier.posterCellID
        )
        movieTableView.register(
            MovieInfoTableViewCell.self,
            forCellReuseIdentifier: Identifier.infoCellID
        )
        movieTableView.register(
            GenreTableViewCell.self,
            forCellReuseIdentifier: Identifier.genreCellID
        )
        movieTableView.register(
            OverviewTableViewCell.self,
            forCellReuseIdentifier: Identifier.overviewCellID
        )
        movieTableView.register(
            CastTableViewCell.self,
            forCellReuseIdentifier: Identifier.castCellID
        )
    }

    private func configureNavigationBar(isHidden: Bool) {
        navigationController?.navigationBar.isHidden = isHidden
    }

    private func createConstraintsForTableView() {
        NSLayoutConstraint.activate(
            [
                movieTableView.topAnchor
                    .constraint(equalTo: view.topAnchor, constant: -60),
                movieTableView.leadingAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                movieTableView.trailingAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
                movieTableView.bottomAnchor
                    .constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ]
        )
    }

    private func setupConstraintsForBackButton() {
        NSLayoutConstraint.activate(
            [
                backButton.topAnchor
                    .constraint(equalTo: movieTableView.topAnchor, constant: 100),
                backButton.leadingAnchor
                    .constraint(equalTo: movieTableView.leadingAnchor, constant: 5),
                backButton.heightAnchor
                    .constraint(equalToConstant: 30),
                backButton.widthAnchor
                    .constraint(equalToConstant: 50)
            ]
        )
    }

    @objc private func backAction() {
        viewModel?.backPreviousScreen()
    }
}

/// UITableViewDataSource
extension MovieDetailViewController: UITableViewDataSource {
    // MARK: - Public methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        typesOfCell.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = typesOfCell[indexPath.row]
        switch cell {
        case .poster:
            guard
                let posterCell = tableView.dequeueReusableCell(
                    withIdentifier: Identifier.posterCellID,
                    for: indexPath
                ) as? PosterMovieTableViewCell,
                let movieDetail = viewModel?.movieDetail,
                let imageService = viewModel?.imageService
            else { return UITableViewCell() }
            posterCell.configure(imageService, movieDetail: movieDetail)
            return posterCell
        case .info:
            guard
                let infoCell = tableView.dequeueReusableCell(
                    withIdentifier: Identifier.infoCellID,
                    for: indexPath
                ) as? MovieInfoTableViewCell,
                let movieDetail = viewModel?.movieDetail
            else { return UITableViewCell() }
            infoCell.configure(movieDetail)
            return infoCell
        case .genre:
            guard
                let genreCell = tableView.dequeueReusableCell(
                    withIdentifier: Identifier.genreCellID,
                    for: indexPath
                ) as? GenreTableViewCell,
                let movieDetail = viewModel?.movieDetail
            else { return UITableViewCell() }
            genreCell.configure(movieDetail)
            return genreCell
        case .overview:
            guard let overviewCell = tableView.dequeueReusableCell(
                withIdentifier: Identifier.overviewCellID,
                for: indexPath
            ) as? OverviewTableViewCell,
                let movieDetail = viewModel?.movieDetail
            else { return UITableViewCell() }
            overviewCell.configure(movieDetail)
            return overviewCell
        case .actors:
            guard let actorCell = tableView.dequeueReusableCell(
                withIdentifier: Identifier.castCellID,
                for: indexPath
            ) as? CastTableViewCell,
                let id = viewModel?.id,
                let viewModel = viewModel
            else { return UITableViewCell() }
            actorCell.viewModel = viewModel
            let castComponents = id + Constants.castUrlComponent
            actorCell.configure(components: castComponents)
            return actorCell
        }
    }
}
