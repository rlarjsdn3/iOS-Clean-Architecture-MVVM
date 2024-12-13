//
//  RepositoryTask.swift
//  CleanArchitectureMVVM
//
//  Created by 김건우 on 11/29/24.
//

import Foundation

class RepositoryTask: Cancellable {
    var networkTask: NetworkCancellable?
    var isCancelled: Bool = false
    
    func cancel() {
        networkTask?.cancel()
        isCancelled = true
    }
}
