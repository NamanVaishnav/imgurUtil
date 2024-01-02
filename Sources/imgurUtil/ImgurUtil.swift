// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation

public struct ImgurUtil {
    
    // MARK: - Constants
    static let baseURL = "https://api.imgur.com/3/"
    
    // MARK: - Properties
    private let clientID: String
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    // MARK: - Initialization
    public init(clientID: String) {
        self.clientID = clientID
    }
    
    // MARK: - Public Methods

    /// Searches for images on Imgur based on the provided query.
    /// - Parameter query: The search query.
    /// - Returns: An array of Gallery objects representing the search results.
    public func searchImages(query: String) async throws -> [Gallery] {
        guard let request = try requestForSearchImage(forQuery: query) else {
            throw APIServiceError.invalidURL
        }

        let (resp, statusCode): (GalleryRootModel, Int) = try await fetch(urlRequest: request)

        if let error = resp.error {
            throw APIServiceError.httpStatusCodeFailed(statusCode: statusCode, error: error)
        }

        let data = resp.data
        return data ?? []
    }

    // MARK: - Private Methods

    /// Constructs a URLRequest for searching images on Imgur.
    /// - Parameter query: The search query.
    /// - Returns: An optional URLRequest.
    private func requestForSearchImage(forQuery query: String = "") throws -> URLRequest? {
        guard let url = urlForSearchImages(query: query) else {
            throw APIServiceError.invalidURL
        }

        let method = "GET"
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.addValue(clientID, forHTTPHeaderField: "Authorization")
        return urlRequest
    }

    /// Constructs the URL for searching images on Imgur.
    /// - Parameter query: The search query.
    /// - Returns: An optional URL.
    private func urlForSearchImages(query: String) -> URL? {
        guard var urlComp = URLComponents(string: "\(ImgurUtil.baseURL)/gallery/search/top/week/1") else {
            return nil
        }

        urlComp.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        return urlComp.url
    }

    /// Fetches data from the specified URL request and decodes it.
    /// - Parameter urlRequest: The URLRequest.
    /// - Returns: A tuple containing the decoded data and the HTTP status code.
    private func fetch<D: Decodable>(urlRequest: URLRequest) async throws -> (D, Int) {
        let (data, response) = try await session.data(for: urlRequest)
        let statusCode = try validateHTTPResponse(response: response)
        return (try jsonDecoder.decode(D.self, from: data), statusCode)
    }

    /// Validates the HTTP response and returns the status code.
    /// - Parameter response: The URLResponse.
    /// - Returns: The HTTP status code.
    private func validateHTTPResponse(response: URLResponse) throws -> Int {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIServiceError.invalidResponseType
        }

        guard 200...299 ~= httpResponse.statusCode || 400...499 ~= httpResponse.statusCode else {
            throw APIServiceError.httpStatusCodeFailed(statusCode: httpResponse.statusCode, error: nil)
        }

        return httpResponse.statusCode
    }
}

