//
//  OverlayDelegate.swift
//  Midpoint
//
//  Created by Charlie on 31/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

protocol OverlayDelegate: class {

	func didUpdateOverlayGesture(gesture: UIPanGestureRecognizer, offset: CGFloat, top: CGFloat, middle: CGFloat)
	
	func didFinishOverlayGesture(gesture: UIPanGestureRecognizer, offset: CGFloat, top: CGFloat, middle: CGFloat, bottom: CGFloat)
	
	func updateOverlayPosition(position: CGFloat)
	
	func getInitialOffset() -> CGFloat
	
}
