//
//  PhotoVCDataSource.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/28/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit

class PhotoVCDataSource: NSObject, UICollectionViewDataSource {
	
	private let photoCellReuseIdentifier = "PhotoCell"
	var photos = [Photo]()
	
	func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return photos.count
	}
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: photoCellReuseIdentifier, for: indexPath) as? PhotoCell else {
			fatalError("Unable to dequeue cell")
		}
		
		let photo = self.photos[indexPath.row]
		cell.configureCell(for: photo)
		
		return cell
	}
}
