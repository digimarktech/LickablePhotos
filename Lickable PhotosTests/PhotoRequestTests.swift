//
//  PhotoRequestTests.swift
//  Lickable PhotosTests
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import XCTest
@testable import Lickable_Photos

class PhotoRequestTests: XCTestCase {
	
	let request = PhotoRequest()

	func testMakingURLRequest() throws {
		
		let urlRequest = try request.makeRequest()
		
		XCTAssertEqual(urlRequest.url?.scheme, "http")
		XCTAssertEqual(urlRequest.url?.host, "jsonplaceholder.typicode.com")
		XCTAssertEqual(urlRequest.url?.path, "/photos")
	}
	
	func testParsingResponse() throws {
		
		let jsonString = "[{\"albumId\":1,\"id\":1,\"title\":\"Some test title\",\"url\":\"https://via.placeholder.com/600/92c952\",\"thumbnailUrl\":\"https://via.placeholder.com/150/92c952\"}]"
		let data = jsonString.data(using: .utf8)!
		let response = try request.parseResponse(data: data)
		
		XCTAssertNotNil(response)
		XCTAssertEqual(response.first?.albumId, 1)
		XCTAssertEqual(response.first?.id, 1)
		XCTAssertEqual(response.first?.title, "Some test title")
		XCTAssertEqual(response.first?.url, URL(string: "https://via.placeholder.com/600/92c952"))
		XCTAssertEqual(response.first?.thumbnailURL, URL(string: "https://via.placeholder.com/150/92c952"))
	}

}
