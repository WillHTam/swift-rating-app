//
//  CatViewController.swift
//  CatRater
//
//  Created by William on 21/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit
import os.log
// imports unified logging system to send messages to the console

// Since we added the stars programatically, Interface Builder doesn't know anything about the contents of the Traing Control. To fix define control as @IBDesignable, which lets IB instantiate and draw a copy of the control directly in the canvas. Then a live copy will be available for IB to properly position and size.
class CatViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
// By adding UITextFieldDelegate, compiler knows that ViewController class can be a text field delegate
    
    //By using MARK, it lets you jump to sections above in the > > > menu
    
    //MARK: Properties
    // IBOutlet tells XCode to connect nameTextField to the Interface Builder
    // Weak allows this to be deallocated. The strong reference is held by the object's superview, so if the superview exists so does the object
    // Image (3rd) has no interaction component, if ctrl-dragged 'Action' is not available. Thus a gesture recognizer must be created.
    // Gesture recognizers are objects you attach to a view that respond to input like a control. Gesture recognizers interpret touches and determine whether they correspond to an action like a swipe pinch or rotation
    // Added a 'Tap Gesture Recognizer' from the object library
    @IBOutlet weak var nameTextField: UITextField!
    // @IBOutlet weak var catNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var ratingControl: RatingControl!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    
    /*
        This value is either passed by 'CatTableViewController' in
            `prepare(for:sender:)`
        or constructed as part of adding a new cat.
        The Cat Property here is an optional which means at any point it could be nil.
     */
    var cat: Cat?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field's user input through delegate callbacks
        // I.e. when ViewController is loaded, it sets itself as delegate of nameTextField property
        nameTextField.delegate = self
        
        // Set up views if editing an existing cat
        // If the cat property is non-nil, the code sets each f the views in CatViewControll erto display data from the cat property. Only non-nil when an existing cat is being eidted.
        if let cat = cat {
            navigationItem.title = cat.name
            nameTextField.text = cat.name
            photoImageView.image = cat.photo
            ratingControl.rating = cat.rating
        }
        
        // Enable the Save button only if the text field has a valid Cat name
        updateSaveButtonState()
    }

    // iOS is based on event-driven programming, where the flow of the app is determined by actions
    
    //MARK: UITextFieldDelegate
    // When a user taps the text field, it becomes the first responder which is responsible for handling many events
    
    // This gets called when editing begins or keyboard is displayed
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // Disable Save button while editing
        saveButton.isEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard
        textField.resignFirstResponder()
        return true
        // Boolean indicates whether the system should process press of Return key, which we always do so it is true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButtonState()
        navigationItem.title = textField.text
    }
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        catNameLabel.text = textField.text
//        // after finishing typing and pressing Done, changes title to whatever is in the text field
//    }
    
    //MARK: Navigation
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        // Dismisses the modal scene and animates the transition back to the previous scene
        dismiss(animated: true, completion: nil)
    }
    
    /*
        Need to pass Cat object to CatTableViewController when user taps Save, and discard with Cancel & navigate back to cat list.
        Do it with an Unwind Segue, which moves back through segues to return the user to a scene manage by an existing view controller. While regular segues create a new instance of the destination view controller, unwind segues return the user to view controllers that already exist.
        Below uses prepare method to store data and execute any code as part of the segue
    */
    // Configures the view before it's presented
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // This verifies that the sender is a button, then uses === to check that the objects referenced by sender and saveButton are the same. Otherwise, print out the debug message
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not presed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        // Constants take their value from the input fields
        // The nil coalescing operator (??) returns the value of an optional if the optional has a vlue, or return a defult value otherwise. Here it unwraps whatever is in the text field, which it sets if there is a valid string but returns an empty string otherwise
        let name = nameTextField.text ?? ""
        let photo = photoImageView.image
        let rating = ratingControl.rating
        
        // Set the cat to be passed to CatTableViewController after the unwind segue
        // Since the Cat class' initializer is failable, it can fail any of the conditions there
        cat = Cat(name: name, photo: photo, rating: rating)
    }
    
    //MARK: Actions
    
    // Removed button that changes Label above Text Entry to 'Default Text'
//    @IBAction func setDefaultLabelText(_ sender: UIButton) {
//        catNameLabel.text = "Default Text"
//        // Didn't have to specify type of "Default Text" because it was inferred to be string.
//    }
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
    
    //MARK: Private Methods
    private func updateSaveButtonState() {
        // Disable the Save button if the text field is empty
        let text = nameTextField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
}

