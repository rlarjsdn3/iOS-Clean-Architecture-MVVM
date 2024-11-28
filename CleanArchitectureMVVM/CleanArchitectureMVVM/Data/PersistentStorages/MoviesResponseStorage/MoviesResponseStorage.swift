//
//  MoviesResponseStorage.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/28/24.
//

import Foundation

protocol MoviesResponseStorage {
    func getResponse(
        for request: MoviesRequestDTO,
        completion: @escaping (Result<MoviesResponseDTO?, any Error>) -> Void
    )
    func save(response responseDto: MoviesResponseDTO, for requestDto: MoviesRequestDTO)
}
