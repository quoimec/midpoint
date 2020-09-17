//
//  ScrollView.swift
//  Midpoint
//
//  Created by Charlie on 17/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class PageScrollView: UIScrollView {

	var index: Int {
	
		get {
			return Int(floor((self.contentOffset.x / self.frame.width)))
		}
	
	}

	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		
		for page in self.subviews {
			if page.frame.contains(point) { return page }
		}
		
		return super.hitTest(point, with: event)
		
	}
	
}
