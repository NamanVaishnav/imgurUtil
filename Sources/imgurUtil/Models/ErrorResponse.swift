//
//  File.swift
//  
//
//  Created by Naman Vaishnav on 02/01/24.
//

import Foundation

// MARK: - ErrorResponse
public struct ErrorResponse: Codable {
    public let data: DataClass
    public let success: Bool
    public let status: Int
}

// MARK: - DataClass
public struct DataClass: Codable {
    public let error, request, method: String
}
