//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport


class MapPinView: UIView {

	var pinBody = UIImageView()
	var pinGoatee = UIImageView()
	var pinShadow = UIImageView()
	var pinButton = UIImageView()
	
	var pinObject = UIView()
	
	init() {
		super.init(frame: CGRect.zero)
	
		pinBody.image = UIImage(named: "Pin-Body")
		pinGoatee.image = UIImage(named: "Pin-Goatee")
//		pinShadow.image = UIImage(named: "Pin-Shadow")
	
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
	
}

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white

        let pin = MapPinView()
        
        view.addSubview(pin)
        self.view = view
    }
}
// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
