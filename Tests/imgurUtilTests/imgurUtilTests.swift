import XCTest
@testable import imgurUtil

final class imgurUtilTests: XCTestCase {
    
    // MARK: - Test Properties
    let imgurUtil = ImgurUtil(clientID: "")
    
    func test_FetchGalleryData(){
        let expectation = self.expectation(description: "API Call Expectation")
        Task {
            do {
                let data = try await imgurUtil.searchImages(query: "cat")
                XCTAssertNotNil(data, "requested data shouldn;t be nil")
                XCTAssertFalse(data.isEmpty, "response is nil")
                expectation.fulfill()
            } catch {
                print(error)
                XCTFail("API call failed with error: \(error)")
            }
            
        }
        wait(for: [expectation], timeout: 20.0)
    }
}
