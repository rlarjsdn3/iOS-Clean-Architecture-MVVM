//
//  MoviesResponseEntity+Mapping.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/28/24.
//

import CoreData
import Foundation

extension MoviesResponseEntity {
    func toDto() -> MoviesResponseDTO {
        return .init(
            page: Int(page),
            totalPages: Int(totalPages),
            movies: movies?.allObjects.map { ($0 as! MovieResponseEntity).toDto() } ?? []
        )
    }
}

extension MovieResponseEntity {
    func toDto() -> MoviesResponseDTO.MovieDTO {
        return .init(
            id: Int(id),
            title: title,
            genre: MoviesResponseDTO.MovieDTO.GenreDTO(rawValue: genre ?? ""),
            posterPath: posterPath,
            overview: overview,
            releaseDate: releaseDate
        )
    }
}

extension MoviesRequestDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesRequestEntity {
        let entity: MoviesRequestEntity = .init(context: context)
        entity.query = query
        entity.page = Int32(page)
        return entity
    }
}

extension MoviesResponseDTO {
    func toEntity(in context: NSManagedObjectContext) -> MoviesResponseEntity {
        let entity: MoviesResponseEntity = .init(context: context)
        entity.page = Int32(page)
        entity.totalPages = Int32(totalPages)
        movies.forEach {
            entity.addToMovies($0.toEntity(in: context))
        }
        return entity
    }
}

extension MoviesResponseDTO.MovieDTO {
    func toEntity(in context: NSManagedObjectContext) -> MovieResponseEntity {
        let entity: MovieResponseEntity = .init(context: context)
        entity.id = Int64(id)
        entity.title = title
        entity.genre = genre?.rawValue
        entity.posterPath = posterPath
        entity.overview = overview
        entity.releaseDate = releaseDate
        return entity
    }
}
