//
//  PageModel.swift
//  Midpoint
//
//  Created by Charlie on 11/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class PageContainer {

	let view: PageTileView
	var leading: NSLayoutConstraint
	var top: NSLayoutConstraint
	var bottom: NSLayoutConstraint
	var width: NSLayoutConstraint
	var height: NSLayoutConstraint
	var trailing: NSLayoutConstraint
	
	var frozen: Bool = false
	
	private var frozenleading: NSLayoutConstraint = NSLayoutConstraint()
	private var frozentrailing: NSLayoutConstraint = NSLayoutConstraint()
	
	var constraints: Array<NSLayoutConstraint> {
	
		get {
			return [leading, top, trailing, bottom, width, height]
		}
	
	}
	
	init(view: PageTileView, leading: NSLayoutConstraint, top: NSLayoutConstraint, trailing: NSLayoutConstraint?, bottom: NSLayoutConstraint, width: NSLayoutConstraint, height: NSLayoutConstraint)  {
		
		self.view = view
		self.leading = leading
		self.top = top
		self.bottom = bottom
		self.width = width
		self.height = height
		self.trailing = trailing ?? NSLayoutConstraint()
	
	}
	
	func update(constraint: PageConstraint, update: NSLayoutConstraint? = nil, scroll: PageScrollView) {
	
		var target: NSLayoutConstraint
	
		switch constraint {
		
			case .leading:
			target = leading
			
			case .trailing:
			target = trailing
			
			case .width:
			target = width
			
			case .frozenleading:
			target = frozenleading
			
			case .frozentrailing:
			target = frozentrailing
			
			default: return
		
		}
		
		scroll.removeConstraint(target)
		
		guard let safeupdate = update else { return }
		
		switch constraint {
		
			case .leading:
			self.leading = safeupdate
			
			case .trailing:
			self.trailing = safeupdate
			
			case .width:
			self.width = safeupdate
			
			case .frozenleading:
			self.frozenleading = safeupdate
			
			case .frozentrailing:
			self.frozentrailing = safeupdate
			
			default: return
		
		}
		
		scroll.addConstraint(safeupdate)
	
	}
	
	func freeze(scroll: PageScrollView, padding: CGFloat) {
	
		frozen = true
		
		update(constraint: .leading, scroll: scroll)
		update(constraint: .trailing, scroll: scroll)
		
		update(constraint: .frozenleading, update: NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: scroll, attribute: .leading, multiplier: 1.0, constant: 0), scroll: scroll)
		update(constraint: .frozentrailing, update: NSLayoutConstraint(item: scroll, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: padding), scroll: scroll)
	
	}
	
	func thaw(scroll: PageScrollView) {
	
		frozen = false
		
		update(constraint: .frozenleading, scroll: scroll)
		update(constraint: .frozentrailing, scroll: scroll)
		
		update(constraint: .leading, update: leading, scroll: scroll)
		update(constraint: .trailing, update: trailing, scroll: scroll)
		
	}
	
}

enum PageConstraint {
	case leading, trailing, top, bottom, width, height, frozenleading, frozentrailing
}

enum PageState {
	case scroll, frozen, focussed
}

enum PageTileState {
	case empty, editing, set
}

enum PageButtonAction {
	case confirm, cancel, edit, delete//, empty
}
