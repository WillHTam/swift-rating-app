//
//  CatTableViewController.swift
//  CatRater
//
//  Created by William on 26/6/17.
//  Copyright © 2017 William T. All rights reserved.
//

import UIKit

    // Now we have the data model 'Cat'. Also need to keep a list of those cats, which we will keep track of in a custom view controller subclass that is connected to the cat list scene. This view controller will manage the view that displays the list of cats, and have a reference to the data model behind what's shown in the user interface.

class CatTableViewController: UITableViewController {
    
    //MARK: Properties
    
    // Initializes an empty mutable array of Cat objects
    var catsArray = [Cat]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load the sample data
        // When the view loads, this code calls the helper method to load the initial data
        loadSampleCats()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
            fatalError("Unable to instantiate cat1")
        }
        
        guard let cat3 = Cat(name: "Snowflake", photo: photo3, rating: 5) else {
            fatalError("Unable to instantiate cat1")
        }
        
        guard let cat4 = Cat(name: "Super Cat", photo: photo4, rating: 3) else {
            fatalError("Unable to instantiate cat1")
        }
        
        guard let cat5 = Cat(name: "Orange Loaf", photo: photo5, rating: 2) else {
            fatalError("Unable to instantiate cat1")
        }
        
        catsArray += [cat1, cat2, cat3, cat4, cat5]
    }
    
    //MARK: Actions
    
    // Part of creating the unwind segue is to add an action method to the DESTINATION view controller ( the view controller that the segue is going to )
    // This method has the logic to add the cat (passed from CatViewController, the source view controller) to the cat list data and add a new row to the table view in the cat list scene
    @IBAction func unwindToMealList(sender: UIStoryboardSegue) {
        
        // about the if statement below:
        // Uses optional type operator (as?) to try to downcat the segue's source view controller to a CatViewController instance. 
        // Need to downcat because sender.sourceViewController is of type UIViewController, but need to work with a CatViewController
        // The operator returns an optional value, which will be 'nil' if the downcast wasn't possible. If it succeeds, the code assigns the CatViewController to the local constant sourceViewController, and chekcs to see if the meal property on sourceViewController is nil
        // If the meal property is non-nil, the code assigns the value of that property to the local constant 'cat' and executes the if statement
        // If either the downcast or mea in sourceViewController is nil, the if statement doesn't get executed
        
        if let sourceViewController = sender.source as? CatViewController, let cat = sourceViewController.cat {
            
            // Add a new cat.
            // This code computes the location where the new table view representing the new meal will be inserted, and stores it in a local constant called newIndexPath
            let newIndexPath = IndexPath(row: catsArray.count, section: 0)
            
            // Adds the new cat to the existing list of cats in the data model.
            catsArray.append(cat)
            // Animates the addition of a new row to the table view for the cell that contains information about the new meal. 
            tableView.insertRows(at: [newIndexPath], with: .automatic)
            
        }
        
    }
}
