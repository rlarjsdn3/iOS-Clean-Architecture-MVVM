//
//  UseCase.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/26/24.
//

import Foundation

protocol UseCase {
    @discardableResult
    func start() -> (any Cancellable)?
}
