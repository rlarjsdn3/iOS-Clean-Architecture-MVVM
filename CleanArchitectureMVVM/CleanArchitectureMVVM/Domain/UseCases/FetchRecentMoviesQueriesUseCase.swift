//
//  FetchRecentMoviesQueriesUseCase.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

// This is another option to create Use Case using more generic way
final class FetchRecentMoviesQueriesUseCase: UseCase {
    
    struct RequestValue {
        let maxCount: Int
    }
    typealias ResultValue = (Result<[MovieQuery], any Error>)
    
    private let requestValue: RequestValue
    private let completion: (ResultValue) -> Void
    private let moviesQuriesRespository: MoviesQueriesRepository
    
    init(
        requestValue: RequestValue,
        completion: @escaping (ResultValue) -> Void,
        moviesQuriesRespository: MoviesQueriesRepository
    ) {
        self.requestValue = requestValue
        self.completion = completion
        self.moviesQuriesRespository = moviesQuriesRespository
    }
    
    func start() -> (any Cancellable)? {
        
        moviesQuriesRespository.fetchRecentsQueries(
            maxCount: requestValue.maxCount,
            completion: completion
        )
        return nil
    }
    
}
