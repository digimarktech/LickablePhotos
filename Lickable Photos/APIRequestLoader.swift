//
//  APIRequestLoader.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import Foundation

protocol APIRequest {
	associatedtype ResponseDataType
	
	func makeRequest() throws -> URLRequest
	func parseResponse(data: Data) throws -> ResponseDataType
}

class APIRequestLoader<T: APIRequest> {
	
	let apiRequest: T
	let urlSession: URLSession
	
	init(apiRequest: T, urlSession: URLSession = .shared) {
		self.apiRequest = apiRequest
		self.urlSession = urlSession
	}
	
	func loadAPIRequest(completionHandler: @escaping (T.ResponseDataType?, Error?) -> Void) {
		
		do {
			let urlRequest = try apiRequest.makeRequest()
			urlSession.dataTask(with: urlRequest) { data, response, error in
				
				guard let data = data else { return completionHandler(nil, error) }
				
				do {
					
					let parsedResponse = try self.apiRequest.parseResponse(data: data)
					completionHandler(parsedResponse, nil)
					
				} catch {
					completionHandler(nil, error)
				}
				
			}.resume()
			
		} catch {
			completionHandler(nil, error)
		}
	}
}
