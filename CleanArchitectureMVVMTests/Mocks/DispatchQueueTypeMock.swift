//
//  DispatchQueueTypeMock.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/19/24.
//

import Foundation

final class DispatchQueueTypeMock: DispatchQueueType {
    func async(execute work: @escaping () -> Void) {
        work()
    }
}
