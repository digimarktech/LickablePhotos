//
//  Photo.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import Foundation

struct Photo: Decodable {
	
	let albumId: Int
	let id: Int
	let title: String
	let url: URL
	let thumbnailURL: URL
	
	private enum PhotoKeys: String, CodingKey {
		case albumId = "albumId"
		case id = "id"
		case title = "title"
		case url = "url"
		case thumbnailURL = "thumbnailUrl"
	}
	
	init(from decoder: Decoder) throws {
		
		let container = try decoder.container(keyedBy: PhotoKeys.self)
		albumId = try container.decode(Int.self, forKey: .albumId)
		id = try container.decode(Int.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		url = try container.decode(URL.self, forKey: .url)
		thumbnailURL = try container.decode(URL.self, forKey: .thumbnailURL)
	}
}
