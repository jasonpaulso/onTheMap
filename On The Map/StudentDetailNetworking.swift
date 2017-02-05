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
                        
                        _ = StudentDetails.init(dictionary: student)
                        
                    }
                }
                
                performUIUpdatesOnMain {
                    
                    self.addStudentsToMap(arrayOfStudents: self.students.arrayOfStudents)
                    
                }
                
            }
            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            performUIUpdatesOnMain {
                
                self.showAlert(title: "Alert", message: "No internet connection detected. Please connect and try again.", buttonText: nil)

            }
            
        }
        
        
    }
    
    func postNewStudentToUdacity() {
        
        let headers = [
            "X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr",
            "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY",
            "Content-Type": "application/json"
        ]
        
        let parameters = [
            "uniqueKey": "1234",
            "firstName": "Jason",
            "lastName": "Southwell",
            "mapString": "San Francisco, CA",
            "mediaURL": "https://jasonpaulsouthwell.com",
            "latitude": 37.789996,
            "longitude": -122.41193199999998
            
        ] as [String : Any]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://parse.udacity.com/parse/classes/StudentLocation")! as URL)
        
        request.allHTTPHeaderFields = headers
        
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
        
        request.httpMethod = "POST"
        
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
            
            print(results!)
            
        })
        
        if isInternetAvailable() {
            
            dataTask.resume()
            
        } else {
            
            showAlert(title: "Alert", message: "No internet connection detected. Please connect and try again.", buttonText: nil)
            
        }

        
    }
    

    
}
