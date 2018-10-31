//
//  PhotoVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit
import SDWebImage
import Lottie
import DZNEmptyDataSet

final class PhotoVC: UIViewController {
	
	//Outlets
	@IBOutlet weak var collectionView: UICollectionView!
	@IBOutlet weak var dataSource: PhotoVCDataSource!
	
	//Layout Properties
	private let inset: CGFloat = 10
	private let minimumLineSpacing: CGFloat = 10
	private let minimumInteritemSpacing: CGFloat = 10
	private let cellsPerRow = 3
	
	//State Management Properties
	private var isFetchingData: Bool = false
	private var isOffline: Bool = false
	
	private var activityIndicator: UIActivityIndicatorView = {
		let activity = UIActivityIndicatorView()
		activity.style = .whiteLarge
		activity.hidesWhenStopped = true
		activity.translatesAutoresizingMaskIntoConstraints = false
		activity.color = UIColor(red: 178/255, green: 19/255, blue: 35/255, alpha: 1)
		return activity
	}()
	
	//UIRefreshControl
	private(set) lazy var refreshControl: UIRefreshControl = {
		let rc = UIRefreshControl()
		rc.backgroundColor = .clear
		rc.tintColor = .clear
		rc.addTarget(self, action: #selector(refreshData), for: .valueChanged)
		return rc
	}()
	
	//Custom refresh view to be used with refresh control
	private(set) lazy var customRefreshView: LOTAnimationView = {
		let lotAnimationView = LOTAnimationView(name: "refresh")
		lotAnimationView.contentMode = .scaleAspectFit
		lotAnimationView.loopAnimation = true
		lotAnimationView.translatesAutoresizingMaskIntoConstraints = false
		return lotAnimationView
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let layout = UICollectionViewFlowLayout()
		collectionView.collectionViewLayout = layout
		collectionView.delegate = self
		collectionView.dataSource = dataSource
		collectionView.emptyDataSetSource = self
		collectionView.emptyDataSetDelegate = self
		collectionView.refreshControl = refreshControl
		
		//Setup constraints for ActivityIndicator
		view.addSubview(activityIndicator)
		NSLayoutConstraint.activate([
			activityIndicator.widthAnchor.constraint(equalToConstant: 45),
			activityIndicator.heightAnchor.constraint(equalToConstant: 45),
			activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
			activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
		])
		
		//Setup constraints for CustomRefreshView
		refreshControl.addSubview(customRefreshView)
		NSLayoutConstraint.activate([
			customRefreshView.widthAnchor.constraint(equalToConstant: 250),
			customRefreshView.heightAnchor.constraint(equalToConstant: 150),
			customRefreshView.centerYAnchor.constraint(equalTo: refreshControl.centerYAnchor),
			customRefreshView.centerXAnchor.constraint(equalTo: refreshControl.centerXAnchor)
		])
		
		requestData()
	}
	
	//MARK: Private Methods
	private func requestPhotos(completion: @escaping (Bool, NSError?) -> ()) {
		let apiRequestLoader = APIRequestLoader(apiRequest: PhotoRequest())
		apiRequestLoader.loadAPIRequest { [weak self] photos, error in
			if let error = error as NSError? {
				completion(false, error)
			}
			if let photos = photos {
				guard let self = self else { return }
				self.dataSource.photos = photos
				completion(true, nil)
			}
		}
	}
	
	private func updateUI() {
		DispatchQueue.main.async {
			self.collectionView.reloadData()
		}
	}
	
	//Method is used to request the photo data and refresh UI based on response
	private func requestData() {
		activityIndicator.startAnimating()
		requestPhotos { success, error in
			DispatchQueue.main.async {
				self.isFetchingData = false
				self.activityIndicator.stopAnimating()
				if success {
					//Update the UI when data fetching has completed
					self.updateUI()
				} else {
					if let error = error {
						if error.code == -1009 {
							//Internet is offline
							self.isOffline = true
							self.collectionView.reloadData()
						}
					}
				}
			}
		}
		isFetchingData = true
	}
	
	//Used specifically for pull to refresh
	@objc private func refreshData() {
		requestPhotos { success, error in
			self.updateUI()
			DispatchQueue.main.async {
				self.customRefreshView.stop()
				self.refreshControl.endRefreshing()
			}
		}
	}
	
	//IBActions
	//Used to scroll user to the top of the list
	@IBAction func topButtonPressed(_ sender: UIBarButtonItem) {
		collectionView.scrollToItem(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
	}
}

//MARK: UICollectionViewDelegate
extension PhotoVC: UICollectionViewDelegate {
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		//Offset is divided by 100 so we can have decimal between 0 and 1
		//Offset is also multiplied by -1 so we can work with positive value
		let offset = scrollView.contentOffset.y / 100 * -1
		if offset > 0.3 {
			customRefreshView.play()
		}
	}
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		
		let storyBoard = UIStoryboard(name: "Main", bundle: Bundle.main)
		guard let photoDetailVC = storyBoard.instantiateViewController(withIdentifier: "PhotoDetailVC") as? PhotoDetailVC else {
			fatalError("Developer Error! Could not cast as PhotoDetailVC")
		}
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

extension PhotoVC: DZNEmptyDataSetSource, DZNEmptyDataSetDelegate {
	
	func buttonTitle(forEmptyDataSet scrollView: UIScrollView!, for state: UIControl.State) -> NSAttributedString! {
		
		let attributedString = NSAttributedString(string: "Reload Data")
		return attributedString
	}
	
	func emptyDataSet(_ scrollView: UIScrollView!, didTap button: UIButton!) {
		requestData()
	}
	
	func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		var attributedString: NSAttributedString =  NSAttributedString(string: "Offline")
		if isOffline {
			attributedString = NSAttributedString(string: "Offline")
		} else {
			attributedString = NSAttributedString(string: "No Photos")
		}
		
		return attributedString
	}
	
	func description(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
		let attributedString: NSAttributedString
		if isOffline {
			attributedString = NSAttributedString(string: "Photos could not be downloaded. Please check your internet connection and try again")
		} else {
			attributedString = NSAttributedString(string: "There doesn't seem to be any photos at the moment.")
		}
		
		return attributedString
	}
	
	func emptyDataSetShouldFade(in scrollView: UIScrollView!) -> Bool {
		return true
	}
	
	func emptyDataSetShouldDisplay(_ scrollView: UIScrollView!) -> Bool {
		return isFetchingData ? false : true
	}
}

