//
//  NetworkServiceTests.swift
//  CleanArchitectureMVVMTests
//
//  Created by 김건우 on 12/19/24.
//

import XCTest

class NetworkServiceTests: XCTestCase {
    
    private struct EndpointMock: Requestable {
        var path: String
        var isFullPath: Bool = false
        var method: HttpMethodType
        var headerParameters: [String : String] = [:]
        var queryParametersEncodable: (any Encodable)? = nil
        var queryParameters: [String : Any] = [:]
        var bodyParametersEncodable: (any Encodable)? = nil
        var bodyParameters: [String : Any] = [:]
        var bodyEncoder: any BodyEncoder = AsciiBodyEncoder()
        
        init(path: String, method: HttpMethodType) {
            self.path = path
            self.method = method
        }
    }
    
    class NetworkErrorLoggerMock: NetworkErrorLogger {
        var loggedErrors: [any Error] = []
        func log(request: URLRequest) { }
        func log(responseData data: Data?, response: URLResponse?) { }
        func log(error: any Error) { loggedErrors.append(error) }
    }
    
    private enum NetworkErrorMock: Error {
        case someError
    }
    
    func test_whenMockDataPassed_shouldReturnProperResponse() {
        // given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let expectedResponseData = "Response data".data(using: .utf8)!
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: expectedResponseData,
                error: nil
            )
        )
        // when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            guard let responseData = try? result.get() else {
                XCTFail("Should return proper response")
                return
            }
            XCTAssertEqual(responseData, expectedResponseData)
            completionCallsCount += 1
        }
        // then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenErrorWithNSURLCancelledReturned_shouldRturnCancelledError() {
        // given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let cancelledError = NSError(domain: "network", code: NSURLErrorCancelled, userInfo: nil)
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: nil,
                error: cancelledError
            )
        )
        // when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                guard case NetworkError.cancelled = error else {
                    XCTFail("NetworkError.cancelled not found")
                    return
                }
                
                completionCallsCount += 1
            }
        }
        // then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenErrorWithNSURLErrorNotConnectedToInternetReturned_shouldReturnNotConnectedError() {
        // given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let notConnectedToInternetError = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: nil,
                error: notConnectedToInternetError
            )
        )
        // when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Shoud not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
            }
            
            completionCallsCount += 1
        }
        // then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenStatusCodeEqualOrAbove400_shoudReturnhasStatusCodeError() {
        // given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let response = HTTPURLResponse(url: URL(string: "test_url")!,
                                       statusCode: 500,
                                       httpVersion: "1.1",
                                       headerFields: [:])
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: response,
                data: nil,
                error: NetworkErrorMock.someError
            )
        )
        //when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Should not happen")
            } catch let error {
                if case NetworkError.error(let statusCode, _) = error {
                    XCTAssertEqual(statusCode, 500)
                    completionCallsCount += 1
                }
            }
        }
        // then
        XCTAssertEqual(completionCallsCount, 1)
    }
    
    func test_whenhasStatusCodeUsedWithWrongError_shouldReturnFalse() {
        // when
        let sut = NetworkError.notConnected
        // then
        XCTAssertFalse(sut.hasStatusCode(200))
    }
    
    func test_whenhasStatusCodeUsed_shouldReturnCorrectStatusCode() {
        // when
        let sut = NetworkError.error(statusCode: 400, data: nil)
        // then
        XCTAssertTrue(sut.hasStatusCode(400))
        XCTAssertFalse(sut.hasStatusCode(399))
        XCTAssertFalse(sut.hasStatusCode(401))
    }
    
    func test_whenErrorWithNSURLErrorNotConntectedTOInternetReturned_shouldLogThisError() {
        // given
        let config = NetworkConfigurableMock()
        var completionCallsCount = 0
        
        let error = NSError(domain: "network", code: NSURLErrorNotConnectedToInternet, userInfo: nil)
        let networkErrorLogger = NetworkErrorLoggerMock()
        let sut = DefaultNetworkService(
            config: config,
            sessionManager: NetworkSessionManagerMock(
                response: nil,
                data: nil,
                error: error
            ),
            logger: networkErrorLogger
        )
        // when
        _ = sut.request(endpoint: EndpointMock(path: "http://mock.test.com", method: .get)) { result in
            do {
                _ = try result.get()
                XCTFail("Shoud not happen")
            } catch let error {
                guard case NetworkError.notConnected = error else {
                    XCTFail("NetworkError.notConnected not found")
                    return
                }
                
                completionCallsCount += 1
            }
        }
        // then
        XCTAssertEqual(completionCallsCount, 1)
        XCTAssertTrue(networkErrorLogger.loggedErrors.contains {
            guard case NetworkError.notConnected = $0 else { return false }
            return true
        })
    }
    
}
