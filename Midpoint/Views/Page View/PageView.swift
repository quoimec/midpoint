//
//  PageView.swift
//  Midpoint
//
//  Created by Charlie on 11/2/20.
//  Copyright © 2020 Schacher. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class PageView: UIView {
	
	let scrollView = PageScrollView()
	let throughView: PageThroughView
	
	var page: Int = 0
	var pages = Array<PageContainer>()
	var state: PageState = .scroll
	var size: CGFloat {

		get {
			return CGFloat(Int(scrollView.contentSize.width) / pages.count)
		}

	}
	
	private var width: CGFloat
	private var height: CGFloat
	private var padding: CGFloat
	
	private lazy var geocoder = CLGeocoder()
	
	weak var homeDelegate: HomeDelegate? {
		willSet (delegate) {
			throughView.upperButton.homeDelegate = delegate
			throughView.lowerButton.homeDelegate = delegate
		}
	}
	weak var mapDelegate: MapDelegate? {
		willSet (delegate) {
			throughView.upperButton.mapDelegate = delegate
			throughView.lowerButton.mapDelegate = delegate
		}
	}
	
	init(padding: CGFloat, width: CGFloat, height: CGFloat) {
		
		let screen = UIScreen.main.bounds.width
		
		self.width = (screen * width).rounded() / screen
		self.height = ((screen * self.width) * height).rounded() / (screen * self.width)
		self.padding = padding
		
		self.throughView = PageThroughView(padding: padding)
		
		super.init(frame: CGRect.zero)
		
		scrollView.delegate = self
		throughView.delegate = self
		throughView.upperButton.pageDelegate = self
		throughView.lowerButton.pageDelegate = self
		
		scrollView.clipsToBounds = false
		scrollView.isPagingEnabled = true
		scrollView.alwaysBounceHorizontal = true
		scrollView.isUserInteractionEnabled = true
		scrollView.showsHorizontalScrollIndicator = false
		throughView.isUserInteractionEnabled = true
		
		throughView.translatesAutoresizingMaskIntoConstraints = false
		scrollView.translatesAutoresizingMaskIntoConstraints = false
		
		self.addSubview(scrollView)
		self.addSubview(throughView)
		
		self.addConstraints([
		
			// Scroll View
			NSLayoutConstraint(item: scrollView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1.0, constant: padding),
			NSLayoutConstraint(item: scrollView, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: scrollView, attribute: .bottom, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: scrollView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: width, constant: 0),
			NSLayoutConstraint(item: scrollView, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: height, constant: 0),
			
			// Through View
			NSLayoutConstraint(item: throughView, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: throughView, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: throughView, attribute: .trailing, multiplier: 1.0, constant: 0),
			NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: throughView, attribute: .bottom, multiplier: 1.0, constant: 0)
		
		])
		
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

extension PageView: PageDelegate {
	
	
	/**
	#	Page Getters
		Delegate methods for retrieving pages or metadata about pages from the page tile stack
	**/

	func getPageIndex(page: PageTileView) -> Int? {
	
		/**
		#	Get Page Index
			Retrieve the index for any given page view
			
		#	Arguments
			page: PageTileView - The tile view to retrieve the index for
			
		#	Returns
			Int? - The index of the donated page or nil
		**/
	
		for (index, comparisson) in self.pages.enumerated() {
				
			if comparisson.view != page { continue }
			return index
		
		}
		
		return nil
	
	}

	func getFrozenPage() -> PageContainer? {
	
		/**
		#	Get Frozen Page
			A simple function for retrieving the currently frozen page. If no page is frozen, nil is returned.
			
		#	Returns
			PageContainer? - The currently frozen page or nil
		**/
	
		guard let first = pages.first(where: { $0.frozen }) else { return nil }
		
		return first
	
	}

