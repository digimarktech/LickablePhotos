//
//  APIRequestLoaderTests.swift
//  Lickable PhotosTests
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import XCTest
@testable import Lickable_Photos

class APIRequestLoaderTests: XCTestCase {
	
	var loader: APIRequestLoader<PhotoRequest>!

    override func setUp() {
		
		let request = PhotoRequest()
		
		let configuration = URLSessionConfiguration.ephemeral
		configuration.protocolClasses = [MockURLProtocol.self]
		let urlSession = URLSession(configuration: configuration)
		
		loader = APIRequestLoader(apiRequest: request, urlSession: urlSession)
    }
	
	func testAPILoaderSuccess() {
		
		let jsonString = "[{\"albumId\":1,\"id\":1,\"title\":\"Some test title\",\"url\":\"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\":\"https://via.placeholder.com/150/92c952\"}]"
		let data = jsonString.data(using: .utf8)!
		
		MockURLProtocol.requestHandler = { request in
			XCTAssertEqual(request.url?.host, "jsonplaceholder.typicode.com")
			return (HTTPURLResponse(), data)
		}
		
		let expectation = XCTestExpectation(description: "response")
		loader.loadAPIRequest { photos, error in
			XCTAssertEqual(photos?.first?.albumId, 1)
			expectation.fulfill()
		}
		wait(for: [expectation], timeout: 5)
	}

}
