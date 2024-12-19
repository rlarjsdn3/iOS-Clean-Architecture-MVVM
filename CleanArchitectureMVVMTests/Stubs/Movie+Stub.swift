//
//  Movie+Stub.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/19/24.
//

import Foundation

extension Movie {
    static func sub(id: Movie.ID = "id1",
                    title: String = "title1",
                    genre: Movie.Genre = .adventure,
                    posterPath: String? = "/1",
                    overview: String = "overview1",
                    releaseDate: Date? = nil) -> Self {
        Movie(id: id,
              title: title,
              genre: genre,
              posterPath: posterPath,
              overview: overview,
              releaseDate: releaseDate)
    }
}
