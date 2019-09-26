//
//  LikedTableViewController.swift
//  Finder
//
//  Created by Justin Sian on 07/12/2018.
//  Copyright © 2018 Justin Sian. All rights reserved.
//

import UIKit

class LikedTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print(LikedRestaurants.likedRestaurants.restaurants.count)
        // for receiving notifications from other view controllers
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @objc func loadList(){
        // if notification is received refresh the view
        self.tableView.reloadData()
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return LikedRestaurants.likedRestaurants.restaurants.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // 1) Create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        
        // 2) Configure the cell...
        let restaurant = LikedRestaurants.likedRestaurants.restaurants[indexPath.row]
        if(restaurant.count > 0) {
            cell.textLabel!.text = restaurant
        } else {
            cell.textLabel!.text = "No Restaurants"
            cell.detailTextLabel!.text = ""
        }
        
        // 3) Return cell
        return cell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // delete restaurant from the data source and save changes to the database
            LikedRestaurants.likedRestaurants.restaurants.remove(at: indexPath.row)
            LikedRestaurants.likedRestaurants.saveToDatabase()
            
            // Delete the row from the table view controller
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
 

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
