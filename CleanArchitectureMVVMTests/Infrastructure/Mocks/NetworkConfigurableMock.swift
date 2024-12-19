//
//  NetworkConfigurableMock.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/19/24.
//

import Foundation

struct NetworkConfigurableMock: NetworkConfigurable {
    var baseURL: URL = URL(string: "https://mock.test.com")!
    var headers: [String : String] = [:]
    var queryParameters: [String : String] = [:]
}
