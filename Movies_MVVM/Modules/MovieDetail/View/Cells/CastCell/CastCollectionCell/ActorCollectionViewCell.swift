// ActorCollectionViewCell.swift
// Copyright © RoadMap. All rights reserved.

import UIKit

/// Collection cell with actor
final class ActorCollectionViewCell: UICollectionViewCell {
    // MARK: - Private Constants

    private enum Constants {
        static let personPlaceholder = "personPlaceholder"
    }

    // MARK: - Private visual components

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(named: Colors.navigationBarColorName)?.cgColor
        view.layer.masksToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let actorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private let actorImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 40
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor(named: Colors.navigationBarColorName)?.cgColor
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let actorNameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: Colors.tintColorName)
        label.font = UIFont(name: ConstantsFonts.titleFontName, size: 10)
        label.numberOfLines = 0
        return label
    }()

    private let characterNameLabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = UIColor(named: Colors.textColorName)
        label.font = UIFont(name: ConstantsFonts.titleFontName, size: 10)
        label.numberOfLines = 0
        return label
    }()

    // MARK: - Private properties

    private var currentActorPath = ""

    // MARK: - Life cycle

    override func layoutSubviews() {
        super.layoutSubviews()
        setupUI()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        actorImageView.image = UIImage(named: Constants.personPlaceholder)
    }

    // MARK: - Public properties

    func configure(imageService: ImageServiceProtocol, cast: Cast) {
        currentActorPath = cast.profilePath ?? ""
        actorNameLabel.text = cast.name
        characterNameLabel.text = cast.character
        getActorImage(imageService: imageService, cast: cast)
    }

    // MARK: - Private methods

    private func setupUI() {
        contentView.addSubview(containerView)
        contentView.addSubview(actorImageView)
        contentView.addSubview(actorStackView)
        actorStackView.addArrangedSubview(actorNameLabel)
        actorStackView.addArrangedSubview(characterNameLabel)
        setupConstraintsForContainerView()
        setupConstraintsForActorImageView()
        setupConstraintsForActorInfoStackView()
    }

    private func getActorImage(imageService: ImageServiceProtocol, cast: Cast) {
        guard let actorPoster = cast.profilePath else { return }
        imageService.getImage(imagePath: actorPoster) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case let .success(data):
                guard
                    cast.profilePath == self.currentActorPath,
                    let data = data
                else { return }
                DispatchQueue.main.async {
                    self.actorImageView.image = UIImage(data: data)
                }
            case let .failure(error):
                print(error.localizedDescription)
            }
        }
    }

    private func setupConstraintsForContainerView() {
        NSLayoutConstraint.activate(
            [
                contentView.heightAnchor
                    .constraint(equalTo: containerView.heightAnchor),
                contentView.widthAnchor
                    .constraint(equalTo: containerView.widthAnchor),
                containerView.centerYAnchor
                    .constraint(equalTo: contentView.centerYAnchor),
                containerView.centerXAnchor
                    .constraint(equalTo: contentView.centerXAnchor)
            ]
        )
    }

    private func setupConstraintsForActorImageView() {
        NSLayoutConstraint.activate([
            actorImageView.widthAnchor
                .constraint(equalToConstant: 80),
            actorImageView.heightAnchor
                .constraint(equalToConstant: 80),
            actorImageView.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            actorImageView.leadingAnchor
                .constraint(equalTo: leadingAnchor, constant: -10)
        ])
    }

    private func setupConstraintsForActorInfoStackView() {
        NSLayoutConstraint.activate([
            actorStackView.centerYAnchor
                .constraint(equalTo: containerView.centerYAnchor),
            actorStackView.leadingAnchor
                .constraint(equalTo: actorImageView.trailingAnchor, constant: 10),
            actorStackView.trailingAnchor
                .constraint(equalTo: containerView.trailingAnchor),
            actorStackView.heightAnchor
                .constraint(equalToConstant: 100)
        ])
    }
}
