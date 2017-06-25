//
//  Cat.swift
//  CatRater
//
//  Created by William on 26/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

// Didn't use 'Cocoa Touch Class' like for Ratingcontrol because this is a base class (no Superclass) for the data model which doesn't need to inherit from any other classes.

import UIKit
// Changed from Foundation, since we need UIKit Framework methods here. Importing UIKit also gives access to Foundation.

class Cat {
    
    //MARK: Properties
    // not let because they will need to change
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Initialization
        // Initializers are methods that prepare an instance of a class for use, which involves setting an initial value for each property and doing any other setup
        // Use init? ( or init!) because only failable initializers can return optional values (which can be valid or nil), or implicitly unwrapped  optional values. Then the optional must be checked & safely unwrapped or implicitly unwrapped.
        // Could use assert() or preconditon() to terminate the app if their conditions fail.
    
    init?(name: String, photo: UIImage?, rating: Int) {
        // Initialization should fail if there is no name or if the rating is negative
        // This code below (Lines 30-32) fails the Unit test for a rating of 6, which should be invalid but is not covered by this if statement
//        if name.isEmpty || rating < 0 {
//            return nil
//        }
        
        // New init checker
        // The name must not be empty
        guard !name.isEmpty else {
            return nil
        }
        
        // The rating must be between 0 and 5 inclusively
        guard (rating >= 0) && (rating <= 5) else {
            return nil
        }
        
        //Initialize stored properties
        self.name = name
        self.photo = photo
        self.rating = rating
    }
    
}
