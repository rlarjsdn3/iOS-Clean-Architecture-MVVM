//
//  NetworkSessionManagerMock.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/19/24.
//

import Foundation

struct NetworkSessionManagerMock: NetworkSessionManager {
    let response: HTTPURLResponse?
    let data: Data?
    let error: (any Error)?
    
    func request(_ request: URLRequest,
                 completion: @escaping CompletionHandler) -> any NetworkCancellable {
        completion(data, response, error)
        return URLSessionDataTask()
    }
}
