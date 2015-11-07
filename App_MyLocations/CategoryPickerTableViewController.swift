//
//  CategoryPickerTableViewController.swift
//  App_MyLocations
//
//  Created by User on 5/11/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class CategoryPickerTableViewController: UITableViewController {
    
    //MARK: - ARRAY DE CATEGORIAS DE LA TABLA
    // Fase 1
    var selectedCategoryName = ""
    var selectedIndexPath = NSIndexPath()
   
    
    let categories = ["No Category",
        "Apple Store",
        "Bar",
        "Bookstore",
        "Club",
        "Grocery Store",
        "Hstoric Building",
        "House",
        "Ice Cream Vendor",
        "Landmark",
        "Park"]
    
    
    

    //MARK: - LIFE APP
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Fase 3 ->
        
        
        
        // Fase 2
        for i in 0..<categories.count{
            
            if categories[i] == selectedCategoryName{
                selectedIndexPath = NSIndexPath(forRow: i, inSection: 0)
                break
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return categories.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        // Configure the cell...
        
        let categoryName = categories[indexPath.row]
        cell.textLabel?.text = categoryName
        
        if categoryName == selectedCategoryName{
            cell.accessoryType = .Checkmark
        }else{
            cell.accessoryType = .None
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if indexPath.row != selectedIndexPath.row{
            
            if let newCell = tableView.cellForRowAtIndexPath(indexPath){
                
                newCell.accessoryType = .Checkmark
            }
            
            if let oldCell = tableView.cellForRowAtIndexPath(selectedIndexPath){
                
                oldCell.accessoryType = .None
            }
            selectedIndexPath = indexPath
        }
   
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickedCategory"{
        
            let cell = sender as! UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell){
                selectedCategoryName = categories[indexPath.row]
            }
        
        }
        
    }

}
