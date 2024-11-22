//
//  APIManager.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

enum MyError: Error {
    /// example error handling with no actual implementation
    case apiResponseError
    case unknown(String) // Captures a default-like case with a description
    
    /// Optional initializer to wrap any other Error into MyError
    init(_ error: Error) {
        if let myError = error as? MyError {
            self = myError
        } else {
            self = .unknown(error.localizedDescription)
        }
    }
}

protocol ApiManagerProtocol: Sendable {
    func makeNetworkCall<T: Codable>(router: Routable) async throws -> T
    func makeNetworkCallWithoutResponse(router: Routable) async -> Bool
}

final class ApiManager: ApiManagerProtocol {
    
    private let apiClient: APIClientProtocol
    
    init(client: APIClientProtocol) {
        self.apiClient = client
    }
    
    func makeNetworkCall<T: Codable>(router: Routable) async throws -> T {
        let urlRequest = router.urlRequest
        let response = await apiClient.dataTask(urlRequest)
        switch response {
        case .success((let data, _)):
            let decoder = JSONDecoder()
            do {
                let apiResponse = try decoder.decode(T.self, from: data)
                return apiResponse
            } catch let error {
                throw error
            }
        case .failure(let error):
            throw error
        }
    }
    
    func makeNetworkCallWithoutResponse(router: Routable) async -> Bool {
        let urlRequest = router.urlRequest
        let response = await apiClient.dataTask(urlRequest)
        switch response {
        case .success((_, let response)):
            let statusCode = response.statusCode
            switch statusCode {
            case 200:
                return true
            default:
                return false
            }
        case .failure:
            return false
        }
    }
}
