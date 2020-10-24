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
import TileKit

class HomeController: UIViewController {

	let tabView = TabView(count: 2)
	
	let mapView = MapView()
	let overlayView = OverlayView()

	var tabTop = NSLayoutConstraint()
	var overlayTop = NSLayoutConstraint()
	
	let tabViewTopConstatnt: CGFloat = 58
	
	init() {
		super.init(nibName: nil, bundle: nil)
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		mapView.mapView.delegate = self
		overlayView.delegate = self
		overlayView.pageView.delegate = self
		overlayView.pageView.datasource = self
//		overlayView.pageView.homeDelegate = self
//		overlayView.pageView.mapDelegate = mapView
		
		tabView.delegate = self
		
		mapView.mapView.camera = MKMapCamera(lookingAtCenter: CLLocationCoordinate2D(latitude: -33.90, longitude: 151.14), fromDistance: CLLocationDistance(15000.0), pitch: 0.0, heading: CLLocationDirection(0.0))
		
		tabView.translatesAutoresizingMaskIntoConstraints = false
		mapView.translatesAutoresizingMaskIntoConstraints = false
		overlayView.translatesAutoresizingMaskIntoConstraints = false
		
		self.view.addSubview(mapView)
		self.view.addSubview(tabView)
		self.view.addSubview(overlayView)
		
		tabTop = NSLayoutConstraint(item: tabView, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: tabViewTopConstatnt)
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
		
		overlayView.pageView.addTile(index: 0)
		
		UIView.animate(withDuration: 1.0, delay: 0.8, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.2, options: .curveLinear, animations: { [weak self] in
			guard let safe = self else { return }
			safe.overlayTop.constant = safe.overlayView.overlayBottom
			safe.view.layoutIfNeeded()
		})

	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

}

extension HomeController: TKDataSource {

	func tileForIndex(index: Int) -> TKTileView {
		
//		let assigned = pages.map({ $0.view.meta.letter })
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) }) //.filter({ !assigned.contains($0) })
		
		let tile = TileView(content: .empty, meta: PageTileMetaModel(letter: alphabet.randomElement()!))
		
		return tile
		
	}
	
	func buttonForIndex(index: Int, position: TKButtonPosition) -> (TKButtonAction, UIImage, UIColor) {
		return (.confirm, UIImage(), UIColor.red)
	}

}

extension HomeController: TKDelegate {
	
	func didTapTile(index: Int) {
		print("Didtaptile")
		
		if overlayView.pageView.state == .scroll {
			overlayView.pageView.focusTiles(index: index)
		}
		
		//		overlayView.pageView.freezeTiles(index: index)
	}
	
	func didTapButton(action: TKButtonAction) {
		print("Didtapbutton")
		overlayView.pageView.unfocusTiles()
	}
	
}

extension HomeController: OverlayDelegate {
	
	func didUpdateOverlayGesture(gesture: UIPanGestureRecognizer, offset: CGFloat, top: CGFloat, middle: CGFloat) {
		
		let topConstant = offset - gesture.translation(in: self.view).y
		overlayTop.constant = topConstant
		
		if topConstant > top {
			tabTop.constant = tabViewTopConstatnt - (topConstant - top)
			tabView.alpha = 1.0 - (((topConstant / top) - 1.0) * 2)
		} else {
			tabTop.constant = tabViewTopConstatnt
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
		
		tabTop.constant = tabViewTopConstatnt
		
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

//extension HomeController: HomeDelegate {
//
//	func resampleCoordinates() {
//		overlayView.pageView.updateCoordinates(coordinate: mapView.relativeCenter(middle: false))
//	}
//
//	func resampleAddress() {
//		overlayView.pageView.updateLocation(location: mapView.relativeCenter(middle: false), altitude: mapView.mapView.camera.altitude / 300000)
//	}
//
//	func updateMidpoint() {
//
//		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25, execute: { [weak self] in
//
//			guard let safe = self else { return }
//
//			let active = safe.overlayView.pageView.pages.filter({ $0.view.meta.placemark != nil })
//			let count = Double(active.count)
//
//			if count <= 1 { return }
//
//			let x = active.reduce(0.0, { $0 + $1.view.meta.x }) / count
//			let y = active.reduce(0.0, { $0 + $1.view.meta.y }) / count
//			let z = active.reduce(0.0, { $0 + $1.view.meta.z }) / count
//
//			if safe.mapView.midpoint != nil {
//				safe.mapView.mapView.removeAnnotation(safe.mapView.midpoint!)
//			}
//
//			let midpoint = CLLocationCoordinate2D(latitude: atan2(z, sqrt(x * x + y * y)) * 180.0 / Double.pi, longitude: atan2(y, x) * 180.0 / Double.pi)
//
//			safe.mapView.midpoint = MKPlacemark(coordinate: midpoint)
//			safe.mapView.mapView.addAnnotation(safe.mapView.midpoint!)
////
////			let request = MKLocalSearch.Request()
////
////			request.naturalLanguageQuery = "pubs"
////
////
//////			MKLocalPointsOfInterestRequest(center: midpoint, radius: CLLocationDistance(5000))
//////
//////			request.pointOfInterestFilter = MKPointOfInterestFilter(including: [.brewery, .winery, .nightlife])
//////
////
////			MKLocalSearch(request: request).start(completionHandler: { (result, error) in
////
////				print(result?.mapItems)
////
////			})
//
//
//		})
//
//	}
//
//}

extension HomeController: MKMapViewDelegate {

	func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
//		resampleCoordinates()
		


		overlayView.pageView.updateCoordinates(coordinate: mapView.relativeCenter(middle: false))
	}

//	func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
//		resampleAddress()
//	}

	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {

		var reuse: String
		var image: UIImage?

		if let meta = overlayView.pageView.findPage(location: annotation.coordinate) {

			reuse = meta.reuse
			image = meta.image

		} else if let midpoint = self.mapView.midpoint, annotation.coordinate == midpoint.coordinate {

			reuse = "MapReuse-Midpoint"

			let disposable = MapPinView()
			disposable.updatePin(colour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), icon: "Mid-Button")
			image = disposable.renderImage()

		} else {

			return nil

		}

		if let annotation = mapView.dequeueReusableAnnotationView(withIdentifier: reuse) {
			return annotation
		} else {
			let annotation = MKAnnotationView(annotation: annotation, reuseIdentifier: reuse)
			annotation.image = image
			annotation.centerOffset.y = self.mapView.pinView.height / -2 //image?.size.height ?? 0 / -2
			return annotation
		}

	}

}

extension HomeController: TabDelegate {
	
	func getTabIconName(index: Int, focus: Bool) -> String {
		
		switch index {
		
			case 0:
			return "Pin-" + (focus ? "Coloured" : "Filled")
			
			case 1:
			return "Pint-" + (focus ? "Coloured" : "Filled")
			
			default:
			return ""
		
		}
		
	}
	
	func didSelectTab(index: Int) {
		print("Did Select Tab: \(index)")
	}

}

