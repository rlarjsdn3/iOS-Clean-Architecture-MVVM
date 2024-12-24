//
//  PosterImagesRepositoryMock.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/24/24.
//

import Foundation
import XCTest

class PosterImagesRepositoryMock: PosterImagesRepository {
    var completionCalls = 0
    var error: (any Error)?
    var image = Data()
    var validateInput: ((String, Int) -> Void)?
    
    func fetchImage(
        with imagePath: String,
        width: Int,
        completion: @escaping (Result<Data, any Error>) -> Void
    ) -> (any Cancellable)? {
        validateInput?(imagePath, width)
        if let error = error {
            completion(.failure(error))
        } else {
            completion(.success(image))
        }
        completionCalls += 1
        return nil
    }
}
