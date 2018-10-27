//
//  ViewController.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()
		
		downloadPhotos()
	}
	
	func downloadPhotos() {
		
		guard let url = URL(string: "http://jsonplaceholder.typicode.com/photos/") else { return }
		let request = URLRequest(url: url)
		let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
			
			if error != nil {
				print(error?.localizedDescription ?? "")
			}
			guard let data = data else { return }
			let decoder = JSONDecoder()
			
			do {
				let photos = try decoder.decode([Photo].self, from: data)
				photos.forEach({ photo in
					print(photo.thumbnailURL)
				})
			} catch {
				print(error.localizedDescription)
			}
			
		}
		task.resume()
	}
}

