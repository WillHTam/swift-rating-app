//
//  RatingControl.swift
//  CatRater
//
//  Created by William on 22/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit

// Create a view either by programatically initializing it or by allowing the view to be loaded by the storyboard
// init(frame:) for programatically
// init(coder:) for storyboard
class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Button Action
    func ratingButtonTapped(button: UIButton){
        print("Button Pressed 👍")
    }
    
    //MARK: Private Methods
    // Private methods can only be code within the declaring class, which ensures that they are not unexpectedly or accidentally called from outside
    private func setupButtons() {
        
        // Create 5 buttons with this for-in loop with half-open range operator (..<)
        // Underscore is a wildcard when you dont need to know which iteration of the loop is currently executing
        // Auto indent with Ctrl+I
        for _ in 0..<5 {
            // Create the button
            let button = UIButton()
            button.backgroundColor = UIColor.red
        
            // Button's constraints, together defines it as a fixed 44x44pt. object
            // Removes automatically generated constraints. Typically when using Auto Layout you want to replace these constraints with your own
            button.translatesAutoresizingMaskIntoConstraints = false
            // Create constraints here
            button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
            button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
            // Setup the button action
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            // addTarget attaches the 'ratingButtonTapped()' method to the button object which gets triggered on tap
            // The target is 'self' which is the 'RatingControl' object
            // #selector returns the Selector value for the provided method, and lets the system call the action method 'ratingButtonTapped'. addTarget is a method that requires selectors
            // UIControlEvents.touchUpInside (used as an enumeration) responds to when the user touches the button and then lifts up their finger. Better than '.touchDown' because you can cancel by dragging your finger outside the button
            // func doSomething(sender: UIButton, forEvent event: UIEvent)
        
            // Add the button to the stack
            addArrangedSubview(button)
            
            // Add the new button to the rating button array
            ratingButtons.append(button)
        }
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
