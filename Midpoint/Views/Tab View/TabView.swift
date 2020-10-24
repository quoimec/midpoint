//
//  TabView.swift
//  Midpoint
//
//  Created by Charlie on 29/1/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit

class TabView: UIView {
	
	// Tab View Meta
	let width: CGFloat
	let height: CGFloat
	let radius: CGFloat
	let count: Int
	let inset: CGFloat
	
	// Tab View Index
	private(set) var index: Int
	
	// Internal Views & Constraints
	private var slider = UIView()
	private var tabs = Array<TabSectionView>()
	private var sliderCenterConstraint = NSLayoutConstraint()
	
	// Gestures & Feedback
	private var panning: Bool = false
	private var panGesture = UIPanGestureRecognizer()
	private var pressGesture = UILongPressGestureRecognizer()
	private var feedbackGenerator = UIImpactFeedbackGenerator(style: .light)
	
	// Animation Duration
	var iconAnimationDuration: Double = 0.1
	var sliderAnimationDuration: Double = 0.3
	
	// External Delegate
	weak var delegate: TabDelegate? {
		didSet { didSetDelegate() }
	}
	
	convenience init(count: Int) {
		// Suggested configuration options
		self.init(count: count, index: 0, height: 40, radius: 0.95, inset: 6.0)
	}
	
	init(count: Int, index: Int, height: CGFloat, radius: CGFloat, inset: CGFloat) {
	
		self.width = 1.0 / CGFloat(count)
		self.height = height
		self.radius = radius
		self.count = count
		self.index = index
		self.inset = inset
		
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = #colorLiteral(red: 1.00, green: 1.00, blue: 1.00, alpha: 1.00)
		slider.backgroundColor = #colorLiteral(red: 0.09274342347, green: 0.1325208255, blue: 0.2399865165, alpha: 1)
		
		slider.translatesAutoresizingMaskIntoConstraints = false
		
		self.layer.cornerRadius = height * radius / 2.0
		self.layer.shadowColor = UIColour.black.cgColor
		self.layer.shadowOpacity = 0.3
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 5
		
		slider.layer.cornerRadius = (height - (inset * 2)) * radius / 2.0
		slider.layer.shadowColor = UIColour.black.cgColor
		slider.layer.shadowOpacity = 0.15
		slider.layer.shadowOffset = .zero
		slider.layer.shadowRadius = 2
		
		self.addSubview(slider)
		
		sliderCenterConstraint = NSLayoutConstraint(item: slider, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: calculateCentreMultiplier(index: 0), constant: 0)

		self.addConstraints([
		
			// Slider View
			NSLayoutConstraint(item: slider, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: inset),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: slider, attribute: .bottom, multiplier: 1.0, constant: inset),
			NSLayoutConstraint(item: slider, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: width, constant: inset * -2),
			NSLayoutConstraint(item: slider, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height),
			sliderCenterConstraint
			
		])
		
