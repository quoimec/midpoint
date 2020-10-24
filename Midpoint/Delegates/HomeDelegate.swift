//
//  HomeDelegate.swift
//  Midpoint
//
//  Created by Charlie on 29/3/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import CoreLocation

protocol HomeDelegate: class {

	func resampleAddress()
	
	func resampleCoordinates()
	
	func updateMidpoint()

}