	func getEmptyPage() -> PageContainer? {
	
		/**
		#	Get Empty Page
			A simple function for retrieving the currently empty page. If no page is empty, nil is returned.
			
		#	Returns
			PageContainer? - The currently empty page or nil
		**/
	
		guard let first = pages.first(where: { $0.view.state == .empty }) else { return nil }
		
		return first
	
	}
	
	
	/**
	#	Scroll Methods
		Delegate methods for interacting with pages from the context of the scroll view
	**/
	
	func addPage(index: Int = 0, state: PageTileState = .empty, animate: Bool = false) {
		
		// TODO:
		// Deal with > 26 locations
		
		let assigned = pages.map({ $0.view.meta.letter })
		let alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZ".map({ String($0) }).filter({ !assigned.contains($0) })
		
		let view = PageTileView(state: state, meta: PageTileMetaModel(letter: alphabet.randomElement()!))
		
		view.pageDelegate = self
		view.mapDelegate = mapDelegate
		
		let top = NSLayoutConstraint(item: view, attribute: .top, relatedBy: .equal, toItem: scrollView, attribute: .top, multiplier: 1.0, constant: 0)
		let bottom = NSLayoutConstraint(item: scrollView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1.0, constant: 0)
		let width = NSLayoutConstraint(item: view, attribute: .width, relatedBy: .equal, toItem: scrollView, attribute: .width, multiplier: 1.0, constant: -self.padding)
		let height = NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: scrollView, attribute: .height, multiplier: 1.0, constant: 0)
		
		var leading: NSLayoutConstraint
		var trailing: NSLayoutConstraint
		
		let safeindex = index > pages.count ? pages.count : index
		let offset = animate ? UIScreen.main.bounds.width * -self.width : 0.0
		
		view.isUserInteractionEnabled = true
		view.translatesAutoresizingMaskIntoConstraints = false
		scrollView.addSubview(view)
		
