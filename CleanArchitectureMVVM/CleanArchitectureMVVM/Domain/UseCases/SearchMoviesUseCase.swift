//
//  SearchMoviesUseCase.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

protocol SearchMoviesUseCase {
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, any Error>) -> Void
    ) -> (any Cancellable)?
}

final class DefaultSearchMoviesUseCase: SearchMoviesUseCase {
    
    private let moviesRepository: MoviesRepository
    private let moviesQueriesRepository: MoviesQueryRepository
    
    init(
        moviesRepository: MoviesRepository,
        moviesQueriesRepository: MoviesQueryRepository
    ) {
        self.moviesRepository = moviesRepository
        self.moviesQueriesRepository = moviesQueriesRepository
    }
    
    func execute(
        requestValue: SearchMoviesUseCaseRequestValue,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, any Error>) -> Void
    ) -> (any Cancellable)? {
        
        return moviesRepository.fetchMoviesList(
            query: requestValue.query,
            page: requestValue.page,
            cached: cached) { result in
                
                if case .success = result {
                    self.moviesQueriesRepository.saveRecentQuery(query: requestValue.query) { _ in }
                }
                
                completion(result)
            }
        
    }
    
}

struct SearchMoviesUseCaseRequestValue {
    let query: MovieQuery
    let page: Int
}
