//
//  OverlayView.swift
//  Midpoint
//
//  Created by Charlie on 28/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import TileKit

class OverlayView: UIView {

	var overlayView = UIView()
	var dragView = DragView()
	var titleView = TitleView()
	var pageView = TKMainView(visible: 1, aspect: TKTileAspect(width: 1.0, height: 0.65))
	
	private var overlayOffset: CGFloat = 200
	let overlayBottom: CGFloat = 140
	let overlayMiddle: CGFloat = 340
	let overlayTop: CGFloat = UIScreen.main.bounds.height - 110
	
	var overlayPadding: CGFloat = 100
	
	private var handlePanGesture = UIPanGestureRecognizer()
	private var handleTapGesture = UILongPressGestureRecognizer()
	private var titleTapGesture = UILongPressGestureRecognizer()
	
	var delegate: OverlayDelegate? = nil

	init() {
		super.init(frame: CGRect.zero)
		
		overlayView.backgroundColor = UIColour.white
		overlayView.layer.cornerRadius = 30
		overlayView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
		overlayView.layer.shadowColor = UIColour.black.cgColor
		overlayView.layer.shadowOpacity = 0.3
		overlayView.layer.shadowOffset = .zero
		overlayView.layer.shadowRadius = 5
		
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		dragView.translatesAutoresizingMaskIntoConstraints = false
		titleView.translatesAutoresizingMaskIntoConstraints = false
		pageView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(overlayView)
		self.addSubview(dragView)
		self.addSubview(titleView)
		self.addSubview(pageView)
		
		self.addConstraints([
		
			// Overlay View
			NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: overlayView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .bottom, multiplier: 1.0, constant: 0),
		
			// Drag View
			NSLayoutConstraint(item: dragView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: dragView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: dragView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: dragView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 52),
			
			// Title View
			NSLayoutConstraint(item: titleView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: titleView, attribute: .top, relatedBy: .equal, toItem: dragView, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: titleView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: titleView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50),
			
			// Page View
			NSLayoutConstraint(item: pageView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pageView, attribute: .top, relatedBy: .equal, toItem: titleView, attribute: .bottom, multiplier: 1.0, constant: 40),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: pageView, attribute: .trailing, multiplier: 1.0, constant: 0)
		
		])
		
		handlePanGesture = UIPanGestureRecognizer(target: self, action: #selector(dragOverlay(sender:)))
		handleTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(dragOverlay(sender:)))
		titleTapGesture = UILongPressGestureRecognizer(target: self, action: #selector(tapTitle(sender:)))
		
		handleTapGesture.minimumPressDuration = 0.0
		titleTapGesture.minimumPressDuration = 0.0
	
		handleTapGesture.delegate = self
		handlePanGesture.delegate = self
	
		dragView.addGestureRecognizer(handleTapGesture)
		dragView.addGestureRecognizer(handlePanGesture)
		titleView.addGestureRecognizer(titleTapGesture)
		
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	deinit {
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
	}

}

extension OverlayView: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}
	
}

//extension OverlayView: TitleDelegate {
//	
//	func blurTitle() {
//		let titleGestures = titleView.gestureRecognizers ?? []
//		if titleGestures.contains(titleTapGesture) { return }
//		titleView.addGestureRecognizer(titleTapGesture)
//	}
//	
//}

extension OverlayView {

	@objc private func dragOverlay(sender: UIGestureRecognizer) {
	
		if let gesture = sender as? UILongPressGestureRecognizer {
		
			if gesture.state == .began {
			
				if titleView.isTextFocused {
				
					titleView.textField.resignFirstResponder()
					titleView.textField.isUserInteractionEnabled = false
					titleView.addGestureRecognizer(titleTapGesture)
					
				}
			
				UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, options: .curveLinear, animations: { [weak self] in
					guard let safe = self else { return }
					safe.dragView.dragHandle.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
					safe.dragView.dragHandle.alpha = 0.8
				})
				
			} else if gesture.state == .ended {
			
				UIView.animate(withDuration: 0.15, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, options: .curveLinear, animations: { [weak self] in
					guard let safe = self else { return }
					safe.dragView.dragHandle.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
					safe.dragView.dragHandle.alpha = 1.0
				})
			
			}
			
		} else if let gesture = sender as? UIPanGestureRecognizer {
			
			if gesture.state == .began, let safeOffset = delegate?.getInitialOffset() {
				overlayOffset = safeOffset
			}
			
			if gesture.state == .began || gesture.state == .changed {
				delegate?.didUpdateOverlayGesture(gesture: gesture, offset: overlayOffset, top: overlayTop, middle: overlayMiddle)
			} else if gesture.state == .ended || gesture.state == .cancelled {
				delegate?.didFinishOverlayGesture(gesture: gesture, offset: overlayOffset, top: overlayTop, middle: overlayMiddle, bottom: overlayBottom)
			}
			
		}
	
	}

	@objc private func tapTitle(sender: UIGestureRecognizer) {
	
		if sender.state == .began {
		
			UIView.animate(withDuration: 0.05, animations: { [weak self] in
				guard let safe = self else { return }
				safe.titleView.alpha = 0.8
				safe.titleView.transform = CGAffineTransform(scaleX: 0.96, y: 0.96)
			})
		
		} else if sender.state == .ended {
		
			UIView.animate(withDuration: 0.05, animations: { [weak self] in
				guard let safe = self else { return }
				safe.titleView.alpha = 1.0
				safe.titleView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
			})
			
//			titleView.textField.isUserInteractionEnabled = true
//			titleView.textField.becomeFirstResponder()
			
		}
	
	}

	@objc private func keyboardWillShow() {
		
		delegate?.updateOverlayPosition(position: overlayMiddle)
		
		if let titleGestures = titleView.gestureRecognizers, titleGestures.contains(titleTapGesture) {
			titleView.removeGestureRecognizer(titleTapGesture)
		}
	
	}

}
