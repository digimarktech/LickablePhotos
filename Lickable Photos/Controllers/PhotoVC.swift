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
	@IBOutlet weak var dataSource: PhotoVCDataSource!
	
	//Layout Properties
	private let inset: CGFloat = 10
	private let minimumLineSpacing: CGFloat = 10
	private let minimumInteritemSpacing: CGFloat = 10
	private let cellsPerRow = 3
	
	//UIRefreshControl
	var refreshControl :UIRefreshControl = {
		
		let rc = UIRefreshControl()
		rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		return rc
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let layout = UICollectionViewFlowLayout()
		collectionView.collectionViewLayout = layout
		collectionView.delegate = self
		collectionView.dataSource = dataSource
		collectionView.refreshControl = refreshControl
		
		requestPhotos {
			//Update the UI when data fetching has completed
			self.updateUI()
		}
	}
	
	//MARK: Private Methods
	private func requestPhotos(completion: @escaping () -> ()) {
		let apiRequestLoader = APIRequestLoader(apiRequest: PhotoRequest())
		apiRequestLoader.loadAPIRequest { [weak self] photos, error in
			if let photos = photos {
				guard let self = self else { return }
				self.dataSource.photos = photos
				completion()
			}
		}
	}
	
	private func updateUI() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	@objc private func refreshData() {
		requestPhotos {
			self.updateUI()
			DispatchQueue.main.async {
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	//IBActions
	@IBAction func topButtonPressed(_ sender: UIBarButtonItem) {
		collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}
}

//MARK: UICollectionViewDelegate
extension PhotoVC: UICollectionViewDelegate {
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let photoDetailVC = storyBoard.instantiateViewController(withIdentifier: "PhotoDetailVC") as! PhotoDetailVC
		let photo = self.dataSource.photos[indexPath.row]
		photoDetailVC.photo = photo
		navigationController?.pushViewController(photoDetailVC, animated: true)
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

