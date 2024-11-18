//
//  APIManager.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

enum MyError: Error {
    /// example error handling with no actual implementation
    case unknown
    case apiResponseError
}

protocol ApiManagerProtocol: Sendable {
    func makeNetworkCall<T: Codable>(router: Routable) async throws -> T
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
            /// You can also implement individual status codes here for various functions (e.g upgrade popup)
        case .failure(let error):
            throw error
        }
    }
}
