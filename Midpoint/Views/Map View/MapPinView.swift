//
//  MapPinView.swift
//  Midpoint
//
//  Created by Charlie on 15/3/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class MapPinView: UIView {

	var pinBody = UIImageView()
	var pinGoatee = UIImageView()
	var pinShadow = UIImageView()
	var pinButton = UIImageView()
	
	var pinObject = UIView()
	
	init() {
		super.init(frame: CGRect.zero)
	
		pinBody.image = UIImage(named: "Pin-Body")?.withRenderingMode(.alwaysTemplate)
		pinGoatee.image = UIImage(named: "Pin-Goatee")
//		pinShadow.image = UIImage(named: "Pin-Shadow")

		pinBody.tintColor = UIColor.red
	
		pinBody.translatesAutoresizingMaskIntoConstraints = false
		pinGoatee.translatesAutoresizingMaskIntoConstraints = false
		pinShadow.translatesAutoresizingMaskIntoConstraints = false
		pinButton.translatesAutoresizingMaskIntoConstraints = false
		pinObject.translatesAutoresizingMaskIntoConstraints = false
	
		pinObject.addSubview(pinBody)
		pinObject.addSubview(pinGoatee)
		
		self.addSubview(pinObject)
	
		pinObject.addConstraints([
		
			// Pin Body
			NSLayoutConstraint(item: pinBody, attribute: .leading, relatedBy: .equal, toItem: pinObject, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinBody, attribute: .top, relatedBy: .equal, toItem: pinObject, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .trailing, relatedBy: .equal, toItem: pinBody, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .bottom, relatedBy: .equal, toItem: pinBody, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Pin Goatee
			NSLayoutConstraint(item: pinGoatee, attribute: .leading, relatedBy: .equal, toItem: pinObject, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinGoatee, attribute: .top, relatedBy: .equal, toItem: pinObject, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .trailing, relatedBy: .equal, toItem: pinGoatee, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .bottom, relatedBy: .equal, toItem: pinGoatee, attribute: .bottom, multiplier: 1.0, constant: 0)
			
		])
		
		self.addConstraints([
		
			// Pin Object
			NSLayoutConstraint(item: pinObject, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: pinObject, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: pinObject, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinObject, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 200),
			NSLayoutConstraint(item: pinObject, attribute: .height, relatedBy: .equal, toItem: pinObject, attribute: .width, multiplier: 1.35, constant: 0)
		
		])
	
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
    func renderImage() -> UIImage {
		
		/**
		#	Render Image
			A function for 
		**/
		
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    
    }
	
}