		for index in 0 ..< count {

			let tab = TabSectionView()
			tabs.append(tab)

			tab.translatesAutoresizingMaskIntoConstraints = false
			
			self.addSubview(tab)

			self.addConstraints([

				// Tab Label
				NSLayoutConstraint(item: tab, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: inset),
				NSLayoutConstraint(item: tab, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height),
				NSLayoutConstraint(item: tab, attribute: .width, relatedBy: .equal, toItem: tab, attribute: .height, multiplier: 1.0, constant: 0),
				NSLayoutConstraint(item: tab, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: calculateCentreMultiplier(index: index), constant: 0)

			])

		}
	
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(didTriggerGesture(sender:)))
		pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didTriggerGesture(sender:)))
	
		pressGesture.minimumPressDuration = 0.0
	
		pressGesture.delegate = self
		panGesture.delegate = self
	
		self.addGestureRecognizer(pressGesture)
		self.addGestureRecognizer(panGesture)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func didSetDelegate() {
	
		/**
		#	Did Set Delegate
			A simple method that is called after the delegate object of this class has been set
		**/
	
		for (index, tab) in tabs.enumerated() {
			
			tab.update(imageNamed: delegate?.getTabIconName(index: index, focus: index == self.index))
			
		}
	
	}
	
	@objc private func didTriggerGesture(sender: UIGestureRecognizer) {
	
		/**
		#	Did Trigger Gesture
			A core method for responding to various gestures and states when controlling the tab view
			
		#	Arguments
			sender: UIGestureRecognizer - The gesture that triggered the event
		**/
	
	
		let current = gestureTabIndex(gesture: sender)
		
		if current != index {
			feedbackGenerator.impactOccurred()
		}
		
		if let gesture = sender as? UILongPressGestureRecognizer {
			
			// Handle a single tap gesture, the tap logic will stop as soon as the pan gesture starts
			
			if panning { return }
		
			switch gesture.state {
				
				case .began:
				updateTabIcons(current: current)
				updateTabSlider(current: current)
				
				case .ended, .cancelled, .failed:
				updateTabIcons(current: current, ended: true)
				delegate?.didSelectTab(index: current)
				
				default:
				break
				
			}
		
		} else if let gesture = sender as? UIPanGestureRecognizer {
		
			// Handle the various update states of the tab pan gesture
		
			switch gesture.state {
			
				case .began:
				panning = true
				updateTabIcons(current: current)
				updateTabSlider(current: current)
				
				case .changed:
				updateTabIcons(current: current)
				updateTabSlider(current: current)
				
				case .ended, .cancelled, .failed:
				panning = false
				updateTabIcons(current: current, ended: true)
				delegate?.didSelectTab(index: current)
				
				default: break
			
			}
		
		}
	
		index = current
	
	}
	
	private func calculateCentreMultiplier(index: Int) -> CGFloat {
	
		/**
		#	Calculate Centre Multiplier
			Used to correctly position various UI elements along the horizontal axis within the tab view based
			on their relative index
			
		#	Arguments
			index: Int - The index of the UI element in question
			
		#	Returns
			CGFloat: The CenterX constraint multiplier to correctly position the view
		**/
	
		return ((self.width / 2.0) + (self.width * CGFloat(index))) * 2.0
		
	}

	private func gestureTabIndex(gesture: UIGestureRecognizer) -> Int {
		
		/**
		#	Gesture Tab Index
			Used to translate a UIGesture location into a tab index
			
		#	Arguments
			sender: UIGestureRecongnizer - The tap or pan guesture to translate
			
		#	Returns
			Int - The index of the tab closest to the touch point
		**/
		
		var touch = gesture.location(in: self).x / self.frame.width
		
		if touch < 0.0 { touch = 0.0 }
		if touch >= 1.0 { touch = 0.9999999 }
		
		return Int((touch / width).rounded(.down))

	}

	private func updateTabIcons(current: Int, ended: Bool = false) {
	
		UIView.animate(withDuration: iconAnimationDuration, animations: { [weak self] in
		
			guard let safe = self else { return }
		
			for (index, tab) in safe.tabs.enumerated() {
				
				let focus: Bool = index == current
				
				tab.update(imageNamed: safe.delegate?.getTabIconName(index: index, focus: focus))
				
				if focus && !ended {
					tab.alpha = 0.7
					tab.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
				} else {
					tab.alpha = 1.0
					tab.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				}
				
			}
			
		})
	
	}
	
	private func updateTabSlider(current: Int) {
	
		if current == self.index { return }
		
		self.removeConstraint(sliderCenterConstraint)
		
		sliderCenterConstraint = NSLayoutConstraint(item: slider, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: calculateCentreMultiplier(index: current), constant: 0)
		
		self.addConstraint(sliderCenterConstraint)
		
		UIView.animate(withDuration: sliderAnimationDuration, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.1, options: .curveEaseOut, animations: { [weak self] in
			guard let safe = self else { return }
			safe.layoutIfNeeded()
		}, completion: nil)
	
	}
	
}

extension TabView: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

}
