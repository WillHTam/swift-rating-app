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
import  os.log

class Cat: NSObject, NSCoding {
    
    //MARK: Properties
    // not let because they will need to change
    var name: String
    var photo: UIImage?
    var rating: Int
    
    //MARK: Archiving Paths
    
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("catsArray")
    
    //MARK: Types
    
    /* 
     Implement saving and loading a Cat here. Using the NSCoding approach, the Cat class is in charge of storing and loading each of its properties.
     It needs to save its data by assigning the value of each property to a particular key. It then loads the data by looking up the information associated with that key. 
     To make it clear which coding key corresponds to each piece of data, create a structure to store the key strings. 
     Then when I need to use the key, can use the constant instead of retyping the string.
    */
    
    struct PropertyKey {
        // One constant for each property of Cat class.  Static keyword indicates that these constants belong to the structure itself, not to instances of the structure.
        static let name = "name"
        static let photo = "photo"
        static let rating = "rating"
    }
    
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
    
    //MARK: NSCoding
    
    // NSCoder class defines a number of encode methods 
    // Each method encodes property of the given type (first two string, last an Int) and stores them with their corresponding key.
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(rating, forKey: PropertyKey.rating)

    }
    
    // Required means this initializer must be implemented on every subclass, if the subclass defines its own initializers
    // Convenience means that it is a secondary initializer that must call a designated initializer form the same class
    // The question mark means that this is a failable initializer that might return nil
    required convenience init?(coder aDecoder: NSCoder) {
        
        // Name is required. If cannot decode a name string, the initializer should fail.
        // The decodeObject(forKey:) method decodes encoded information.
        // The return value of decodeObjectForKey(_:) is an Any? optional. The guard statement both unwraps the optional and downcasts the enclosed type to a String, before assigning it to the name constant. If either of these operations fail, the entire initializer fails.
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Meal object.", log: OSLog.default, type: .debug)
            return nil
        }
        
        // Because photo is an optional property of Meal, just use conditional cast.
        // Downcast the value returned by decodeObject as a UIIMage and assign it to the photo constant. If hte downcast fails, it assings nil to the photo property. There is no need for a guard statement here, because the photo property is itself an optional.
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        
        
        // decodeInteger unarchives an integer. Because the returned value is an Int, there is no need to downcast/unwrap
        let rating = aDecoder.decodeInteger(forKey: PropertyKey.rating)
        
        // Must call designated initializer, because this is a convenience initializer. 
        // As the initializer's arguments, pass in the values of the constants you created while archiving the saved data
        self.init(name: name, photo: photo, rating: rating)
    }
    
}
