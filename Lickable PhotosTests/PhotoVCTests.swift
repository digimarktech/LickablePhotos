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

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

	func testInitCollectionView() {
		
		let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
		let photoVC = storyboard.instantiateViewController(withIdentifier: "PhotoVC") as! PhotoVC
		
		//call view did load from the PhotoVC
		_ = photoVC.view
		
		XCTAssertNotNil(photoVC.collectionView)
	}

}
