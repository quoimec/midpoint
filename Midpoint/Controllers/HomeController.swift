//
//  MapController.swift
//  Midpoint
//
//  Created by Charlie on 26/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class HomeController: UIViewController {

	let tabView = TabView(tabs: ["A", "B", "C"])

	let mapView = MapView()
	let overlayView = OverlayView()

	var tabTop = NSLayoutConstraint()
	var overlayTop = NSLayoutConstraint()
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.mapView.delegate = self
		overlayView.delegate = self
		overlayView.pageView.homeDelegate = self
		overlayView.pageView.mapDelegate = mapView
		
		mapView.mapView.camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: -33.90, longitude: 151.14), fromDistance: CLLocationDistance(15000.0), pitch: 0.0, heading: CLLocationDirection(0.0))
		
		tabView.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(mapView)
		self.view.addSubview(tabView)
		self.view.addSubview(overlayView)
		
		tabTop = NSLayoutConstraint(item: tabView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: tabView.tapTopConstant)
		overlayTop = NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: overlayView, attribute: .top, multiplier: 1.0, constant: 0)
		
		self.view.addConstraints([
			
			// Map View
			NSLayoutConstraint(item: mapView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: mapView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: mapView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self.view!, attribute: .bottom, relatedBy: .equal, toItem: mapView, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Tab View
			NSLayoutConstraint(item: tabView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 20),
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: tabView, attribute: .trailing, multiplier: 1.0, constant: 20),
			tabTop,
			
			// Overlay View
			NSLayoutConstraint(item: overlayView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 0),
			overlayTop,
			NSLayoutConstraint(item: self.view!, attribute: .trailing, relatedBy: .equal, toItem: overlayView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: overlayView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
			
		])
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		
		overlayView.pageView.addPage(index: 0)
		
		UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, options: .curveLinear, animations: { [weak self] in
			guard let safe = self else { return }
			safe.overlayTop.constant = safe.overlayView.overlayBottom
			safe.view.layoutIfNeeded()
		})
		
//		mapView.mapView.addAnnotation(MKPlacemark(coordinate: mapView.relativeCenter(middle: true)))

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension HomeController: OverlayDelegate {
	
	func didUpdateOverlayGesture(gesture: UIPanGestureRecognizer, offset: CGFloat, top: CGFloat, middle: CGFloat) {
		
		let topConstant = offset - gesture.translation(in: self.view).y
		overlayTop.constant = topConstant
		
		if topConstant > top {
			tabTop.constant = tabView.tapTopConstant - (topConstant - top)
			tabView.alpha = 1.0 - (((topConstant / top) - 1.0) * 2)
		} else {
			tabTop.constant = tabView.tapTopConstant
			tabView.alpha = 1.0
		}
		
		if topConstant >= middle {
			mapView.blurView.alpha = (topConstant - middle) / ((top - middle) * 2)
		}
		
	}
	
	func didFinishOverlayGesture(gesture: UIPanGestureRecognizer, offset: CGFloat, top: CGFloat, middle: CGFloat, bottom: CGFloat) {
		
		let buffer: CGFloat = 40
		var mapBlur: CGFloat

		switch (abs(overlayTop.constant), gesture.velocity(in: self.view).y < 0.0) {

			case (-CGFloat.infinity ..< bottom + buffer, true), (-CGFloat.infinity ..< middle - buffer, false):
			overlayTop.constant = bottom
			mapBlur = 0.0
			
			case (bottom + buffer ..< middle + buffer, true), (middle - buffer ..< top - buffer, false):
			overlayTop.constant = middle
			mapBlur = 0.0
			
			case (middle + buffer ... CGFloat.infinity, true), (top - buffer ... CGFloat.infinity, false):
			overlayTop.constant = top
			mapBlur = 0.5
			
			default:
			fatalError("Failed to switch")

		}
		
		tabTop.constant = tabView.tapTopConstant
		
		UIView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, options: .curveLinear, animations: { [weak self] in
			guard let safe = self else { return }
			safe.tabView.alpha = 1.0
			safe.mapView.blurView.alpha = mapBlur
			safe.view.layoutIfNeeded()
		})
		
	}
	
	func getInitialOffset() -> CGFloat {
		return overlayTop.constant
	}
	
	func updateOverlayPosition(position: CGFloat) {

		overlayTop.constant = position
		
		UIView.animate(withDuration: 0.3, delay: 0.0, animations: { [weak self] in
			guard let safe = self else { return }
			safe.view.layoutIfNeeded()
			safe.mapView.blurView.alpha = 0.0
		})
		
	}
	
}

extension HomeController: HomeDelegate {

	func resampleLocation() {
		overlayView.pageView.updateCoordinates(coordinate: mapView.mapView.centerCoordinate)
		overlayView.pageView.updateLocation(location: CLLocation(latitude: mapView.mapView.centerCoordinate.latitude, longitude: mapView.mapView.centerCoordinate.longitude), altitude: mapView.mapView.camera.altitude / 300000)
	}
	
	func calculateMidpoint() {
	
		
	
	
	}

}

extension HomeController: MKMapViewDelegate {

	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
		overlayView.pageView.updateCoordinates(coordinate: self.mapView.relativeCenter(middle: false))
	}

	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
	
		let relative = self.mapView.relativeCenter(middle: false)
	
		overlayView.pageView.updateLocation(location: CLLocation(latitude: relative.latitude, longitude: relative.longitude), altitude: mapView.camera.altitude / 300000)
		
	}
	
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		let reuse = "MapPin"

		let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: reuse) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: reuse)
		
		annotation.image = self.mapView.pinView.image
		
		return annotation
	
	}

}
