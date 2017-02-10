//
//  ViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 1/24/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import SystemConfiguration

class MapViewController: UIViewController {
    
    var client = OTMNetworkingClient.shared
    
    
    @IBOutlet var findMeButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var students = Students.shared
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        loadViewFunctions()
        
        
    }
    
    func loadViewFunctions() {
        
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        mapView.delegate = self
        
        loadStudentDetails()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        if CLLocationManager.authorizationStatus() == .denied {
            
            findMeButton.isEnabled = false
            
        } else {
            
            findMeButton.isEnabled = true
            
        }

        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    var appDelegate: AppDelegate!
    
    override func viewWillAppear(_ animated: Bool) {
        
        loadViewFunctions()
        
        if appDelegate.showSelectedStudentOnMap {
            
            print("zooming")
            
            let region = buildCurrentLocation(
                latitude: appDelegate.selectedStudent[0].latitude as! Double,
                longitude: appDelegate.selectedStudent[0].longitude as! Double
            )
            
            self.mapView.setRegion(region, animated: true)
            
        }
        
    }
    

    @IBAction func findMeButtonClicked(_ sender: Any) {
        
        var locationAvailable: Bool?
        
        if locationManager.location != nil{
            
            locationAvailable = true
            
        } else {
            
            locationAvailable = false
            
        }
        
        if locationAvailable! {
            
            mapView.showsUserLocation = true
            
            mapView.setUserTrackingMode(.follow, animated: true)
            
        } else {
            
            showAlert(message: "Sorry, we can't find you right now. Please try again later.")
            
        }
        

    }
    
    

    @IBAction func findMeButton(_ sender: Any) {
        
        
    }
    
    func loadStudentDetails() {
        
        client.loadStudentDetails(completionHandlerForLoadStudentDetails: {result, _ in
            
            if result == nil {
                
                self.addStudentsToMap(arrayOfStudents: self.students.arrayOfStudents)
                
            } else {
                
                self.showAlert(message: result!)
            }
            
        })
        
    }
    

    func addStudentsToMap(arrayOfStudents: [StudentDetails]) {
        
        let allAnnotations = self.mapView.annotations
        
        self.mapView.removeAnnotations(allAnnotations)
        
        let arrayOfStudents = students.arrayOfStudents
        
        for student in arrayOfStudents {
            
            print(student)
            
            if student.latitude != nil && student.longitude != nil {

                let studentAnnotation = Students.shared.buildAnnotation(studentDetails: student, longitude: nil, latitude: nil)
                
                self.mapView.addAnnotation(studentAnnotation)
                
            }
        }
        
        self.mapView.reloadInputViews()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        LoadingOverlay.shared.hideOverlayView()
        
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

    
    @IBAction func reloadButtonClicked(_ sender: Any) {
        
        loadStudentDetails()
        
    }
    
}




