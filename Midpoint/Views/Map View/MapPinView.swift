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

	private var pinBody = UIImageView()
	private var pinGoatee = UIImageView()
	private var pinShadow = UIImageView()
	private var pinLetter = UIImageView()
	
	private var pinObject = UIView()
	private var pinStatic = UIView()
	
	private var pinObjectBottom = NSLayoutConstraint()
	private var pinShadowBottom = NSLayoutConstraint()
	
	let width: CGFloat = 50
	var height: CGFloat {
		get { return self.width * 1.25 }
	}
	var hover: CGFloat {
		get { return self.width * 0.3 }
	}
	var margin: CGFloat {
		get { return self.width * 0.1}
	}
	
	init() {
		super.init(frame: CGRect.zero)
		
		self.clipsToBounds = false
		self.isUserInteractionEnabled = false
	
		pinBody.image = UIImage(named: "Pin-Body")?.withRenderingMode(.alwaysTemplate)
		pinGoatee.image = UIImage(named: "Pin-Goatee")
		pinShadow.image = UIImage(named: "Pin-Shadow")

		pinBody.translatesAutoresizingMaskIntoConstraints = false
		pinGoatee.translatesAutoresizingMaskIntoConstraints = false
		pinShadow.translatesAutoresizingMaskIntoConstraints = false
		pinLetter.translatesAutoresizingMaskIntoConstraints = false
		pinObject.translatesAutoresizingMaskIntoConstraints = false
		pinStatic.translatesAutoresizingMaskIntoConstraints = false
	
		pinObject.addSubview(pinBody)
		pinObject.addSubview(pinGoatee)
		pinObject.addSubview(pinLetter)
		pinStatic.addSubview(pinShadow)
		
		self.addSubview(pinStatic)
		self.addSubview(pinObject)
	
		pinObjectBottom = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: pinObject, attribute: .bottom, multiplier: 1.0, constant: 0)
		pinShadowBottom = NSLayoutConstraint(item: pinStatic, attribute: .bottom, relatedBy: .equal, toItem: pinShadow, attribute: .bottom, multiplier: 1.0, constant: self.height * -0.5)
	
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
			NSLayoutConstraint(item: pinObject, attribute: .bottom, relatedBy: .equal, toItem: pinGoatee, attribute: .bottom, multiplier: 1.0, constant: 0),
			
			// Pin Letter
			NSLayoutConstraint(item: pinLetter, attribute: .leading, relatedBy: .equal, toItem: pinObject, attribute: .leading, multiplier: 1.0, constant: self.margin),
			NSLayoutConstraint(item: pinLetter, attribute: .top, relatedBy: .equal, toItem: pinObject, attribute: .top, multiplier: 1.0, constant: self.margin),
			NSLayoutConstraint(item: pinObject, attribute: .trailing, relatedBy: .equal, toItem: pinLetter, attribute: .trailing, multiplier: 1.0, constant: self.margin),
			NSLayoutConstraint(item: pinLetter, attribute: .height, relatedBy: .equal, toItem: pinLetter, attribute: .width, multiplier: 1.0, constant: 0)
			
		])
		
		pinStatic.addConstraints([
		
			// Pin Shadow
			NSLayoutConstraint(item: pinShadow, attribute: .leading, relatedBy: .equal, toItem: pinStatic, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinStatic, attribute: .trailing, relatedBy: .equal, toItem: pinShadow, attribute: .trailing, multiplier: 1.0, constant: 0),
			pinShadowBottom,
			NSLayoutConstraint(item: pinShadow, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.width),
			NSLayoutConstraint(item: pinShadow, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.height),
			
		])
		
		self.addConstraints([
		
			// Pin Static
			NSLayoutConstraint(item: pinStatic, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinStatic, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: pinStatic, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: pinStatic, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: pinStatic, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.width),
			NSLayoutConstraint(item: pinStatic, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.height),
		
			// Pin Object
			NSLayoutConstraint(item: pinObject, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: pinObject, attribute: .trailing, multiplier: 1.0, constant: 0),
			pinObjectBottom,
			NSLayoutConstraint(item: pinObject, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.width),
			NSLayoutConstraint(item: pinObject, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: self.height)
		
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func updatePin(colour: UIColour, icon: String) {
	
		/**
		#	Update Pin
			A method to change the primary pin colour and letter
			The pin goatee will appear as a 20% darkened shade of the provided colour
			
		#	Arguments
			colour: UIColour - The desired pin colour
		**/
	
		pinBody.tintColor = colour
		pinLetter.image = UIImage(named: icon)
	
	}
	
	func raisePin() {
	
		/**
		#	Raise Pin
			Combines a set of actions to raise the onscreen pin object
			Intended to be called from inside of a UIView.animate operation
		**/
	
		pinObjectBottom.constant = self.hover
		pinShadowBottom.constant = 0
		pinShadow.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
		pinShadow.alpha = 1.0
		layoutIfNeeded()
		
	}
	
	func lowerPin() {
	
		/**
		#	Lower Pin
			Combines a set of actions to lower the onscreen pin object
			Intended to be called from inside of a UIView.animate operation
		**/
	
		pinObjectBottom.constant = 0
		pinShadowBottom.constant = self.height * -0.5
		pinShadow.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
		pinShadow.alpha = 0.0
		layoutIfNeeded()
		
	}
	
    func renderImage() -> UIImage {
		
		/**
		#	Render Image
			A function for rendering out the current pin object view as an image for a map annotation
			
		#	Returns
			UIImage - An image representation of the pin object view
		**/
		
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: self.width, height: self.height))
		
		let image = renderer.image { context in
			pinObject.drawHierarchy(in: CGRect(x: 0, y: 0, width: self.width, height: self.height), afterScreenUpdates: true)
		}
		
		return image
       
    }
    
}
