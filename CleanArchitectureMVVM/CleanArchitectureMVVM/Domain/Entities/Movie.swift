//
//  Movie.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

struct Movie: Equatable, Identifiable {
    typealias ID = String
    enum Genre {
        case adventure
        case scienceFiction
    }
    let id: ID
    let title: String?
    let genre: Genre?
    let posterPath: String?
    let overview: String?
    let releaseDate: Date?
}

struct MoviesPage: Equatable {
    let page: Int
    let totelPages: Int
    let movies: [Movie]
}
