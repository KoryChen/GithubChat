//
//  ImageCacheTests.swift
//  GitHubDMTests
//
//  Created by Kory on 2020/3/12.
//  Copyright © 2020 CHIHYEN. All rights reserved.
//

import XCTest
@testable import GitHubDM

class ImageCacheTests: XCTestCase {
    class ImageMockSession: URLSession {
        static let mockData = UIImage(named: "left_bubble")?.pngData()
        enum MockType {
            case success
            case error
            case noData
        }
        
        var type: MockType = .success
        convenience init(type: MockType) {
            self.init()
            self.type = type
        }
        
        override init() {
        }
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            switch type {
            case .success:
                completionHandler(ImageMockSession.mockData, nil, nil)
            case .error:
                completionHandler(nil, nil, APIError.nilData)
            case .noData:
                completionHandler(nil,nil,nil)
            }
            return MockURLSessionDataTask()
        }
    }
    
    func testDownloadImage() {
        let httpClint = HTTPClient(session: ImageMockSession())
        let imageCache = ImageCache(client: httpClint)
        imageCache.downloadImage(with: URL(string: "https://download1.com")!) { (result) in
            switch result {
            case .success(let image):
                XCTAssertNotNil(image)
            case .failure(_):
                XCTAssert(false)
            }
        }
    }
    
    func testDownloadImageNoData() {
        let httpClint = HTTPClient(session: ImageMockSession(type: .noData))
        let imageCache = ImageCache(client: httpClint)
        imageCache.downloadImage(with: URL(string: "https://download1.com")!) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }
    }
    
    func testDownloadImageError() {
        let httpClint = HTTPClient(session: ImageMockSession(type: .noData))
        let imageCache = ImageCache(client: httpClint)
        imageCache.downloadImage(with: URL(string: "https://download2.com")!) { (result) in
            switch result {
            case .success(_):
                XCTAssert(false)
            case .failure(let error):
                XCTAssertTrue(error is APIError)
            }
        }
    }
    
    func testRetrieveCacheImage() {
        let httpClint = HTTPClient(session: ImageMockSession())
        let imageCache = ImageCache(client: httpClint)
        let image = UIImage(data: ImageMockSession.mockData!)!
        let url = URL(string: "https://cacheImage.com")!
        imageCache.saveImage(image, for: url)
        XCTAssertNotNil(imageCache.cachedImage(for: url))
    }
}
