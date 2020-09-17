//
//  PageIconView.swift
//  Midpoint
//
//  Created by Charlie on 27/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class PageIconView: UIView {

	let iconImage = UIImageView()
	
	init(state: PageTileState, letter: String) {
		super.init(frame: CGRect.zero)
		updateIcon(state: state, letter: letter)
		
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
	
	func updateIcon(state: PageTileState, letter: String) {
	
		var letterReference = [
			"A": ["icon": "A-Button", "colour": #colorLiteral(red: 0.81, green: 0.57, blue: 0.53, alpha: 1.0)],
			"B": ["icon": "B-Button", "colour": #colorLiteral(red: 1.0, green: 0.42, blue: 0.73, alpha: 1.0)],
			"C": ["icon": "C-Button", "colour": #colorLiteral(red: 0.37, green: 0.41, blue: 0.42, alpha: 1.0)],
			"D": ["icon": "D-Button", "colour": #colorLiteral(red: 1.0, green: 0.25, blue: 0.63, alpha: 1.0)],
			"E": ["icon": "E-Button", "colour": #colorLiteral(red: 0.64, green: 1.0, blue: 0.69, alpha: 1.0)],
			"F": ["icon": "F-Button", "colour": #colorLiteral(red: 0.74, green: 1.0, blue: 0.44, alpha: 1.0)],
			"G": ["icon": "G-Button", "colour": #colorLiteral(red: 0.3, green: 0.39, blue: 0.24, alpha: 1.0)],
			"H": ["icon": "H-Button", "colour": #colorLiteral(red: 0.86, green: 0.32, blue: 0.96, alpha: 1.0)],
			"I": ["icon": "I-Button", "colour": #colorLiteral(red: 1.0, green: 0.47, blue: 0.23, alpha: 1.0)],
			"J": ["icon": "J-Button", "colour": #colorLiteral(red: 0.83, green: 0.24, blue: 0.96, alpha: 1.0)],
			"K": ["icon": "K-Button", "colour": #colorLiteral(red: 0.38, green: 0.86, blue: 1.0, alpha: 1.0)],
			"L": ["icon": "L-Button", "colour": #colorLiteral(red: 0.48, green: 0.82, blue: 0.24, alpha: 1.0)],
			"M": ["icon": "M-Button", "colour": #colorLiteral(red: 0.48, green: 1.0, blue: 1.0, alpha: 1.0)],
			"N": ["icon": "N-Button", "colour": #colorLiteral(red: 0.32, green: 1.0, blue: 0.48, alpha: 1.0)],
			"O": ["icon": "O-Button", "colour": #colorLiteral(red: 0.48, green: 0.86, blue: 0.67, alpha: 1.0)],
			"P": ["icon": "P-Button", "colour": #colorLiteral(red: 0.29, green: 0.91, blue: 0.84, alpha: 1.0)],
			"Q": ["icon": "Q-Button", "colour": #colorLiteral(red: 0.7, green: 0.25, blue: 0.73, alpha: 1.0)],
			"R": ["icon": "R-Button", "colour": #colorLiteral(red: 0.49, green: 0.21, blue: 1.0, alpha: 1.0)],
			"S": ["icon": "S-Button", "colour": #colorLiteral(red: 1.0, green: 1.0, blue: 0.65, alpha: 1.0)],
			"T": ["icon": "T-Button", "colour": #colorLiteral(red: 1.0, green: 0.23, blue: 0.43, alpha: 1.0)],
			"U": ["icon": "U-Button", "colour": #colorLiteral(red: 1.0, green: 1.0, blue: 0.24, alpha: 1.0)],
			"V": ["icon": "V-Button", "colour": #colorLiteral(red: 0.24, green: 0.97, blue: 0.34, alpha: 1.0)],
			"W": ["icon": "W-Button", "colour": #colorLiteral(red: 1.0, green: 1.0, blue: 0.46, alpha: 1.0)],
			"X": ["icon": "X-Button", "colour": #colorLiteral(red: 0.75, green: 0.65, blue: 0.74, alpha: 1.0)],
			"Y": ["icon": "Y-Button", "colour": #colorLiteral(red: 0.92, green: 0.75, blue: 0.37, alpha: 1.0)],
			"Z": ["icon": "Z-Button", "colour": #colorLiteral(red: 0.41, green: 0.5, blue: 0.9, alpha: 1.0)]
		]
	
		switch state {
		
			case .empty:
			iconImage.image = UIImage(named: "Add-Button")
			self.backgroundColor = #colorLiteral(red: 0.80, green: 0.49, blue: 0.15, alpha: 1.00)
		
			case .set, .editing:
			iconImage.image = UIImage(named: letterReference[letter]?["icon"] as! String)
			self.backgroundColor = letterReference[letter]?["colour"] as? UIColor
		
		}
	
	}
	
	
	

}
