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
	
	func delete(scroll: PageScrollView) {
	
		scroll.removeConstraints([
			top,
			bottom,
			width,
			frozenleading,
			frozentrailing
		])
	
	}
	
}

struct PageTileMetaModel {

	var colour: UIColour
	var icon: String
	var letter: String
	var reuse: String
	var placemark: MKPlacemark?
	var image: UIImage?
	
	var x: Double = 0.0
	var y: Double = 0.0
	var z: Double = 0.0
	
	init(letter: String) {
		
		self.letter = letter
		self.reuse = "MapReuse-\(letter)"
		
		switch letter {
		
			case "A":
			self.icon = "A-Button"
			self.colour = #colorLiteral(red: 0.7140946062, green: 0.5025110192, blue: 0.467247088, alpha: 1)
			
			case "B":
			self.icon = "B-Button"
			self.colour = #colorLiteral(red: 0.8197773973, green: 0.3443065068, blue: 0.5984375, alpha: 1)
			
			case "C":
			self.icon = "C-Button"
			self.colour = #colorLiteral(red: 0.2468250571, green: 0.273508847, blue: 0.2801797945, alpha: 1)
			
			case "D":
			self.icon = "D-Button"
			self.colour = #colorLiteral(red: 0.8421714469, green: 0.2105428617, blue: 0.5305680116, alpha: 1)
			
			case "E":
			self.icon = "E-Button"
			self.colour = #colorLiteral(red: 0.5407191781, green: 0.8448737158, blue: 0.5829628639, alpha: 1)
			
			case "F":
			self.icon = "F-Button"
			self.colour = #colorLiteral(red: 0.6009134204, green: 0.8120451627, blue: 0.3572998716, alpha: 1)
			
			case "G":
			self.icon = "G-Button"
			self.colour = #colorLiteral(red: 0.1550768901, green: 0.2015999572, blue: 0.1240615121, alpha: 1)
			
			case "H":
			self.icon = "H-Button"
			self.colour = #colorLiteral(red: 0.701763275, green: 0.2611212186, blue: 0.7833636558, alpha: 1)
			
			case "I":
			self.icon = "I-Button"
			self.colour = #colorLiteral(red: 0.7822399401, green: 0.3676527718, blue: 0.1799151862, alpha: 1)
			
			case "J":
			self.icon = "J-Button"
			self.colour = #colorLiteral(red: 0.6399249072, green: 0.1850385274, blue: 0.7401541096, alpha: 1)
			
			case "K":
			self.icon = "K-Button"
			self.colour = #colorLiteral(red: 0.3048255565, green: 0.6898683647, blue: 0.8021725171, alpha: 1)
			
			case "L":
			self.icon = "L-Button"
			self.colour = #colorLiteral(red: 0.4019848396, green: 0.686724101, blue: 0.2009924198, alpha: 1)
			
			case "M":
			self.icon = "M-Button"
			self.colour = #colorLiteral(red: 0.3742166096, green: 0.7796179366, blue: 0.7796179366, alpha: 1)
			
			case "N":
			self.icon = "N-Button"
			self.colour = #colorLiteral(red: 0.2787585616, green: 0.8711205051, blue: 0.4181378425, alpha: 1)
			
			case "O":
			self.icon = "O-Button"
			self.colour = #colorLiteral(red: 0.4296700781, green: 0.7698255565, blue: 0.5997478173, alpha: 1)
			
			case "P":
			self.icon = "P-Button"
			self.colour = #colorLiteral(red: 0.2482535658, green: 0.7790025685, blue: 0.719079294, alpha: 1)
			
			case "Q":
			self.icon = "Q-Button"
			self.colour = #colorLiteral(red: 0.5737107689, green: 0.2048967032, blue: 0.5982983733, alpha: 1)
			
			case "R":
			self.icon = "R-Button"
			self.colour = #colorLiteral(red: 0.3971679688, green: 0.1702148437, blue: 0.810546875, alpha: 1)
			
			case "S":
			self.icon = "S-Button"
			self.colour = #colorLiteral(red: 0.7757116866, green: 0.7757116866, blue: 0.5042125963, alpha: 1)
			
			case "T":
			self.icon = "T-Button"
			self.colour = #colorLiteral(red: 0.7954034675, green: 0.1829427975, blue: 0.342023491, alpha: 1)
			
			case "U":
			self.icon = "U-Button"
			self.colour = #colorLiteral(red: 0.8311750856, green: 0.8311750856, blue: 0.1994820205, alpha: 1)
			
			case "V":
			self.icon = "V-Button"
			self.colour = #colorLiteral(red: 0.1932857294, green: 0.7811964897, blue: 0.27382145, alpha: 1)
			
			case "W":
			self.icon = "W-Button"
			self.colour = #colorLiteral(red: 0.7662938784, green: 0.7662938784, blue: 0.3524951841, alpha: 1)
			
			case "X":
			self.icon = "X-Button"
			self.colour = #colorLiteral(red: 0.5795697774, green: 0.5022938071, blue: 0.5718421804, alpha: 1)
			
			case "Y":
			self.icon = "Y-Button"
			self.colour = #colorLiteral(red: 0.7717786815, green: 0.6291674034, blue: 0.3103892523, alpha: 1)
			
			case "Z":
			self.icon = "Z-Button"
			self.colour = #colorLiteral(red: 0.3342560883, green: 0.407629376, blue: 0.7337328767, alpha: 1)
			
			default:
			self.icon = ""
			self.colour = UIColor.black
			
		}
		
	}
	
	mutating func updateImage(new: UIImage?) {
		self.image = new
	}

	mutating func updatePlacemark(new: MKPlacemark) {
	
		self.placemark = new
		
		// Convert new placemark into radians
		let latitude = new.coordinate.latitude.radians
		let longitude = new.coordinate.longitude.radians
		
		// Convert into global cartesian coordinates
		self.x = cos(latitude) * cos(longitude)
		self.y = cos(latitude) * sin(longitude)
		self.z = sin(latitude)
		
	}
	
	func checkCoordinate(coordinate: CLLocationCoordinate2D) -> Bool {
	
		if placemark == nil { return false }
	
		return placemark!.coordinate == coordinate
	
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
