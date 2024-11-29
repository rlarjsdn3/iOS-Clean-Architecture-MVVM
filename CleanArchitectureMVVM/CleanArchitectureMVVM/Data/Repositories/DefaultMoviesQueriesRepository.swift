//
//  DefaultMoviesQueriesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import Foundation

final class DefaultMoviesQueriesRepository {
    
    private var moviesQueriesPersistentStorage: any MoviesQueriesStorage
    
    init(moviesQueriesPersistentStorage: any MoviesQueriesStorage) {
        self.moviesQueriesPersistentStorage = moviesQueriesPersistentStorage
    }
}

extension DefaultMoviesQueriesRepository: MoviesQueriesRepository {
    
    func fetchRecentsQueries(
        maxCount: Int,
        completion: @escaping (Result<[MovieQuery], any Error>) -> Void
    ) {
        return moviesQueriesPersistentStorage.fetchRecentQueries(
            maxCount: maxCount,
            completion: completion
        )
    }
    
    func saveRecentQuery(
        query: MovieQuery,
        completion: @escaping (Result<MovieQuery, any Error>) -> Void
    ) {
        moviesQueriesPersistentStorage.saveRecentQuery(
            query: query,
            completion: completion
        )
    }
}
