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
@IBDesignable class RatingControl: UIStackView {
    
    //MARK: Properties
    private var ratingButtons = [UIButton]()
    
    var rating = 0 {
        didSet {
            // add a property observer here to call this method whenever the rating changes
            updateButtonSelectionStates()
        }
    }
    
    // Can specify properties that can then be set in the Attributes Inspector with @IBInspectable
    // To update the control, need to reset the buttons every time these attributes change, do it with a Property Observer which are called every time a property's value is set, can do work immediately before or after a value change
    // didSet is the Property Observer
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

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
        // prints this to debugger when button is pressed
        // print("Button Pressed 👍")
        
        // Below, indexOf attempts to find the selected button in the array of buttons and returns the index at which it was found
        // Error shouldn't occur unless something is seriously wrong
        // Once the button's index is returned, add 1 to get the rating
        // If the user taps a star that corresponds with the current rating, reset the rating to 0. Otherwise set the rating as the star you pressed
        guard let index = ratingButtons.index(of: button) else {
            fatalError("The button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        
        // Calculate the rating of the selected button
        let selectedRating = index + 1
        
        if selectedRating == rating {
            // If the selected star represents the current rating, reset the rating to 0.
            rating = 0
        } else {
            // Otherwise set the rating to the selected star
            rating = selectedRating
        }
    }
    
    //MARK: Private Methods
    // Private methods can only be code within the declaring class, which ensures that they are not unexpectedly or accidentally called from outside
    private func setupButtons() {
        // Load Button Images
        let bundle = Bundle(for: type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        // Property Observer calls this method, but must clear out old buttons with this
        // First tells Stack View to not calcuate the button size and position
        // Then actually remove the button
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // Created 5 buttons with this for-in loop with half-open range operator (..<)
        // Underscore is a wildcard when you dont need to know which iteration of the loop is currently executing
        // for _ in 0..<5

        // Auto indent with Ctrl+I
        // starCount and starSize set above in Properties
        for _ in 0..<starCount {
            // Create the button
            let button = UIButton()
            
            //Set the button images
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
            // This makes the button a solid red square
            //button.backgroundColor = UIColor.red
        
            // Button's constraints, together defines it as a fixed 44x44pt. object
            // Removes automatically generated constraints. Typically when using Auto Layout you want to replace these constraints with your own
            button.translatesAutoresizingMaskIntoConstraints = false
            // Create constraints here
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
        
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
        // Need to update the button's selection states whenever buttons are added to the view.
        updateButtonSelectionStates()
    }
    
    
    // Updates the button's appearance, a helper method that updates the selection state
    // Iterates through the buttons and sets each one's selected state based on its position and the rating.
    // The selected state affects the buttons' appearance. If the button's index is less than the rating isSelected is true and displays the filledStar image. Otherwise isSelected is false and shows the empty star
    private func updateButtonSelectionStates() {
        for (index, button) in ratingButtons.enumerated() {
            // If the index of a button is less than the rating, that button should be selected
            button.isSelected = index < rating
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
