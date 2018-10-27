//
//  PhotoVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
	
	var photos = [Photo]()
	@IBOutlet weak var collectionView: UICollectionView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.delegate = self
		collectionView.dataSource = self
		
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
				self.photos = try decoder.decode([Photo].self, from: data)
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
				
			} catch {
				print(error.localizedDescription)
			}
			
		}
		task.resume()
	}
}

extension PhotoVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("Selected cell at: \(indexPath.row)")
	}
}

extension PhotoVC: UICollectionViewDataSource {
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as? PhotoCell else {
			fatalError("Unable to dequeue cell")
		}
		
		let photo = self.photos[indexPath.row]
		
		cell.configureCell(for: photo)
		
		return cell
	}
}

