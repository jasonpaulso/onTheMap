//
//  StudentTableTableViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit

class StudentTableTableViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Students.sharedInstance().arrayOfStudents.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {


        
        let student = Students.sharedInstance().arrayOfStudents[(indexPath as NSIndexPath).row]
        let firstName = student.lastName!
        let lastName = student.firstName!
        let subTitle = student.url!
        let title = "\(firstName) \(lastName)"
        
        let cellReuseId = "studentDetailCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as UITableViewCell!
        
        cell?.textLabel?.text = title
        cell?.detailTextLabel?.text = subTitle
        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let student = Students.sharedInstance().arrayOfStudents[(indexPath as NSIndexPath).row]
        
        let url = ((student.url)!) as String
        UIApplication.shared.open(URL(string: url)!)
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


}
