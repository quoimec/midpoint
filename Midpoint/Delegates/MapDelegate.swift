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

protocol MapDelegate: class {

	func hoverPin(meta: PageTileMetaModel)
	
	func placePin(meta: PageTileMetaModel)
	
	func removePin(meta: PageTileMetaModel)
	
	func replacePin(meta: PageTileMetaModel)
	
	func relativeCenter(middle: Bool) -> CLLocationCoordinate2D

}
