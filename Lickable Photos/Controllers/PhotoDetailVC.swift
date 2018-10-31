//
//  PhotoDetailVC.swift
//  Lickable Photos
//
//  Created by Marc Aupont on 10/26/18.
//  Copyright © 2018 Marc Aupont. All rights reserved.
//

import UIKit

final class PhotoDetailVC: UIViewController {
	
	//IBOutlets
	@IBOutlet weak private var imageView: UIImageView!
	
	//Properties
	internal var photo: Photo?
	
    override func viewDidLoad() {
        super.viewDidLoad()
    }
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		guard let photo = self.photo else { return }
		imageView.sd_addActivityIndicator()
		imageView.sd_setImage(with: photo.url, placeholderImage: UIImage(named: "placeholder.png"), options: .highPriority)
	}

}
