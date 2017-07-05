//
//  CatTableViewController.swift
//  CatRater
//
//  Created by William on 26/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit
import os.log

    // Now we have the data model 'Cat'. Also need to keep a list of those cats, which we will keep track of in a custom view controller subclass that is connected to the cat list scene. This view controller will manage the view that displays the list of cats, and have a reference to the data model behind what's shown in the user interface.

class CatTableViewController: UITableViewController {
    
    //MARK: Properties
    
    // Initializes an empty mutable array of Cat objects
    var catsArray = [Cat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Use the edit button item provided by table view controller
        navigationItem.leftBarButtonItem = editButtonItem
        
        // Load any saved meals, otherwise load sample data
        if let savedCats = loadCats() {
            // If loadCats() successfully returns an array of Cat objects, this is true. False is nil.
            // Then add any cats that were successfully loaded into Cats array
            catsArray += savedCats
        } else {
            // Load the sample data.
            loadSampleCats()
        }
        
        // Load the sample data
        // When the view loads, this code calls the helper method to load the initial data
        // loadSampleCats() > removed because of else statement above
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Override to support editing the table view.
    // Delete from table view using TableViewController/navigationItem method
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            catsArray.remove(at: indexPath.row)
            saveCats()
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it inot the arrya, and add a new row to teh table view
        }
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Only one section
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return as many rows as there are entries in the cat array
        return catsArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CatTableViewCell"
        
