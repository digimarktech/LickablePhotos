//
//  PhotoRequest.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import Foundation

struct PhotoRequest: APIRequest {
	
	func makeRequest() throws -> URLRequest {
		let components = URLComponents(string: "http://jsonplaceholder.typicode.com/photos/")!
		return URLRequest(url: components.url!)
	}
	
	func parseResponse(data: Data) throws -> [Photo] {
		return try JSONDecoder().decode([Photo].self, from: data)
	}
}
