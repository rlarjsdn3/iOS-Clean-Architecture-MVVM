//
//  MoviesQueriesListItemViewModel.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 12/3/24.
//

import Foundation

class MoviesQueryListItemViewModel {
    let query: String
    
    init(query: String) {
        self.query = query
    }
}

extension MoviesQueryListItemViewModel: Equatable {
    static func == (lhs: MoviesQueryListItemViewModel, rhs: MoviesQueryListItemViewModel) -> Bool {
        return lhs.query == rhs.query
    }
}
