// NetworkServiceCore.swift
// Copyright © RoadMap. All rights reserved.

import Foundation

/// Network service core
class NetworkServiceCore {
    // MARK: - Private Constants

    private enum UrlComponent {
        static let movieBaseUrlText = "https://api.themoviedb.org/3/movie/"
        static let apiKeyText = "7305af56f5e3e8404ad79e2f0c7cefe0"
        static let languageValueText = "ru-RU"
        static let regionValueText = "ru"
    }

    private enum QueryItems {
        static let languageQueryText = "language"
        static let regionQueryText = "region"
        static let apiKeyQueryText = "api_key"
        static let pageQueryText = "page"
    }

    private enum Constants {
        static let emptyString = ""
    }

    // MARK: - Private properties.

    // MARK: - Public methods

    func getJson<T: Decodable>(
        id: String?,
        categoryOfMovies: String?,
        page: Int?,
        completion: @escaping (Result<T, Error>) -> Void
    ) {
        guard let url = configureUrlComponents(id: id, categoryOfMovies: categoryOfMovies, page: page)?.url
        else { return }
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else { return }
            do {
                let decoder = JSONDecoder()
                let data = try decoder.decode(T.self, from: data)
                completion(.success(data))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }

    // MARK: - Private methods

    private func configureUrlComponents(id: String?, categoryOfMovies: String?, page: Int?) -> URLComponents? {
        guard
            var urlComponents = URLComponents(
                string:
                UrlComponent
                    .movieBaseUrlText + (id ?? Constants.emptyString) + (categoryOfMovies ?? Constants.emptyString)
            )
        else { return URLComponents() }
        urlComponents.queryItems = [
            URLQueryItem(name: QueryItems.apiKeyQueryText, value: UrlComponent.apiKeyText),
            URLQueryItem(name: QueryItems.languageQueryText, value: UrlComponent.languageValueText),
            URLQueryItem(name: QueryItems.regionQueryText, value: UrlComponent.regionValueText)
        ]
        if page != nil {
            urlComponents.queryItems?.append(URLQueryItem(name: QueryItems.pageQueryText, value: "\(page ?? 0)"))
        }
        return urlComponents
    }
}
