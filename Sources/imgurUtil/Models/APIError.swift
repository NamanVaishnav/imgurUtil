//
//  File.swift
//  
//
//  Created by Naman Vaishnav on 02/01/24.
//

import Foundation

public enum APIServiceError: CustomNSError, Equatable {
    
    case invalidURL
    case invalidResponseType
    case httpStatusCodeFailed(statusCode: Int, error: ErrorResponse?)
    
    public static var errorDomain: String { "imgurUtil" }
    public var errorCode: Int {
        switch self {
        case .invalidURL: return 1
        case .invalidResponseType: return 2
        case .httpStatusCodeFailed: return 3
        }
    }
    
    public var errorUserInfo: [String : Any] {
        let text: String
        switch self {
        case .invalidURL:
            text = "Invalid URL"
        case .invalidResponseType:
            text = "Invalid Response Type"
        case let .httpStatusCodeFailed(statusCode, error):
            if let error = error {
                text = "Error: Status Code\(error.status), message: \(error.data.error)"
            } else {
                text = "Error: Status Code \(statusCode)"
            }
        }
        return [NSLocalizedDescriptionKey: text]
    }
    
    // Implementing Equatable conformance
    public static func == (lhs: APIServiceError, rhs: APIServiceError) -> Bool {
            switch (lhs, rhs) {
            case (.invalidURL, .invalidURL),
                 (.invalidResponseType, .invalidResponseType):
                return true
            case let (.httpStatusCodeFailed(lhsCode, lhsError), .httpStatusCodeFailed(rhsCode, rhsError)):
                return lhsCode == rhsCode && "\(lhsError)" == "\(rhsError)"
            default:
                return false
            }
        }
}
