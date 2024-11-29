//
//  DefaultMoviesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import Foundation

final class DefaultMoviesRepository {
    
    private let dataTransferService: any DataTransferService
    private let cache: any MoviesResponseStorage
    private let backgroundQueue: any DataTransferDispatchQueue
    
    init(
        dataTransferService: any DataTransferService,
        cache: any MoviesResponseStorage,
        backgroundQueue: any DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.cache = cache
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultMoviesRepository: MoviesRepository {
    
    func fetchMoviesList(
        query: MovieQuery,
        page: Int,
        cached: @escaping (MoviesPage) -> Void,
        completion: @escaping (Result<MoviesPage, any Error>) -> Void
    ) -> (any Cancellable)? {
        
        let requestDTO = MoviesRequestDTO(query: query.query, page: page)
        let task = RepositoryTask()
        
        cache.getResponse(for: requestDTO) { [weak self, backgroundQueue] result in
            
            if case let .success(responseDTO?) = result {
                cached(responseDTO.toDomain())
            }
            guard !task.isCancelled else { return }
            
            let endpoint = APIEndpoints.getMovies(with: requestDTO)
            task.networkTask = self?.dataTransferService.request(with: endpoint, on: backgroundQueue) { result in
                switch result {
                case .success(let responseDTO):
                    self?.cache.save(response: responseDTO, for: requestDTO)
                    completion(.success(responseDTO.toDomain()))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
        return task
    }
    
}
