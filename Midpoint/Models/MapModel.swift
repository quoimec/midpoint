//
//  MapModel.swift
//  Midpoint
//
//  Created by Charlie on 13/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct MapModel {

	var mapTitle: String?
//	var
	var mapLocations: Array<LocationModel>
	
	var closestBars: Array<Int>
	
	func addLocation() { return }
	func updateLocation() { return }
	func deleteLocation() { return }
	
	
	
	
	
	
	
	private func updateMidpoint() -> CLLocationCoordinate2D {
		return CLLocationCoordinate2D(latitude: -33.5, longitude: 151.5)
	}
	
	private func closestLandmarks(location: CLLocationCoordinate2D) -> Array<Int> { return [1] }
	
}
