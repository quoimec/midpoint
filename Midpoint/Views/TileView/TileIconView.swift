//
//  TileIconView.swift
//  Midpoint
//
//  Created by Charlie on 24/10/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class TileIconView: UIView {

	let iconImage = UIImageView()
	
	init() {
		super.init(frame: CGRect.zero)
		
		self.layer.cornerRadius = 16
		
		iconImage.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(iconImage)
		
		self.addConstraints([
		
			// Icon Image
			NSLayoutConstraint(item: iconImage, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: iconImage, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: iconImage, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: iconImage, attribute: .bottom, multiplier: 1.0, constant: 0)
	
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func update(content: TileContentState, meta: PageTileMetaModel) {
	
		switch content {
		
			case .empty:
			iconImage.image = UIImage(named: "Add-Button")
			self.backgroundColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
		
			case .set, .editing:
			iconImage.image = UIImage(named: meta.icon)
			self.backgroundColor = meta.colour
		
		}
	
	}
	
	
	

}
