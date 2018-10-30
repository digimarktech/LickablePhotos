//
//  PhotoVCTests.swift
//  Lickable PhotosTests
//
//  Created by Marc Aupont on 10/27/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import XCTest
@testable import Lickable_Photos

class PhotoVCTests: XCTestCase {
	
	var photoVC: PhotoVC!

    override func setUp() {
		
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoVC") as? PhotoVC
		
		//call view did load from the PhotoVC
		_ = photoVC.view
    }

	func testInitCollectionView() {
		
		XCTAssertNotNil(photoVC.collectionView)
	}
	
	func testLoadViewSetsCollectionViewDataSource() {
		
		XCTAssertTrue(photoVC.collectionView.dataSource is PhotoVCDataSource)
	}
	
	func testRefreshControlSpinnerIsClear() {
		
		XCTAssertTrue(photoVC.refreshControl.backgroundColor == .clear, "Refresh Control background color should be clear so that default spinner does not show up")
		XCTAssertTrue(photoVC.refreshControl.tintColor == .clear, "Refresh Control tint color should be clear so that default spinner does not show up")
	}
	
	func testCustomRefreshViewCanBeAnchoredViaAutoLayout() {
		
		XCTAssertFalse(photoVC.customRefreshView.translatesAutoresizingMaskIntoConstraints, "This property needs to be set to false in order to activate autolayout")
	}

}
