//
//  MovieQuery+Mapping.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import CoreData
import Foundation

extension MovieQueryEntity {
    convenience init(movieQuery: MovieQuery, insertInto context: NSManagedObjectContext) {
        self.init(context: context)
        query = movieQuery.query
        createdAt = Date()
    }
}

extension MovieQueryEntity {
    func toDomain() -> MovieQuery {
        return .init(query: query ?? "")
    }
}
