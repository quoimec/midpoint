//
//  TabDelegate.swift
//  Midpoint
//
//  Created by Charlie on 25/9/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

protocol TabDelegate: class {

	func getTabIconName(index: Int, focus: Bool) -> String
	
	func didSelectTab(index: Int)

}
