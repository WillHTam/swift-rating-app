//
//  ViewController.swift
//  CatRater
//
//  Created by William on 21/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

// By adding UITextFieldDelegate, compiler knows that ViewController class can be a text field delegate
    
    //By using MARK, it lets you jump to sections above in the > > > menu
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var catNameLabel: UILabel!
    // IBOutlet tells XCode to connect nameTextField to the Interface Builder
    // Weak allows this to be deallocated. The strong reference is held by the object's superview, so if the superview exists so does the object
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        // I.e. when ViewController is loaded, it sets itself as delegate of nameTextField property
        nameTextField.delegate = self
    }

    // iOS is based on event-driven programming, where the flow of the app is determined by actions
    
    //MARK: UITextFieldDelegate
    // When a user taps the text field, it becomes the first responder which is responsible for handling many events
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
        // Boolean indicates whether the system should process press of Return key, which we always do so it is true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        catNameLabel.text = textField.text
        // after finishing typing and pressing Done, changes title to whatever is in the text field
    }
    
    //MARK: Actions
    @IBAction func setDefaultLabelText(_ sender: UIButton) {
        catNameLabel.text = "Default Text"
        // Didn't have to specify type of "Default Text" because it was inferred to be string.
    }
    // Ctrl clicked from Button, Changed from 'Outlet' to 'Action' and changed "Any Object" to "UIButton"
    // Triggered whenever the user interacts with the object this action method is attached to
    // an example of target-action in iOS design
    // event is user tapping Set Default Text Button
    // action is setDefaultLabelText(_)
    // The taarget is ViewController
    // The sender is the 'Set Default Label Text' button

}

