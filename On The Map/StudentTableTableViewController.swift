//
//  StudentTableTableViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit

class StudentTableTableViewController: UITableViewController {
    
    var client = OTMNetworkingClient.shared
    
//    var collectionOfStudents = [StudentDetails]()
    
    var studentsSharedInstance = Students.shared
    

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
//        collectionOfStudents = studentsSharedInstance.arrayOfStudents

    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return studentsSharedInstance.arrayOfStudents.count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let student = studentsSharedInstance.arrayOfStudents[(indexPath as NSIndexPath).row]
        let firstName = student.firstName!
        let lastName = student.lastName!
        let title = "\(firstName) \(lastName)"
        
        let cellReuseId = "CustomStudentTableCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseId) as! CustomStudentTableCell!
        
        cell?.nameLabel.text = title
        
        cell?.arrowTapped = { (selectedCell) -> Void in
            
            let url = student.url!
            
            if formatAndValidateUrl(urlString: url).0 == true {
                
                UIApplication.shared.open(URL(string: url)! as URL)
                
            } else {
                
                self.showAlert(message: "Could not open link.")

            }

        }
        
        cell?.pinTapped = { (selectedCell) -> Void in
            
            self.appDelegate = UIApplication.shared.delegate as! AppDelegate
            
            self.appDelegate.selectedStudent = [student]
            
            self.appDelegate.showSelectedStudentOnMap = true
            
            self.tabBarController?.selectedIndex = 0
        }

        
        return cell!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let student = studentsSharedInstance.arrayOfStudents[(indexPath as NSIndexPath).row]
        
        let url = student.url!
        
        if formatAndValidateUrl(urlString: url).0 == true {
            
            UIApplication.shared.open(URL(string: url)! as URL)
            
        } else {
            
            self.showAlert(message: "Could not open link.")
            
        }

        
    }

    var appDelegate: AppDelegate!
    
    func loadMapView(longitude: Double? = nil, latitude: Double? = nil, websiteString: String?, mapString: String?, findLocation: Bool? = false) {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        appDelegate.selectedStudentCoordinates = (latitude!, longitude!)
        appDelegate.showSelectedStudentOnMap = true

        print("tab bar selected?", Students.shared.showCurrentStudentOnMap)
        
        tabBarController?.selectedIndex = 0
        
    }


    @IBAction func logoutUserButtonClicked(_ sender: Any) {
        logOutUser()
    }
    
    private func logOutUser() {
        
        if isInternetAvailable() {
            
            client.taskForLogout({response, error in
                
                if error != nil {
                    
                    print(error!)
                    
                    return
                }
                
            })
            
           self.dismiss(animated: true, completion: nil)

            
        } else {
            
            self.showAlert(message: "Could not log you out. Please try again later.")
            
        }
    }
    
    func loadStudentDetails() {
        
        client.loadStudentDetails(completionHandlerForLoadStudentDetails: {result, _ in
            
            if result == nil {
                
                self.view.reloadInputViews()

                
            } else {
                
                self.showAlert(message: result!)

            }
            
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            
            LoadingOverlay.shared.hideOverlayView()
            
            return
            
        })
        
    }
    
    
    @IBAction func refreshButtonClicked(_ sender: Any) {
        
            loadStudentDetails()
        
    }

}

class CustomStudentTableCell: UITableViewCell {
    
    var arrowTapped: ((CustomStudentTableCell) -> Void)?
    var pinTapped: ((CustomStudentTableCell) -> Void)?
    
    @IBOutlet var pinButtonOutlett: UIButton!

    @IBOutlet var nameLabel: UILabel!
    
    @IBOutlet var arrowButtonOutlet: UIButton!
    
    @IBAction func arrowButtonAction(_ sender: Any) {
        
        arrowTapped?(self)
    }

    @IBAction func pinButtonAction(_ sender: Any) {
        
        pinTapped?(self)
    }
    
}
