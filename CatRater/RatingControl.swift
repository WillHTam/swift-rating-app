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

    //MARK: Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }
    
    //MARK: Private Methods
    // Private methods can only be code within the declaring class, which ensures that they are not unexpectedly or accidentally called from outside
    private func setupButtons() {
        
        // Create the buton
        let button = UIButton()
        button.backgroundColor = UIColor.red
        
        // Button's constraints, together defines it as a fixed 44x44pt. object
        // Removes automatically generated constraints. Typically when using Auto Layout you want to replace these constraints with your own
        button.translatesAutoresizingMaskIntoConstraints = false
        // Create constraints here
        button.heightAnchor.constraint(equalToConstant: 44.0).isActive = true
        button.widthAnchor.constraint(equalToConstant: 44.0).isActive = true
        
        // Add the button to the stack
        addArrangedSubview(button)
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
