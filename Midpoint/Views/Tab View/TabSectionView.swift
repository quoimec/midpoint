//
//  TabSectionView.swift
//  Midpoint
//
//  Created by Charlie on 27/9/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class TabSectionView: UIImageView {

	var name: String? = nil

	func update(imageNamed new: String?) {
	
		/**
		#	Update Image
			A very simple function for updating the section image and tracking the name of the current image
			
		# 	Arguments
			imageNamed: String? - The name of the new image to load, if different from the previous image
		**/
	
		if new == name { return }
		
		name = new
		image = UIImage(named: new ?? "")
	
	}

}
