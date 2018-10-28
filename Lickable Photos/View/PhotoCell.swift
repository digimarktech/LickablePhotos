//
//  PhotoCell.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit
import SDWebImage

class PhotoCell: UICollectionViewCell {
	
	override func awakeFromNib() {
		self.layer.cornerRadius = 5
	}
	
	@IBOutlet weak var imageView: UIImageView!
	
	func configureCell(for photo: Photo) {
		imageView.sd_addActivityIndicator()
		imageView.sd_setImage(with: photo.thumbnailURL, placeholderImage: nil, options: .highPriority, completed: nil)
	}
}