        // Because we are using a custom cell class, downcast the type of the cell to CatTableViewCell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CatTableViewCell else {
            fatalError("The dequeued cell is not an instance of CatTableViewCell")
        }
        // dequeueReusableCell method requests a cell from the table view. Instead of creating and deleting new cells as the user scrolls, the table tries to reuse the cells when possible.
        // If no cells are available, the method instantiates a new one, the Identifier tells the method which type of cell it should create or reuse
        
        // Fetch the appropriate cat for the data source layout
        let cat = catsArray[indexPath.row]
        
        cell.nameLabel.text = cat.name
        cell.photoImageView.image = cat.photo
        cell.ratingControl.rating = cat.rating
        
        // Configure cell
        return cell
        
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        // This switch simplifies the logic so there is no need to deal with optionals insid the cases
        // If the identifier is 'nil', ?? replaces it with an empty string
        switch(segue.identifier ?? "") {
            
        case "AddItem":
        os_log("Adding a new cat.", log: OSLog.default, type: .debug)
        // If adding an item to the cat list, no need to change the Cat detail scene's appearance, just log this message to note when it happens
        
        /*
            Below, if editing an existing cat, need to display the cats' data in the cat detail scene. This code gets the destination view controller, the selected cat cell, and the index path of the selected cell. The guard statements check that all the downcasts work and that all optionals contain non-nil values.
            If the storyboard is set up correctly, none of the gaurd statements will fail.
            As soon as the index path is found, can look up the cat object for that path and pass it to the destination view controller
        */
        case "ShowDetail":
            guard let catDetailViewController = segue.destination as? CatViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            guard let selectedCatCell = sender as? CatTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCatCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            
            let selectedCat = catsArray[indexPath.row]
            catDetailViewController.cat = selectedCat
            
            default:
            fatalError("Unexpected Segue Identifier; \(segue.identifier)")
        }
    }
    
    //MARK: Actions

    //  ************ UNWIND START ****************
    
    // Part of creating the unwind segue is to add an action method to the DESTINATION view controller ( the view controller that the segue is going to )
    // This method has the logic to add the cat (passed from CatViewController, the source view controller) to the cat list data and add a new row to the table view in the cat list scene
    @IBAction func unwindToCatList(sender: UIStoryboardSegue) {
        
        // about the if statement below:
        // Uses optional type operator (as?) to try to downcat the segue's source view controller to a CatViewController instance. 
        // Need to downcat because sender.sourceViewController is of type UIViewController, but need to work with a CatViewController
        // The operator returns an optional value, which will be 'nil' if the downcast wasn't possible. If it succeeds, the code assigns the CatViewController to the local constant sourceViewController, and checks to see if the cat property on sourceViewController is nil
        // If the cat property is non-nil, the code assigns the value of that property to the local constant 'cat' and executes the if statement
        // If either the downcast or cat in sourceViewController is nil, the if statement doesn't get executed
        
        if let sourceViewController = sender.source as? CatViewController, let cat = sourceViewController.cat {
            
            // Update an existing cat
            // Checks whether a row in the table view is selected. If it is, it means that the user tapped one of the table views to edit a cat. Simply, this if statement is executed when editing an existing cat
            if let selectedIndexPath = tableView.indexPathForSelectedRow {
                // this line updates the cat array. Replaces the old cat object with the new+edited cat.
                catsArray[selectedIndexPath.row] = cat
                // replaces current cell with a cell that contains the updated cat data
                tableView.reloadRows(at: [selectedIndexPath], with: .none)
            } else {
                
                // Since no row was selected, it must have meant that the user pressed the add button and therefore wants to make a new cat
                
                // Add a new cat.
                let newIndexPath = IndexPath(row: catsArray.count, section: 0)
                
                catsArray.append(cat)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
                
            }
            
//            // Add a new cat.
//            // This code computes the location where the new table view representing the new cat will be inserted, and stores it in a local constant called newIndexPath
//            let newIndexPath = IndexPath(row: catsArray.count, section: 0)
//            
//            // Adds the new cat to the existing list of cats in the data model.
//            catsArray.append(cat)
//            // Animates the addition of a new row to the table view for the cell that contains information about the new cat. 
//            tableView.insertRows(at: [newIndexPath], with: .automatic)
           
            // Save the cats.
            saveCats()
        }
    }
    
    // ********** UNWIND END *****************
    
    
    //MARK: Private Methods
    
    private func loadSampleCats() {
        
        let photo1 = UIImage(named: "cat1")
        let photo2 = UIImage(named: "cat2")
        let photo3 = UIImage(named: "cat3")
        let photo4 = UIImage(named: "cat4")
        let photo5 = UIImage(named: "cat5")
        
        guard let cat1 = Cat(name: "Nice Kitten", photo: photo1, rating: 4) else {
            fatalError("Unable to instantiate cat1")
        }
        
        guard let cat2 = Cat(name: "Scottish Fold", photo: photo2, rating: 5) else {
            fatalError("Unable to instantiate cat2")
        }
        
        guard let cat3 = Cat(name: "Snowflake", photo: photo3, rating: 5) else {
            fatalError("Unable to instantiate cat3")
        }
        
        guard let cat4 = Cat(name: "Super Cat", photo: photo4, rating: 3) else {
            fatalError("Unable to instantiate cat4")
        }
        
        guard let cat5 = Cat(name: "Orange Loaf", photo: photo5, rating: 2) else {
            fatalError("Unable to instantiate cat5")
        }
        
        catsArray += [cat1, cat2, cat3, cat4, cat5]
    }
    
    private func saveCats() {
        
        // This attempts to archive the catsArray to a specific location, and returns true if successful
        // Uses the Cat.ArchiveUrl defined in the Cat class to identify where to save the information
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(catsArray, toFile: Cat.ArchiveURL.path)
        
        if isSuccessfulSave {
            os_log("Cat List successfully saved.", log: OSLog.default, type: .debug)
        } else {
            os_log("Failed to save Cat List...", log: OSLog.default, type: .error)
        }
    }
    
    // Returns optional array of Cat objects
    private func loadCats() -> [Cat]? {
        // Below attempts ot unarchive the object stored at Cat.ArchiveURL.path and downcast that into an array of Cat objects. 
        // Uses as? so that it can return nil if the downcast fails, most likely if no array has been saved
        return NSKeyedUnarchiver.unarchiveObject(withFile: Cat.ArchiveURL.path) as? [Cat]
    }
}
