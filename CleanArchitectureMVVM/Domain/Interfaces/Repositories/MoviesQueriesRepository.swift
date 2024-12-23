//
//  MoviesQueriesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

protocol MoviesQueriesRepository {
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], Error>) -> Void
    )
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, Error>) -> Void
    )
}
