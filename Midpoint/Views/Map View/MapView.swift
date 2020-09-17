//
//  MapView.swift
//  Midpoint
//
//  Created by Charlie on 26/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapView: UIView {

	let mapView = MKMapView()
	let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

	init() {
		super.init(frame: CGRect.zero)
		
		blurView.isUserInteractionEnabled = false
		blurView.alpha = 0.0
		blurView.backgroundColor = UIColor(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)
		
		mapView.translatesAutoresizingMaskIntoConstraints = false
		blurView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(mapView)
		self.addSubview(blurView)
		
		self.addConstraints([
		
			// Map View
			NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Blur View
			NSLayoutConstraint(item: blurView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: blurView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: blurView, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
	
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}
