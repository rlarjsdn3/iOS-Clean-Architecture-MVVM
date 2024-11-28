//
//  MoviesRequestDTO+Mapping.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/28/24.
//

import Foundation

struct MoviesRequestDTO: Encodable {
    let query: String
    let page: Int
}
