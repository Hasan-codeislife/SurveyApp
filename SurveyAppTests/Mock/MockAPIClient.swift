//
//  MockAPIClient.swift
//  SurveyApp
//
//  Created by Hassan Personal on 19.11.24.
//

import Foundation
@testable import SurveyApp

final class MockAPIClient: APIClientProtocol {
    
    func getFileName(from urlRequest: URLRequest) -> String? {
        
        guard let url = urlRequest.url,
              let httpMethod = urlRequest.httpMethod else {
            return nil
        }
        
        let component = url.lastPathComponent.split(separator: "?")
        guard let firstWord = component.first?.description else {
            return nil
        }
        let fileName = "\(httpMethod)_\(firstWord)".lowercased()
        return fileName
    }
    
    func dataTask(_ request: URLRequest) async -> MyURLResponse {
        
        guard let url = request.url,
              let fileName = getFileName(from: request)
        else {
            return MyURLResponse.failure(MyError.apiResponseError)
        }
        guard let pathString = Bundle.main.url(forResource: fileName, withExtension: "json").self
        else {
            return MyURLResponse.failure(MyError.unknown(""))
        }
        
        // Mimic API delay
        sleep(2)
        
        do {
            let jsonData = try Data(contentsOf: pathString)
            if let response = HTTPURLResponse(url: url, statusCode: 200, httpVersion: nil, headerFields: nil) {
                return .success((data: jsonData, response: response))
            }
        } catch {
            return MyURLResponse.failure(MyError.apiResponseError)
        }
        return MyURLResponse.failure(MyError.unknown(""))
    }
}
