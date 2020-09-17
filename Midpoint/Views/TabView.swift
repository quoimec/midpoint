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
	
	private let tabWidth: CGFloat
	private let tabHeight: CGFloat
	private let tabRadius: CGFloat

	let tapTopConstant: CGFloat = 58
	let tabCount: Int
	
	private var focussedIndex: Int?
	
	var sliderView = UIView()
	var tabLabels = Array<UILabel>()
	
	var sliderCenter = NSLayoutConstraint()
	
	private var panRunning: Bool = false
	private var panGesture = UIPanGestureRecognizer()
	private var pressGesture = UILongPressGestureRecognizer()
	
	private var tabIndex: Int = 0
	private let tabInset: CGFloat = 6.0
	
	init(tabs: Array<String>, height: CGFloat = 40, radius: CGFloat = 0.95) {
	
		tabWidth = 1.0 / CGFloat(tabs.count)
		tabHeight = height
		tabRadius = radius
		tabCount = tabs.count
		
		super.init(frame: CGRect.zero)
		
		self.backgroundColor = UIColor.white
		//(red: 0.92, green: 0.94, blue: 0.93, alpha: 1.00)
		sliderView.backgroundColor = UIColor(red: 0.11, green: 0.61, blue: 0.99, alpha: 1.00)
		
		sliderView.translatesAutoresizingMaskIntoConstraints = false
		
		self.layer.cornerRadius = tabHeight * tabRadius / 2.0
		self.layer.shadowColor = UIColor.black.cgColor
		self.layer.shadowOpacity = 0.3
		self.layer.shadowOffset = .zero
		self.layer.shadowRadius = 5
		
		sliderView.layer.cornerRadius = (tabHeight - (tabInset * 2)) * tabRadius / 2.0
		sliderView.layer.shadowColor = UIColor.black.cgColor
		sliderView.layer.shadowOpacity = 0.15
		sliderView.layer.shadowOffset = .zero
		sliderView.layer.shadowRadius = 2
		
		self.addSubview(sliderView)
		
		sliderCenter = NSLayoutConstraint(item: sliderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: centerMultiplier(index: 0), constant: 0)

		self.addConstraints([
		
			// Slider View
			NSLayoutConstraint(item: sliderView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: tabInset),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: sliderView, attribute: .bottom, multiplier: 1.0, constant: tabInset),
			NSLayoutConstraint(item: sliderView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: tabWidth, constant: tabInset * -2),
			NSLayoutConstraint(item: sliderView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabHeight),
			sliderCenter
			
		])
		
		for (index, tab) in tabs.enumerated() {

			let tabLabel = UILabel()
			tabLabels.append(tabLabel)

			tabLabel.text = tab
			tabLabel.textAlignment = .center
			tabLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)

			tabLabel.translatesAutoresizingMaskIntoConstraints = false

			self.addSubview(tabLabel)

			self.addConstraints([

				// Tab Label
				NSLayoutConstraint(item: tabLabel, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: tabInset),
				NSLayoutConstraint(item: tabLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: tabHeight),
				NSLayoutConstraint(item: tabLabel, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: tabWidth, constant: 0),
				NSLayoutConstraint(item: tabLabel, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: centerMultiplier(index: index), constant: 0)

			])

		}
	
		panGesture = UIPanGestureRecognizer(target: self, action: #selector(pressTab(sender:)))
		pressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressTab(sender:)))
	
		pressGesture.minimumPressDuration = 0.0
	
		pressGesture.delegate = self
		panGesture.delegate = self
	
		self.addGestureRecognizer(pressGesture)
		self.addGestureRecognizer(panGesture)
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	private func centerMultiplier(index: Int) -> CGFloat {
		return ((self.tabWidth / 2.0) + (self.tabWidth * CGFloat(index))) * 2.0
	}

	private func touchIndex(sender: UIGestureRecognizer) -> Int {
	
		var touchPoint = sender.location(in: self).x / self.frame.width
		
		if touchPoint < 0.0 { touchPoint = 0.0 }
		if touchPoint >= 1.0 { touchPoint = 0.9999999 }
		
		return Int((touchPoint / tabWidth).rounded(.down))

	}

	private func resetLabels(skip: Int? = nil) {
	
		let skipper = skip == nil ? -1 : skip!
	
		for (index, label) in tabLabels.enumerated() {
			
			if index == skipper { continue }
			
			UIView.animate(withDuration: 0.1, animations: { [weak self] in
				guard let _ = self else { return }
				label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
				label.alpha = 1.0
			})
			
		}
	
	}

	private func updateSlider(index: Int, began: Bool = false) {
		
		if !(0 ..< self.tabCount).contains(index) { return }
		if index == tabIndex && !began { return }
		
		resetLabels(skip: index)
		
		UIView.animate(withDuration: 0.1, animations: { [weak self] in
			guard let safe = self else { return }
			safe.tabLabels[index].transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
			safe.tabLabels[index].alpha = 0.7
		})
		
		if index == tabIndex { return }
		
		tabIndex = index
		
		self.removeConstraint(sliderCenter)
		
		sliderCenter = NSLayoutConstraint(item: sliderView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: centerMultiplier(index: index), constant: 0)
		
		self.addConstraint(sliderCenter)
		
		UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.1, options: .curveEaseOut, animations: { [weak self] in
			guard let safe = self else { return }
			safe.layoutIfNeeded()
		}, completion: nil)
	
	}
	
	@objc private func pressTab(sender: UIGestureRecognizer) {
		
		let index = touchIndex(sender: sender)
		
		if let gesture = sender as? UILongPressGestureRecognizer {
		
			if panRunning { return }
		
			if gesture.state == .began {
				updateSlider(index: index, began: true)
			} else if gesture.state == .ended {
				resetLabels()
			}
		
		} else if let gesture = sender as? UIPanGestureRecognizer {
		
			if gesture.state == .began {
				panRunning = true
			} else if gesture.state == .changed {
				updateSlider(index: index)
			} else if gesture.state == .cancelled || gesture.state == .failed || gesture.state == .ended {
				resetLabels()
				panRunning = false
			}
		
		}
		
	}
	
}

extension TabView: UIGestureRecognizerDelegate {

	func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
		return true
	}

}
