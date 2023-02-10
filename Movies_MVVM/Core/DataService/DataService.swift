// DataService.swift
// Copyright © Aleksandr Dorofeev. All rights reserved.

import CoreData
import UIKit

/// Data storage
final class DataService: DataServiceProtocol {
    // MARK: - Private Constants

    private enum Constants {
        static let movieEntityName = "MovieData"
        static let movieDetailEntityName = "MovieDetailData"
        static let genreEntityName = "GenreData"
        static let emptyString = ""
        static let predicateCategoryFormat = "movieType CONTAINS %@"
        static let predicateIdFormat = "movieType CONTAINS %@"
    }

    // MARK: - Private properties

    private let dataCore = DataCore()

    // MARK: - Public properties

    func writeMovieData(movies: [Movie], category: String) {
        guard let entity = NSEntityDescription.entity(forEntityName: Constants.movieEntityName, in: dataCore.context)
        else { return }
        dataCore.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        for movie in movies {
            let movieObject = MovieData(entity: entity, insertInto: dataCore.context)
            movieObject.id = Int64(movie.id)
            movieObject.posterPath = movie.posterPath
            movieObject.title = movie.title
            movieObject.voteAverage = movie.voteAverage
            movieObject.movieType = category
        }
        dataCore.saveContext()
    }

    func writeMovieDetailData(movieDetail: MovieDetail, id: Int) {
        guard
            let movieDetailEntity = NSEntityDescription.entity(
                forEntityName: Constants.movieDetailEntityName,
                in: dataCore.context
            ),
            let movieGenreEntity = NSEntityDescription.entity(
                forEntityName: Constants.genreEntityName,
                in: dataCore.context
            )
        else { return }
        dataCore.context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        let movieDetailObject = MovieDetailData(entity: movieDetailEntity, insertInto: dataCore.context)
        movieDetailObject.posterPath = movieDetail.posterPath
        movieDetailObject.title = movieDetail.title
        movieDetailObject.voteAverage = movieDetail.voteAverage
        movieDetailObject.overview = movieDetail.overview
        movieDetailObject.releaseDate = movieDetail.releaseDate
        movieDetailObject.id = Int64(movieDetail.id)
        for genre in movieDetail.genres {
            let genreObject = GenreData(entity: movieGenreEntity, insertInto: dataCore.context)
            genreObject.name = genre.name
            movieDetailObject.addToGenres(genreObject)
        }
        dataCore.saveContext()
    }

    func readMovieData(category: String) -> [Movie]? {
        var movies: [Movie] = []
        let movieRequest = MovieData.fetchRequest()
        let predicate = NSPredicate(format: Constants.predicateCategoryFormat, category)
        movieRequest.predicate = predicate
        do {
            let moviesData = try dataCore.context.fetch(movieRequest)
            for movieData in moviesData {
                let movie = Movie(
                    id: Int(movieData.id),
                    posterPath: movieData.posterPath ?? Constants.emptyString,
                    title: movieData.title ?? Constants.emptyString,
                    voteAverage: movieData.voteAverage
                )
                movies.append(movie)
            }
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        return movies
    }

    func readMovieDetailData(id: Int) -> MovieDetail? {
        var movieDetail: MovieDetail
        var genres: [MovieDetail.Genres] = []
        let movieDetailRequest = MovieDetailData.fetchRequest()
        let predicate = NSPredicate(format: Constants.predicateIdFormat, id)
        movieDetailRequest.predicate = predicate
        do {
            guard
                let movieDetailData = try dataCore.context.fetch(movieDetailRequest).first,
                let genresData = movieDetailData.genres?.allObjects as? [GenreData]
            else { return nil }
            for genre in genresData {
                let genre = MovieDetail.Genres(name: genre.name ?? Constants.emptyString)
                genres.append(genre)
            }
            movieDetail = MovieDetail(
                posterPath: movieDetailData.posterPath ?? Constants.emptyString,
                title: movieDetailData.title ?? Constants.emptyString,
                voteAverage: movieDetailData.voteAverage,
                releaseDate: movieDetailData.releaseDate ?? Constants.emptyString,
                genres: genres,
                overview: movieDetailData.overview ?? Constants.emptyString,
                id: id
            )
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        return movieDetail
    }
}
