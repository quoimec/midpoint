//
//  AddressView.swift
//  Midpoint
//
//  Created by Charlie on 26/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class AddressView: UIView {

	let addressLabel = UILabel()
	let locationLabel = UILabel()
	let coordinateLabel = UILabel()
	
	init() {
		super.init(frame: CGRect.zero)
		
		addressLabel.font = UIFont.systemFont(ofSize: 19, weight: .medium)
		locationLabel.font = UIFont.monospacedSystemFont(ofSize: 15, weight: .heavy)
		coordinateLabel.font = UIFont.monospacedSystemFont(ofSize: 11, weight: .medium)
		
		addressLabel.translatesAutoresizingMaskIntoConstraints = false
		locationLabel.translatesAutoresizingMaskIntoConstraints = false
		coordinateLabel.translatesAutoresizingMaskIntoConstraints = false

		self.addSubview(addressLabel)
		self.addSubview(locationLabel)
		self.addSubview(coordinateLabel)

		self.addConstraints([
		
			// Address Label
			NSLayoutConstraint(item: addressLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: addressLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: addressLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Location Label
			NSLayoutConstraint(item: locationLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: locationLabel, attribute: .top, relatedBy: .equal, toItem: addressLabel, attribute: .bottom, multiplier: 1.0, constant: 4),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: locationLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
			
			// Coordinate Label
			NSLayoutConstraint(item: coordinateLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: coordinateLabel, attribute: .top, relatedBy: .equal, toItem: locationLabel, attribute: .bottom, multiplier: 1.0, constant: 10),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: coordinateLabel, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: coordinateLabel, attribute: .bottom, multiplier: 1.0, constant: 0)
			
		])

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updateCoordinates(map: MKMapView) {
		coordinateLabel.text = "\(String(format:"%.6f", map.centerCoordinate.latitude)), \(String(format:"%.6f", map.centerCoordinate.longitude))"
	}
	
	func updateAddress(placemark: CLPlacemark, altitude: Double) {
	
		if altitude <= 3.0 {
			addressLabel.text = placemark.name
			locationLabel.text = placemark.locality
		} else {
			addressLabel.text = placemark.administrativeArea
			locationLabel.text = placemark.country
		}

	}
	
}
