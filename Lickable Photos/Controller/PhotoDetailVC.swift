//
//  PhotoDetailVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit

final class PhotoDetailVC: UIViewController {
	
	internal var photo: Photo?
	@IBOutlet weak private var imageView: UIImageView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let photo = self.photo else { return }
		imageView.sd_setImage(with: photo.url, placeholderImage: nil, options: .highPriority)
	}

}
