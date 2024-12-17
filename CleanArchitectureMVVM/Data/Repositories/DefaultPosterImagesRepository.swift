//
//  DefaultPosterImagesRepository.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import Foundation

final class DefaultPosterImagesRepository {
    
    private let dataTransferService: any DataTransferService
    private let backgroundQueue: any DataTransferDispatchQueue
    
    init(
        dataTransferService: any DataTransferService,
        backgroundQueue: any DataTransferDispatchQueue = DispatchQueue.global(qos: .userInitiated)
    ) {
        self.dataTransferService = dataTransferService
        self.backgroundQueue = backgroundQueue
    }
}

extension DefaultPosterImagesRepository: PosterImagesRepository {
    
    func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, any Error>) -> Void
    ) -> (any Cancellable)? {
        
        let endpoint = APIEndpoints.getMoviePoster(path: imagePath, width: width)
        let task = RepositoryTask()
        task.networkTask = dataTransferService.request(with: endpoint, on: backgroundQueue){ (result: Result<Data, DataTransferError>) in
            
            let result = result.mapError { $0 as Error }
            completion(result)
        }
        return task
    }
}
