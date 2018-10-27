//
//  PhotoVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoVC: UIViewController {
	
	//Outlets
	@IBOutlet weak private var collectionView: UICollectionView!
	
	//Properties
	var photos = [Photo]()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		collectionView.dataSource = self
		
		let apiRequestLoader = APIRequestLoader(apiRequest: PhotoRequest())
		apiRequestLoader.loadAPIRequest { photos, error in
			if let photos = photos {
				self.photos = photos
				DispatchQueue.main.async {
					self.collectionView.reloadData()
				}
			}
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "showPhotoDetail" {
			guard let destinationVC = segue.destination as? PhotoDetailVC else { return }
			let path = collectionView.indexPathsForSelectedItems?.first
			let photo = photos[(path?.row)!]
			destinationVC.photo = photo
		}
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

