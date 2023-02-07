// CastTableViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Cell with cast collection view
final class CastTableViewCell: UITableViewCell, UICollectionViewDataSource {
    // MARK: - Private Constants

    private enum Constants {
        static let errorMessage = "Error"
    }

    private enum Identifier {
        static let actorCellID = "ActorCollectionCell"
    }

    // MARK: - Public properties

    var viewModel: MovieDetailViewModelProtocol?

    // MARK: - Private visual components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var castCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout())
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(
            ActorCollectionViewCell.self,
            forCellWithReuseIdentifier: Identifier.actorCellID
        )
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()

    private func collectionViewLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        let cellWidthConstant: CGFloat = 180
        let cellHeightConstant: CGFloat = 150
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10)
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: cellWidthConstant, height: cellHeightConstant)
        return layout
    }

    // MARK: - Life cycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError(Constants.errorMessage)
    }

    // MARK: - Public methods.

    func configure(components: String) {
        viewModel?.fetchCast(components: components)
        updateView()
        showError()
    }

    // MARK: - Private methods

    private func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(castCollectionView)
        setupConstraintsForContentView()
        setupConstraintsForCollectionView()
    }

    private func updateView() {
        viewModel?.successActorsHandler = {
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }

    private func showError() {
        viewModel?.failureActorsHandler = { error in
            print(error.localizedDescription)
        }
    }

    private func setupConstraintsForContentView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.heightAnchor
                    .constraint(equalTo: castCollectionView.heightAnchor),
                containerView.widthAnchor
                    .constraint(equalTo: castCollectionView.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForCollectionView() {
        NSLayoutConstraint.activate([
            castCollectionView.centerXAnchor
                .constraint(equalTo: containerView.centerXAnchor),
            castCollectionView.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            castCollectionView.heightAnchor
                .constraint(equalToConstant: 400)
        ])
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.cast.count ?? 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: Identifier.actorCellID,
                for: indexPath
            ) as? ActorCollectionViewCell,
            let imageService = viewModel?.imageService,
            let cast = viewModel?.cast[indexPath.row]
        else { return UICollectionViewCell() }
        cell.configure(imageService: imageService, cast: cast)
        return cell
    }
}
