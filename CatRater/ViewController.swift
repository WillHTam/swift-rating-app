//
//  ViewController.swift
//  CatRater
//
//  Created by William on 21/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit

// Since we added the stars programatically, Interface Builder doesn't know anything about the contents of the Traing Control. To fix define control as @IBDesignable, which lets IB instantiate and draw a copy of the control directly in the canvas. Then a live copy will be available for IB to properly position and size.
class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
// By adding UITextFieldDelegate, compiler knows that ViewController class can be a text field delegate
    
    //By using MARK, it lets you jump to sections above in the > > > menu
    
    //MARK: Properties
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    // IBOutlet tells XCode to connect nameTextField to the Interface Builder
    // Weak allows this to be deallocated. The strong reference is held by the object's superview, so if the superview exists so does the object
    // Image (3rd) has no interaction component, if ctrl-dragged 'Action' is not available. Thus a gesture recognizer must be created.
    // Gesture recognizers are objects you attach to a view that respond to input like a control. Gesture recognizers interpret touches and determine whether they correspond to an action like a swipe pinch or rotation
    // Added a 'Tap Gesture Recognizer' from the object library
    
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
    // The target is ViewController
    // The sender is the 'Set Default Label Text' button
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard if image is tapped
        nameTextField.resignFirstResponder()
        
        // UIImagePickerContorller is a view controller that lets a user pick media from their photo library
        let imagePickerController = UIImagePickerController()
        
        // Allow photos to be picked only from Photo Library
        imagePickerController.sourceType = .photoLibrary
        // .photoLibrary is an enumeration, which means that its type is already known and thus you don't have to write out the complete UIImagePickerContollerSourceType.photolibrary
        
        // Notify ViewController when the user picks an image
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
    // Dragged from the 'Gesture Recognizer' square in the storyboard scene dock
    
    //MARK: UIImagePickerControllerDelegate
    //Called on user cancelling image select
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user cancels
        dismiss(animated: true, completion: nil)
    }
    // Called when user selects photo, in this case display in image view
    // To use this, must have permission to access the user's photo library, do so from the Info.plist. Add 'Privacy - Photo Library Usage Description', Type: String, and add the reason of why you need this permission in Value
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        // The info dictionary always contins the orignal image that was slected in the picker. This code access the original, unedited image from the info dictionary, unwraps the optional and casts it as an UIImage object.
        guard let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
    
        // Set photoImageView to display the selected image
        photoImageView.image = selectedImage
        
        // Dismiss the picker
        dismiss(animated: true, completion: nil)
    }
}

