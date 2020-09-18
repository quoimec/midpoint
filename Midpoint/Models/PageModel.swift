//
//  PageModel.swift
//  Midpoint
//
//  Created by Charlie on 11/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import MapKit

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

struct PageTileMetaModel {

	var colour: UIColour
	var icon: String
	var letter: String
	var annotation: MKAnnotation?
	
	init(letter: String) {
		self.letter = letter
		
		switch letter {
		
			case "A":
			self.icon = "A-Button"
			self.colour = #colorLiteral(red: 0.81, green: 0.57, blue: 0.53, alpha: 1.0)
			
			case "B":
			self.icon = "B-Button"
			self.colour = #colorLiteral(red: 1.0, green: 0.42, blue: 0.73, alpha: 1.0)
			
			case "C":
			self.icon = "C-Button"
			self.colour = #colorLiteral(red: 0.37, green: 0.41, blue: 0.42, alpha: 1.0)
			
			case "D":
			self.icon = "D-Button"
			self.colour = #colorLiteral(red: 1.0, green: 0.25, blue: 0.63, alpha: 1.0)
			
			case "E":
			self.icon = "E-Button"
			self.colour = #colorLiteral(red: 0.64, green: 1.0, blue: 0.69, alpha: 1.0)
			
			case "F":
			self.icon = "F-Button"
			self.colour = #colorLiteral(red: 0.74, green: 1.0, blue: 0.44, alpha: 1.0)
			
			case "G":
			self.icon = "G-Button"
			self.colour = #colorLiteral(red: 0.3, green: 0.39, blue: 0.24, alpha: 1.0)
			
			case "H":
			self.icon = "H-Button"
			self.colour = #colorLiteral(red: 0.86, green: 0.32, blue: 0.96, alpha: 1.0)
			
			case "I":
			self.icon = "I-Button"
			self.colour = #colorLiteral(red: 1.0, green: 0.47, blue: 0.23, alpha: 1.0)
			
			case "J":
			self.icon = "J-Button"
			self.colour = #colorLiteral(red: 0.83, green: 0.24, blue: 0.96, alpha: 1.0)
			
			case "K":
			self.icon = "K-Button"
			self.colour = #colorLiteral(red: 0.38, green: 0.86, blue: 1.0, alpha: 1.0)
			
			case "L":
			self.icon = "L-Button"
			self.colour = #colorLiteral(red: 0.48, green: 0.82, blue: 0.24, alpha: 1.0)
			
			case "M":
			self.icon = "M-Button"
			self.colour = #colorLiteral(red: 0.48, green: 1.0, blue: 1.0, alpha: 1.0)
			
			case "N":
			self.icon = "N-Button"
			self.colour = #colorLiteral(red: 0.32, green: 1.0, blue: 0.48, alpha: 1.0)
			
			case "O":
			self.icon = "O-Button"
			self.colour = #colorLiteral(red: 0.48, green: 0.86, blue: 0.67, alpha: 1.0)
			
			case "P":
			self.icon = "P-Button"
			self.colour = #colorLiteral(red: 0.29, green: 0.91, blue: 0.84, alpha: 1.0)
			
			case "Q":
			self.icon = "Q-Button"
			self.colour = #colorLiteral(red: 0.7, green: 0.25, blue: 0.73, alpha: 1.0)
			
			case "R":
			self.icon = "R-Button"
			self.colour = #colorLiteral(red: 0.49, green: 0.21, blue: 1.0, alpha: 1.0)
			
			case "S":
			self.icon = "S-Button"
			self.colour = #colorLiteral(red: 1.0, green: 1.0, blue: 0.65, alpha: 1.0)
			
			case "T":
			self.icon = "T-Button"
			self.colour = #colorLiteral(red: 1.0, green: 0.23, blue: 0.43, alpha: 1.0)
			
			case "U":
			self.icon = "U-Button"
			self.colour = #colorLiteral(red: 1.0, green: 1.0, blue: 0.24, alpha: 1.0)
			
			case "V":
			self.icon = "V-Button"
			self.colour = #colorLiteral(red: 0.24, green: 0.97, blue: 0.34, alpha: 1.0)
			
			case "W":
			self.icon = "W-Button"
			self.colour = #colorLiteral(red: 1.0, green: 1.0, blue: 0.46, alpha: 1.0)
			
			case "X":
			self.icon = "X-Button"
			self.colour = #colorLiteral(red: 0.75, green: 0.65, blue: 0.74, alpha: 1.0)
			
			case "Y":
			self.icon = "Y-Button"
			self.colour = #colorLiteral(red: 0.92, green: 0.75, blue: 0.37, alpha: 1.0)
			
			case "Z":
			self.icon = "Z-Button"
			self.colour = #colorLiteral(red: 0.41, green: 0.5, blue: 0.9, alpha: 1.0)
			
			default:
			self.icon = ""
			self.colour = UIColor.black
			
		}
		
	}

	mutating func updateAnnotation(new: MKAnnotation) {
		self.annotation = new
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
