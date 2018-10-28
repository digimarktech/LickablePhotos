//
//  PhotoVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit
import SDWebImage

final class PhotoVC: UIViewController {
	
	//Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	
	//Data Properties
	private var photos = [Photo]()
	
	//Cell Properties
	private let photoCellReuseIdentifier = "PhotoCell"
	
	//Layout Properties
	private let inset: CGFloat = 10
	private let minimumLineSpacing: CGFloat = 10
	private let minimumInteritemSpacing: CGFloat = 10
	private let cellsPerRow = 3
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let layout = UICollectionViewFlowLayout()
		collectionView.collectionViewLayout = layout
		collectionView.delegate = self
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
			guard let photoDetailVC = segue.destination as? PhotoDetailVC else { return }
			let indexPath = collectionView.indexPathsForSelectedItems?.first
			let photo = photos[(indexPath?.row)!]
			photoDetailVC.photo = photo
		}
	}
}

//MARK: - UICollectionViewDelegateFlowLayout
extension PhotoVC: UICollectionViewDelegateFlowLayout {
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
		return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
		return minimumInteritemSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
		return minimumLineSpacing
	}
	
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
		let marginsAndInsets = inset * 2 + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
		let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
		return CGSize(width: itemWidth, height: itemWidth)
	}
}

//MARK: - UICollectionViewDataSource
extension PhotoVC: UICollectionViewDataSource {
	
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

