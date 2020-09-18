//
//  PageButtonView.swift
//  Midpoint
//
//  Created by Charlie on 12/3/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class PageButtonView: UIView {

	var action: PageButtonAction?

	private var symbolView = UIImageView()
	
	private var pressGesture = UILongPressGestureRecognizer()
	
	weak var pageDelegate: PageDelegate?
	weak var mapDelegate: MapDelegate?
	
	init(action: PageButtonAction? = nil) {
		self.action = action
		super.init(frame: CGRect.zero)
	
		self.isUserInteractionEnabled = true
		self.layer.cornerRadius = 30
	
		pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressLocation(sender:)))
		pressGesture.minimumPressDuration = 0.0

		symbolView.translatesAutoresizingMaskIntoConstraints = false

		self.addSubview(symbolView)
		
		self.addConstraints([
		
			// Button Icon
			NSLayoutConstraint(item: symbolView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 0.3, constant: 0),
			NSLayoutConstraint(item: symbolView, attribute: .width, relatedBy: .equal, toItem: symbolView, attribute: .height, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: symbolView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: symbolView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
		
		])
		
		self.addGestureRecognizer(pressGesture)
		
		if let safeaction = action {
			setAction(action: safeaction)
		}
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didPressLocation(sender: UILongPressGestureRecognizer) {
		
		var alpha: CGFloat
		var outside: CGFloat
		var inside: CGFloat
	
		switch sender.state {
		
			case .began:
			alpha = 0.85
			outside = 0.96
			inside = 0.85
			
			case .ended:
			alpha = 1.0
			outside = 1.0
			inside = 1.0
			
			default:
			return
		
		}
		
		UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { [weak self] in
			guard let safe = self else { return }
			safe.alpha = alpha
			safe.transform = CGAffineTransform(scaleX: outside, y: outside)
			safe.symbolView.transform = CGAffineTransform(scaleX: inside, y: inside)
		}, completion: nil)
		
		if sender.state == .ended {
			
			guard let frozen = pageDelegate?.getFrozenPage(), let coordinate = mapDelegate?.relativeCenter(middle: true) else { return }
			
			switch self.action {
			
				case .confirm:
				frozen.view.meta.updateAnnotation(new: MKPlacemark(coordinate: coordinate))
				frozen.view.state = .set
				mapDelegate?.placePin(meta: frozen.view.meta)
				
				case .cancel:
				frozen.view.state = .empty
				mapDelegate?.replacePin(meta: frozen.view.meta)
			
				default:
				break
			
			}
			
			pageDelegate?.thawPages()
			
			if pageDelegate?.getEmptyPage() == nil {
				pageDelegate?.addPage(index: 0, state: .empty, animate: true)
			}
			
		}
	
	}
	
	func setAction(action: PageButtonAction, animate: Bool = false) {
		
		self.action = action
		var symbolName: String
		
		switch action {
		
			case .confirm:
			symbolName = "checkmark"
			self.backgroundColor = UIColour(red: 0.35, green: 0.80, blue: 0.51, alpha: 1.00)
			
			case .cancel:
			symbolName = "xmark"
			self.backgroundColor = UIColour(red: 0.94, green: 0.79, blue: 0.37, alpha: 1.00)
			
			case .edit:
			symbolName = "pencil"
			self.backgroundColor = UIColour(red: 0.38, green: 0.59, blue: 0.86, alpha: 1.00)
			
			case .delete:
			symbolName = "trash"
			self.backgroundColor = UIColour(red: 0.88, green: 0.43, blue: 0.33, alpha: 1.00)
		
		}

		self.symbolView.image = UIImage(systemName: symbolName, withConfiguration: UIImage.SymbolConfiguration(weight: .black))?.withTintColor(UIColour.white, renderingMode: .alwaysOriginal)
	
	}
	
	func unsetAction() {
		
		self.action = nil
		self.symbolView.image = nil
		self.backgroundColor = nil
		
	}
	
}

extension PageButtonView: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true }
	
}
