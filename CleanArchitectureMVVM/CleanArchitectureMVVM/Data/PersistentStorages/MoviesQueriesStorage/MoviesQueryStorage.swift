//
//  MoviesQueryStorage.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

protocol MoviesQueryStorage {
    func fetchRecentQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], any Error>) -> Void
    )
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, any Error>) -> Void
    )
}
