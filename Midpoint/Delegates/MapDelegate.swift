//
//  MapDelegate.swift
//  Midpoint
//
//  Created by Charlie on 18/9/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

protocol MapDelegate: class {

	func updatePin(meta: PageTileMetaModel)
	
	func renderPin(meta: PageTileMetaModel) -> UIImage

	func hoverPin(meta: PageTileMetaModel)
	
	func placePin(meta: PageTileMetaModel)
	
	func removePin(meta: PageTileMetaModel)
	
	func replacePin(meta: PageTileMetaModel)

	func moveCamera(location: CLLocationCoordinate2D, animated: Bool)

	func relativeCenter(middle: Bool) -> CLLocationCoordinate2D

}
