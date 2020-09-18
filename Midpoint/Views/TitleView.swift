//
//  MapTitle.swift
//  Midpoint
//
//  Created by Charlie on 2/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class TitleView: UIView {

	let textField = UITextField()
	
	var isTextFocused: Bool {
		get {
			return textField.isFirstResponder
		}
	}
	
	init() {
		super.init(frame: CGRect.zero)
		
		textField.keyboardType = .alphabet
		textField.returnKeyType = .done
		textField.autocorrectionType = .no
		textField.font = UIFont.systemFont(ofSize: 24, weight: .black)
		textField.textColor = UIColour(red: 0.15, green: 0.15, blue: 0.15, alpha: 1.00)
		textField.attributedPlaceholder = NSAttributedString(string: "Untitled Map", attributes: [NSAttributedString.Key.foregroundColor: UIColour(red: 0.86, green: 0.86, blue: 0.86, alpha: 1.00)])
		textField.isUserInteractionEnabled = false
		
		textField.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(textField)
		
		self.addConstraints([
		
			// Text Field
			NSLayoutConstraint(item: textField, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 24),
			NSLayoutConstraint(item: textField, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: textField, attribute: .trailing, multiplier: 1.0, constant: 24),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: textField, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

//	func blurText() {
//		textField.isUserInteractionEnabled = false
//		textField.resignFirstResponder()
//		delegate?.blurTitle()
//	}
	
}
