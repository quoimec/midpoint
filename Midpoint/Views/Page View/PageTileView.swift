//
//  PageTitleView.swift
//  Midpoint
//
//  Created by Charlie on 28/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class PageTileView: UIView {
	
	var state: PageTileState! {
		
		willSet (new) {
			willSetState(state: new)
		}
		
	}
	
	var index: Int? {
	
		get { return delegate?.getPageIndex(page: self) }
	
	}
	
	var letter: String

	let locationContainer = UIView()
	let locationIcon: PageIconView
	let locationTitle = UILabel()
	let locationAddress = UILabel()
	let locationCoordinates = UILabel()
	
	private var leadingOffset: CGFloat?
	
	private var tapGesture = UITapGestureRecognizer()
	private var pressGesture = UILongPressGestureRecognizer()
	
	weak var delegate: PageDelegate?
		
	init(state: PageTileState, letter: String) {
		self.locationIcon = PageIconView(state: state, letter: letter)
		self.letter = letter
		super.init(frame: CGRect.zero)
		self.willInitState(state: state)
		
		tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLocation(sender:)))
		pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didPressLocation(sender:)))

		tapGesture.delegate = self
		pressGesture.delegate = self
		pressGesture.minimumPressDuration = 0.0
		
		self.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
		self.layer.cornerRadius = 30
		
		locationTitle.textColor = UIColor(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00)
		locationTitle.font = UIFont(descriptor: UIFont.systemFont(ofSize: 16, weight: .black).fontDescriptor.withDesign(.rounded)!, size: 16)
		
		locationAddress.numberOfLines = 3
		locationAddress.textColor = UIColor(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
		locationAddress.font = UIFont(descriptor: UIFont.systemFont(ofSize: 18, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 18)
		
		locationCoordinates.textColor = UIColor(red: 0.68, green: 0.70, blue: 0.76, alpha: 1.00)
		locationCoordinates.font = UIFont(descriptor: UIFont.systemFont(ofSize: 12, weight: .semibold).fontDescriptor.withDesign(.rounded)!, size: 12)
		
		locationIcon.translatesAutoresizingMaskIntoConstraints = false
		locationTitle.translatesAutoresizingMaskIntoConstraints = false
		locationAddress.translatesAutoresizingMaskIntoConstraints = false
		locationCoordinates.translatesAutoresizingMaskIntoConstraints = false
		locationContainer.translatesAutoresizingMaskIntoConstraints = false
		
		locationContainer.addSubview(locationIcon)
		locationContainer.addSubview(locationTitle)
		locationContainer.addSubview(locationAddress)
		locationContainer.addSubview(locationCoordinates)
		self.addSubview(locationContainer)

		locationContainer.addConstraints([

			// Location Icon
			NSLayoutConstraint(item: locationIcon, attribute: .leading, relatedBy: .equal, toItem: locationContainer, attribute: .leading, multiplier: 1.0, constant: 18),
			NSLayoutConstraint(item: locationIcon, attribute: .top, relatedBy: .equal, toItem: locationContainer, attribute: .top, multiplier: 1.0, constant: 18),
			NSLayoutConstraint(item: locationIcon, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 34),
			NSLayoutConstraint(item: locationIcon, attribute: .height, relatedBy: .equal, toItem: locationIcon, attribute: .width, multiplier: 1.0, constant: 0),

			// Location Title
			NSLayoutConstraint(item: locationTitle, attribute: .leading, relatedBy: .equal, toItem: locationIcon, attribute: .trailing, multiplier: 1.0, constant: 12),
			NSLayoutConstraint(item: locationTitle, attribute: .centerY, relatedBy: .equal, toItem: locationIcon, attribute: .centerY, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: locationContainer, attribute: .trailing, relatedBy: .equal, toItem: locationTitle, attribute: .trailing, multiplier: 1.0, constant: 10),

			// Location Address
			NSLayoutConstraint(item: locationAddress, attribute: .leading, relatedBy: .equal, toItem: locationContainer, attribute: .leading, multiplier: 1.0, constant: 16),
			NSLayoutConstraint(item: locationContainer, attribute: .trailing, relatedBy: .equal, toItem: locationAddress, attribute: .trailing, multiplier: 1.0, constant: 16),

			// Location Coordinates
			NSLayoutConstraint(item: locationCoordinates, attribute: .leading, relatedBy: .equal, toItem: locationContainer, attribute: .leading, multiplier: 1.0, constant: 16),
			NSLayoutConstraint(item: locationCoordinates, attribute: .top, relatedBy: .equal, toItem: locationAddress, attribute: .bottom, multiplier: 1.0, constant: 6),
			NSLayoutConstraint(item: locationContainer, attribute: .trailing, relatedBy: .equal, toItem: locationCoordinates, attribute: .trailing, multiplier: 1.0, constant: 16),
			NSLayoutConstraint(item: locationContainer, attribute: .bottom, relatedBy: .equal, toItem: locationCoordinates, attribute: .bottom, multiplier: 1.0, constant: 26)

		])

		self.addConstraints([

			// Location Container
			NSLayoutConstraint(item: locationContainer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: locationContainer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: locationContainer, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: locationContainer, attribute: .bottom, multiplier: 1.0, constant: 0)

		])
	
		self.addGestureRecognizer(tapGesture)
		self.addGestureRecognizer(pressGesture)
	
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	@objc func didTapLocation(sender: UITapGestureRecognizer) {
		
		guard let index = self.index else { return }
		
		switch state {

			case .empty, .set:
			delegate?.freezePages(freeze: index)
			
			case .editing:
			return

			case .none:
			print("NONE")
		}

	}
	
	@objc func didPressLocation(sender: UILongPressGestureRecognizer) {
	
		var alpha: CGFloat
		var outside: CGFloat
		var inside: CGFloat
		var icon: CGFloat
	
		switch sender.state {
		
			case .began:
			alpha = 0.85
			outside = 0.96
			inside = 0.97
			icon = 0.9
			
			case .ended:
			alpha = 1.0
			outside = 1.0
			inside = 1.0
			icon = 1.0
			
			default:
			return
		
		}
		
		UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 1.2, initialSpringVelocity: 1.0, options: .curveEaseOut, animations: { [weak self] in
			guard let safe = self else { return }
			safe.alpha = alpha
			safe.transform = CGAffineTransform(scaleX: outside, y: outside)
			safe.locationContainer.transform = CGAffineTransform(scaleX: inside, y: inside)
			safe.locationIcon.iconImage.transform = CGAffineTransform(scaleX: icon, y: icon)
		}, completion: nil)

//		UIView.animate(withDuration: 0.1, delay: 0.0, options: .curveEaseOut, animations: { [weak self] in
//			guard let safe = self else { return }
//			safe.alpha = alpha
//			safe.transform = CGAffineTransform(scaleX: outside, y: outside)
//			safe.locationContainer.transform = CGAffineTransform(scaleX: inside, y: inside)
//		}, completion: nil)
		
	}
	
	func willSetState(state: PageTileState) {
	
		locationIcon.updateIcon(state: state, letter: self.letter)
	
		switch state {
		
			case .empty:
			locationTitle.text = "ADD LOCATION"
			locationAddress.text = nil
			locationCoordinates.text = "..."

			default: return

//			case .editing:
//			locationTitle.text = "MARRICKVILLE"
//			locationAddress.text = "19 - 21 Woodcourt Street"
//			locationCoordinates.text = "-33.906423    151.148072"
//
//			case .set:
//			locationTitle.text = "MARRICKVILLE"
//			locationAddress.text = "19 - 21 Woodcourt Street"
//			locationCoordinates.text = "-33.906423    151.148072"
			
		}
	
	}
	
	func willInitState(state: PageTileState) {
		self.state = state
	}

	func willLayoutViews(animate: Bool, offset: CGFloat) {
		if animate { self.leadingOffset = offset }
	}
	
	func updateCoordinates(latitude: Double, longitude: Double) {	
		locationCoordinates.text = "\(String(format:"%.6f", latitude))    \(String(format:"%.6f", longitude))"
	}
	
	func updateAddress(title: String, subtitle: String) {
		locationTitle.text = title.uppercased()
		locationAddress.text = subtitle
	}
	
}

extension PageTileView: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool { return true }

}
