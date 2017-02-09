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
    
    
    @IBOutlet var findMeButton: UIBarButtonItem!
    
    var locationManager = CLLocationManager()
    var students = Students.sharedInstance()
    
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
            
            zoomInOnCurrentLocation(latitude: appDelegate.selectedStudent[0].latitude as! Double, longitude: appDelegate.selectedStudent[0].longitude as! Double)
            
            
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
        
        OTMNetworkingClient.sharedInstance().loadStudentDetails(completionHandlerForLoadStudentDetails: {result, _ in
            
            if result == nil {
                
                self.addStudentsToMap(arrayOfStudents: Students.sharedInstance().arrayOfStudents)
                
            } else {
                
                self.showAlert(message: result!)
            }
            
        })
        
    }
    

    func addStudentsToMap(arrayOfStudents: [StudentDetails]) {
        
        let allAnnotations = self.mapView.annotations
        
        self.mapView.removeAnnotations(allAnnotations)
        
        let arrayOfStudents = Students.sharedInstance().arrayOfStudents
        
        for student in arrayOfStudents {
            
            print(student)
            
            if student.latitude != nil && student.longitude != nil {
                
                let coordinates = [student.latitude as? Double, student.longitude as? Double]
                let lastName = student.lastName!
                let firstName = student.firstName!
                let subTitle = student.url!
                let title = "\(firstName) \(lastName)"
                
                let studentAnnotation = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates[0]! , longitude: coordinates[1]! ))
                studentAnnotation.title = title
                studentAnnotation.subtitle = subTitle

                self.mapView.addAnnotation(studentAnnotation)
                
            }
        }
        
        self.mapView.reloadInputViews()
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        LoadingOverlay.shared.hideOverlayView()
        
    }

    
    func zoomInOnCurrentLocation(latitude: Double, longitude: Double) {
        
        let userCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let longitudeDeltaDegrees : CLLocationDegrees = 0.03
        let latitudeDeltaDegrees : CLLocationDegrees = 0.03
        let userSpan = MKCoordinateSpanMake(latitudeDeltaDegrees, longitudeDeltaDegrees)
        let userRegion = MKCoordinateRegionMake(userCoordinate, userSpan)
        
        mapView?.setRegion(userRegion, animated: true)
    }
    

    @IBAction func logoutUserButtonClicked(_ sender: Any) {
        
        logOutUser()
        
    }
    
    private func logOutUser() {
            
        if isInternetAvailable() {
            
            OTMNetworkingClient.sharedInstance().taskForLogout({response, error in
                
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




