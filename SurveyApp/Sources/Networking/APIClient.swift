//
//  APIClient.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

typealias MyURLResponse = Result<(data: Data, response: HTTPURLResponse), Error>

protocol APIClientProtocol: Sendable {
    func dataTask(_ request: URLRequest) async -> MyURLResponse
}

final class APIClientURLSession: APIClientProtocol {
    func dataTask(_ request: URLRequest) async -> MyURLResponse {
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let response = response as? HTTPURLResponse else {
                throw MyError.unknown
            }
            return .success((data: data, response: response))
        } catch(let error) {
            return .failure(error)
        }
    }
}
