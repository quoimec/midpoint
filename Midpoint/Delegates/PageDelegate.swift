//
//  PageDelegate.swift
//  Midpoint
//
//  Created by Charlie on 12/3/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol PageThroughDelegate: class {

	func shouldHitTest() -> Bool
	
	func throughHitTest(point: CGPoint, event: UIEvent?) -> UIView?

}

protocol PageDelegate: class {
	
	func addPage(index: Int, state: PageTileState, animate: Bool)
	
	func getPageIndex(page: PageTileView) -> Int?
	
	func getFrozenPage() -> PageContainer?
	
	func getEmptyPage() -> PageContainer?
	
	func scrollPage(index: Int, animated: Bool, dim: Bool, completion: (() -> Void)?)
	
	func focusPages(focus: Int)
	
	func unfocusPages(focus: Int)
	
	func freezePages(freeze: Int)
	
	func thawPages()
	
	func deletePage(index: Int)
	
	func updateLocation(location: CLLocationCoordinate2D, altitude: Double)
	
	func updateCoordinates(coordinate: CLLocationCoordinate2D)
	
	func setButtons(upper: PageButtonAction, lower: PageButtonAction)

	func findPage(location: CLLocationCoordinate2D) -> PageTileMetaModel?

}
