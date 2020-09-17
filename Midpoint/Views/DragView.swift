//
//  DragView.swift
//  Midpoint
//
//  Created by Charlie on 29/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class DragView: UIView {

	var dragHandle = UIView()
	
	init() {
		super.init(frame: CGRect.zero)
		
		dragHandle.layer.cornerRadius = 3
		dragHandle.backgroundColor = UIColor(red: 0.81, green: 0.81, blue: 0.81, alpha: 1.00)
		
		dragHandle.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(dragHandle)
		
		self.addConstraints([
			
			// Drag Handle
			NSLayoutConstraint(item: dragHandle, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: dragHandle, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 33),
			NSLayoutConstraint(item: dragHandle, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: dragHandle, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 7)
			
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