		if pages.count == 0 {
		
			leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1.0, constant: offset)
			trailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: padding)
		
		} else if safeindex == pages.count {
		
			leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: pages[safeindex - 1].view, attribute: .trailing, multiplier: 1.0, constant: padding)
			trailing = NSLayoutConstraint(item: scrollView, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: padding)
			
			pages[safeindex - 1].update(constraint: .trailing, scroll: scrollView)
			
		} else {
			
			pages[safeindex].update(constraint: .leading, update: NSLayoutConstraint(item: pages[safeindex].view, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1.0, constant: padding), scroll: scrollView)
			
			trailing = NSLayoutConstraint()
			
			if safeindex == 0 {
				leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: scrollView, attribute: .leading, multiplier: 1.0, constant: 0)
			} else {
				leading = NSLayoutConstraint(item: view, attribute: .leading, relatedBy: .equal, toItem: pages[safeindex - 1].view, attribute: .trailing, multiplier: 1.0, constant: padding)
			}
			
		}
		
		pages.insert(PageContainer(view: view, leading: leading, top: top, trailing: trailing, bottom: bottom, width: width, height: height), at: safeindex)
		
		if let coordinate = mapDelegate?.relativeCenter(middle: false) {
			updateCoordinates(coordinate: coordinate)
		}
		
		scrollView.addConstraints(pages[safeindex].constraints)
		
		if animate {

			switch index {
				case 0:
				leading.constant = 0
				default:
				leading.constant = self.padding
			}
			
			UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveEaseOut, animations: {
				self.scrollView.layoutIfNeeded()
			}, completion: nil)
		
		} else {
			
			scrollView.layoutIfNeeded()
			
		}
		
		DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: { [weak self] in
			guard let safe = self else { return }
			safe.mapDelegate?.updatePin(meta: view.meta)
			view.meta.updateImage(new: safe.mapDelegate?.renderPin(meta: view.meta))
		})

	}

	func deletePage(index: Int) {
	
		
	
	}

	func scrollPage(index: Int, animated: Bool, dim: Bool = false, completion: (() -> Void)? = nil) {
	
		/**
		#	Scroll Page
			A function to programatically page to a specific tile index
			
		#	Arguments
			page: Int - The index of the page to scroll to
			animated: Bool - Determines if the pagination is animated
			dim: Bool - If animation is enabled, determines if an alpha dimming should apply to all other pages
			completion: (() -> Void) - An optional callback to indicate that the scrolling process has completed
		**/
	
		self.page = index
		
		// Calculated page scroll offset based on the width of tiles and the supplied index
		let offset = CGPoint(x: CGFloat(index) * self.size, y: 0.0)
		
		if animated {
			
			UIView.animate(withDuration: 0.3, animations: { [weak self] in
			
				guard let safe = self else { return }
				
				safe.scrollView.contentOffset = offset
				
				if dim {
					// If dim is enabled, apply an alpha drop to all non-index pages during the animation
					safe.pages.enumerated().filter({ $0.offset != index }).forEach({ $1.view.alpha = 0.0 })
				}
			
			}, completion: { (finished: Bool) in
				completion?()
			})
		
		} else {
		
			self.scrollView.contentOffset = offset
			completion?()
		
		}
	
	}
	
	func focusPages(focus: Int) {
	
		state = .focussed
		
		scrollPage(index: focus, animated: true)
		
		UIView.animate(withDuration: 0.2, animations: { [weak self] in
		
			guard let safe = self else { return }
			
			for (_, page) in safe.pages.enumerated().filter({ $0.offset != focus }) { page.view.alpha = 0.0 }
			
			safe.throughView.lowerButton.alpha = 1.0
			safe.throughView.upperButton.alpha = 1.0
		
		})
	
	}
	
	func unfocusPages(focus: Int) {
	
		state = .scroll
		
		UIView.animate(withDuration: 0.2, animations: { [weak self] in
		
			guard let safe = self else { return }
			
			for (_, page) in safe.pages.enumerated().filter({ $0.offset != focus }) { page.view.alpha = 1.0 }
			
		})
		
		UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: { [weak self] in
			
			guard let safe = self else { return }
			
			safe.throughView.lowerButton.alpha = 0.0
			safe.throughView.upperButton.alpha = 0.0
			
		}, completion: nil)
		
	}
	
	
	/**
	#	Meta Methods
		Delegate methods for performing, scheduling and organising broad events within the context of
		the page view
	**/
	
	func freezePages(freeze: Int) {
	
		/**
		#	Freeze Pages
			A function for "freezing" a single page in the page stack, removing all non-index pages and
			effectively locking the scroll view. This method is used when editing a tile's location.
			
		#	Arguments
			freeze: Int - The index of the page to freeze
		**/
	
		state = .frozen
	
		// Open an animated scroll to the desired page and only begin the various freezing activities
		// onces the scroll has arrived
		scrollPage(index: freeze, animated: true, dim: true, completion: { [weak self] in
		
			guard let safe = self else { return }
			
			// Update the tile button view based on the tile's initial state
			switch safe.pages[freeze].view.state {
			
				case .empty:
				safe.setButtons(upper: .confirm, lower: .cancel)
				
				case .set:
				safe.setButtons(upper: .confirm, lower: .delete)

				default:
				break
				
			}
			
			// Remove all non-index (i.e: freeze) pages from the scroll view
			safe.scrollView.removeConstraints(
				safe.pages.enumerated().filter({ $0.offset != freeze }).map({ $1.constraints }).reduce([], { $0 + $1 })
			)
			
			for (index, page) in safe.pages.enumerated() {

				if index == freeze {
					page.freeze(scroll: safe.scrollView, padding: safe.padding)
				} else {
					page.view.removeFromSuperview()
				}

			}
			
			safe.pages[freeze].view.state = .editing
			
			safe.homeDelegate?.resampleCoordinates()
			safe.homeDelegate?.resampleAddress()
			
			safe.scrollView.layoutIfNeeded()
		
		})
	
	}
	
	func thawPages() {
		
		/**
		#	Thaw Pages
			A function for reversing the changes of a freezing operation (e.g: after a tile edit has completed)
		**/
	
		// Remove active buttons and re-enable hit test passthrough
		throughView.unsetButtons()
	
		// Re-add all non-index (i.e: freeze) pages back to the scroll view
		for view in pages.filter({ !$0.frozen }).map({ $0.view }) {
			scrollView.addSubview(view)
		}
		
		if let frozen = self.getFrozenPage() {
			frozen.thaw(scroll: scrollView)
		}
		
		// Re-add all non-index (i.e: freeze) constraints back to the scroll view
		scrollView.addConstraints(
			pages.filter({ !$0.frozen }).map({ $0.constraints }).reduce([], { $0 + $1 })
		)
		
		scrollView.layoutIfNeeded()
		
		state = .scroll
		
		UIView.animate(withDuration: 0.3, animations: { [weak self] in
			guard let safe = self else { return }
			safe.pages.forEach({ $0.view.alpha = 1.0 })
		})
		
		// Scroll back to the starting page index
		let index = self.getFrozenPage()?.view.index ?? 0
		
		scrollPage(index: index, animated: false)
		
	}

	func updateLocation(location: CLLocationCoordinate2D, altitude: Double) {

		if state != .frozen { return }
		
		// TODO:
		// Implement better interpretation of altitude and geocoding
		
		geocoder.reverseGeocodeLocation(location.location, completionHandler: { [weak self] placemarks, error in
			guard let safe = self, let placemark = placemarks?[0] else { return }
			
			if altitude <= 3.0 {
				safe.pages[safe.page].view.updateAddress(title: placemark.locality ?? "DEFAULT STRING", subtitle: placemark.name ?? "DEFAULT STRING")
			} else {
				safe.pages[safe.page].view.updateAddress(title: placemark.administrativeArea ?? "DEFAULT STRING", subtitle: placemark.country ?? "DEFAULT STRING")
			}
			
		})
		
	}
	
	func updateCoordinates(coordinate: CLLocationCoordinate2D) {
		
		if state == .frozen {
			pages[page].view.updateCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
		} else if pages.count > 0 {
			pages[0].view.updateCoordinates(latitude: coordinate.latitude, longitude: coordinate.longitude)
		}
		
	}

	func setButtons(upper: PageButtonAction, lower: PageButtonAction) {
	
		throughView.setButtons(upper: upper, lower: lower)
	
	}

	func findPage(location: CLLocationCoordinate2D) -> PageTileMetaModel? {
		
		return pages.first(where: { $0.view.meta.checkCoordinate(coordinate: location) })?.view.meta
		
	}

}

extension PageView: PageThroughDelegate {
	
	func shouldHitTest() -> Bool { return state != .scroll }
	
	func throughHitTest(point: CGPoint, event: UIEvent?) -> UIView? {
		
		return scrollView.hitTest(CGPoint(x: point.x + (CGFloat(scrollView.index + 1) * scrollView.frame.width), y: point.x), with: event)
		
	}
	
}

extension PageView: UIScrollViewDelegate {

	func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {

		let next = Int(targetContentOffset.pointee.x / self.size)
		
		if next == page { return }
	
		if state == .focussed { self.unfocusPages(focus: page) }
	
		page = next
		
		if let location = pages[page].view.meta.placemark?.coordinate {
			mapDelegate?.moveCamera(location: location, animated: true)
		}
			
	}
	
	func scrollViewDidScroll(_ scrollView: UIScrollView) {
		
		if state != .focussed { return }
		
		let alpha = abs(scrollView.contentOffset.x - CGFloat(page) * size) / size
		
		for (_, page) in self.pages.enumerated().filter({ $0.offset != self.page }) { page.view.alpha = alpha }
		
	}
	
}
