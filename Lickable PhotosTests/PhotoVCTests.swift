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

}
