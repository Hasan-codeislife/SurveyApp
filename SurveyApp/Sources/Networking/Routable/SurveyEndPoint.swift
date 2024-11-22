//
//  SurveyEndPoint.swift
//  SurveyApp
//
//  Created by Hassan Personal on 18.11.24.
//

import Foundation

enum SurveyEndPoint: Routable {
        
    case getSurveyQuestions
    case postSurveyQuestion(id: Int, answer: String)
    
    var path: String {
        switch self {
        case .getSurveyQuestions:
            return baseURLString + "questions"
        case .postSurveyQuestion:
            return baseURLString + "question/submit"
        }
    }
    
    var params: APIParams? {
        switch self {
        case .getSurveyQuestions:
            return nil
        case .postSurveyQuestion(let id, let answer):
            return ["id": id, "answer": answer]
        }
    }
    
    var method: APIMehtod {
        switch self {
        case .getSurveyQuestions:
            return .get
        case .postSurveyQuestion:
            return .post
        }
    }
    
    var urlRequest: URLRequest {
        let url = URL(string: self.path)!
        return URLRequest(requestURL: url,
                          method: self.method,
                          header: nil,
                          body: self.params ?? nil)
    }
}
