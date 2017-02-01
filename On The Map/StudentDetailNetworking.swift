//
//  Networking.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import Foundation
import UIKit

extension MapViewController {
    
    func getStudentLocationsFromUdacity() {
        
        
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation?limit=100")! as URL)
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                
                print(error!)
                
            } else {
                
                let httpResponse = response as? HTTPURLResponse
                
                print(httpResponse!)
            }
            
            guard data != nil else {
                
                print("Error: did not receive data")
                
                return
            }
            
            
            guard let results = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as AnyObject? else {
                
                print("Error: could not serialize data")
                
                return
            }
            
            if let studentResults = results!["results"] as? [[String:AnyObject]] {
                
                for student in studentResults {
                    
                    if student["firstName"] != nil {
                        
                        _ = Students.studentDetails.init(dictionary: student)
                        
                    }
                }
                
                DispatchQueue.main.async {
                    
                    self.addStudentsToMap(arrayOfStudents: self.students.arrayOfStudents)
                    
                }
                
            }
            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            showAlertAsync(title: "Alert", message: "No internet connection detected. Please connect and try again.", buttonText: nil)
            
        }
        
        
    }
    

    
}
