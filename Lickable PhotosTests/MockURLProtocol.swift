//
//  MockURLProtocol.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import XCTest

class MockURLProtocol: URLProtocol {
	
	static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?
	
	override class func canInit(with request: URLRequest) -> Bool {
		return true
	}
	
	override class func canonicalRequest(for request: URLRequest) -> URLRequest {
		return request
	}
	
	override func startLoading() {
		
		guard let handler = MockURLProtocol.requestHandler else {
			XCTFail("Received unexpected request with no handler set. Handler must be set")
			return
		}
		
		do {
			let (response, data) = try handler(request)
			client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
			client?.urlProtocol(self, didLoad: data)
			client?.urlProtocolDidFinishLoading(self)
			
		} catch {
			client?.urlProtocol(self, didFailWithError: error)
		}
	}
	
	override func stopLoading() {
		
	}
}
