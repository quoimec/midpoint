//
//  ThroughView.swift
//  Midpoint
//
//  Created by Charlie on 13/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class PageThroughView: UIView {

	var upperButton = PageButtonView()
	var lowerButton = PageButtonView()

	var delegate: PageThroughDelegate?
	
	init(padding: CGFloat) {
		super.init(frame: CGRect.zero)
		
		upperButton.alpha = 0.0
		lowerButton.alpha = 0.0
		
		upperButton.translatesAutoresizingMaskIntoConstraints = false
		lowerButton.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(upperButton)
		self.addSubview(lowerButton)
		
		self.addConstraints([
		
			// Upper Button
			NSLayoutConstraint(item: upperButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: upperButton, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: upperButton, attribute: .trailing, multiplier: 1.0, constant: padding),
			NSLayoutConstraint(item: upperButton, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.5, constant: -padding * 0.5),
			
			// Lower Button
			NSLayoutConstraint(item: lowerButton, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: lowerButton, attribute: .top, relatedBy: .equal, toItem: upperButton, attribute: .bottom, multiplier: 1.0, constant: padding),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: lowerButton, attribute: .trailing, multiplier: 1.0, constant: padding),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: lowerButton, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
		
		guard let shouldHitTest = delegate?.shouldHitTest() else { return nil }
		
		if shouldHitTest && point.x >= 0 {
		
			if upperButton.frame.contains(point) {
				return upperButton
			} else if lowerButton.frame.contains(point) {
				return lowerButton
			} else {
				return self
			}
			
		} else {
			return delegate?.throughHitTest(point: point, event: event)
		}
		
	}
	
	func setButtons(upper: PageButtonAction, lower: PageButtonAction) {
	
		upperButton.setAction(action: upper)
		lowerButton.setAction(action: lower)
		
		UIView.animate(withDuration: 0.25, animations: { [weak self] in
			guard let safe = self else { return }
			safe.upperButton.alpha = 1.0
			safe.lowerButton.alpha = 1.0
		})
	
	}
	
	func unsetButtons() {
	
		UIView.animate(withDuration: 0.2, animations: { [weak self] in
			guard let safe = self else { return }
			safe.upperButton.alpha = 0.0
			safe.lowerButton.alpha = 0.0
		})
	
		upperButton.unsetAction()
		lowerButton.unsetAction()
		
	}
	
}
