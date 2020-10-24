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
	let pinView = MapPinView()
	let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

	var midpoint: MKPlacemark?

	init() {
		
		super.init(frame: CGRect.zero)
		
		blurView.isUserInteractionEnabled = false
		blurView.alpha = 0.0
		blurView.backgroundColor = UIColour(red: 0.00, green: 0.00, blue: 0.00, alpha: 1.0)
		
		pinView.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
		blurView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(mapView)
		self.addSubview(pinView)
		self.addSubview(blurView)
		
		self.addConstraints([
		
			// Map View
			NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: mapView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 0.75, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: mapView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: 1.5, constant: 0),
			
			// Pin View
			NSLayoutConstraint(item: pinView, attribute: .centerX, relatedBy: .equal, toItem: mapView, attribute: .centerX, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinView, attribute: .centerY, relatedBy: .equal, toItem: mapView, attribute: .centerY, multiplier: 1.0, constant: pinView.height / -2),
			
			// Blur View
			NSLayoutConstraint(item: blurView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: blurView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: blurView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: blurView, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
		pinView.alpha = 0.0
		pinView.lowerPin()
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension MapView: MapDelegate {

	func updatePin(meta: PageTileMetaModel) {
	
		pinView.updatePin(colour: meta.colour, icon: meta.icon)
	
	}
	
	func renderPin(meta: PageTileMetaModel) -> UIImage {
	
		return pinView.renderImage()
	
	}

	func hoverPin(meta: PageTileMetaModel) {
	
		if let annotation = meta.placemark {
		
			// If an annotation already exists
			pinView.alpha = 1.0
			mapView.removeAnnotation(annotation)
			
		}
	
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.2, options: .curveLinear, animations: { [weak self] in
		
			guard let safe = self else { return }
		
			safe.pinView.alpha = 1.0
			safe.pinView.raisePin()
		
		}, completion: nil)
	
	}
	
	func placePin(meta: PageTileMetaModel) {
	
		UIView.animate(withDuration: 0.2, animations: { [weak self] in
		
			guard let safe = self else { return }
			
			safe.pinView.lowerPin()
			
		}, completion: { [weak self] completed in
			
			guard let safe = self, let annotation = meta.placemark else { return }
			
			safe.mapView.addAnnotation(annotation)
			safe.pinView.alpha = 0.0
			
		})
		
	}
	
	func removePin(meta: PageTileMetaModel) {
	
		pinView.alpha = 0.0
		pinView.lowerPin()
	
		guard let annotation = meta.placemark else { return }
		
		mapView.addAnnotation(annotation)
	
	}
	
	func replacePin(meta: PageTileMetaModel) {
		
		pinView.alpha = 0.0
		
		guard let annotation = meta.placemark else { return }
		
		mapView.addAnnotation(annotation)
	
	}
	
	func moveCamera(location: CLLocationCoordinate2D, animated: Bool = false) {
	
		// TODO:
		// Converted passed coordinate to correct center area for pin
	
		mapView.setCamera(MKMapCamera(lookingAtCenter: location, fromDistance: mapView.camera.altitude, pitch: 0.0, heading: CLLocationDirection(0.0)), animated: animated)
		
	}
	
	func relativeCenter(middle: Bool) -> CLLocationCoordinate2D {
	
		return mapView.centerCoordinate
	
//		let offset = middle ? 0.0 : (pinView.height / 2)
//
//		// Calculate the relative position of the pin view bottom tip
//		let bottom = CGPoint(x: pinView.center.x, y: pinView.center.y + offset)
//
//		return mapView.convert(bottom, toCoordinateFrom: mapView)
	
	}
	
}
