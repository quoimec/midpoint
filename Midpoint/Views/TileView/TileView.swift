//
//  TileView.swift
//  Midpoint
//
//  Created by Charlie on 22/10/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import TileKit

class TileView: TKTileView {

	let locationContainer = UIView()
	let locationIcon = TileIconView()
	let locationTitle = UILabel()
	let locationAddress = UILabel()
	let locationCoordinates = UILabel()
	
	private var leadingOffset: CGFloat?
	let meta: PageTileMetaModel

	var content: TileContentState

	init(content: TileContentState, meta: PageTileMetaModel) {
		self.content = content
		self.meta = meta
		super.init()
		
		if content == .empty {
			locationTitle.text = "ADD LOCATION"
			locationCoordinates.text = "..."
		}
		
		backgroundColor = UIColour(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
		layer.cornerRadius = 30
		
		locationTitle.textColor = UIColour(red: 0.35, green: 0.35, blue: 0.35, alpha: 1.00)
		locationTitle.font = UIFont(descriptor: UIFont.systemFont(ofSize: 16, weight: .black).fontDescriptor.withDesign(.rounded)!, size: 16)
		
		locationAddress.numberOfLines = 3
		locationAddress.textColor = UIColour(red: 0.20, green: 0.20, blue: 0.20, alpha: 1.00)
		locationAddress.font = UIFont(descriptor: UIFont.systemFont(ofSize: 18, weight: .bold).fontDescriptor.withDesign(.rounded)!, size: 18)
		
		locationCoordinates.textColor = UIColour(red: 0.68, green: 0.70, blue: 0.76, alpha: 1.00)
		locationCoordinates.font = UIFont(descriptor: UIFont.systemFont(ofSize: 12, weight: .semibold).fontDescriptor.withDesign(.rounded)!, size: 12)
		
		locationIcon.update(content: content, meta: meta)
		
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
	
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateCoordinates(latitude: Double, longitude: Double) {
		locationCoordinates.text = "\(String(format:"%.4f", latitude))    \(String(format:"%.4f", longitude))"
	}

	override func didBeginPressTile() {
		locationContainer.transform = CGAffineTransform(scaleX: 0.97, y: 0.97)
		locationIcon.iconImage.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
	}

	override func didEndPressTile() {
		locationContainer.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
		locationIcon.iconImage.transform = CGAffineTransform(scaleX: 1.00, y: 1.00)
	}

}
