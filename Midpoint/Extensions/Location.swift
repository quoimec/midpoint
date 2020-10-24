//
//  Location.swift
//  Midpoint
//
//  Created by Charlie on 19/9/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import CoreLocation

extension CLLocationCoordinate2D: Equatable {

	var location: CLLocation {
		get { CLLocation(latitude: self.latitude, longitude: self.longitude) }
	}
	
	public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }

}

extension CLLocationDegrees {

	var radians: Double {
		get { self * Double.pi / 180.0 }
	}

}
