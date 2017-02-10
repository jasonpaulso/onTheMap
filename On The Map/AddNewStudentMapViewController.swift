//
//  AddNewStudentMapViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 2/5/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddNewStudentMapViewController: UIViewController {
    
    let studentsSharedInstance = Students.shared
    let student = Students.shared.currentUserStudent
    
    var addStudentPresentingViewController: UIViewController!
    
    
    var client = OTMNetworkingClient.shared
    
    var studentSelectedCurrentLocation = false
    var userLatitude: Double?
    var userLongitude: Double?
    var userWebsiteTextField: String?
    var userLocationString: String?
    var locationManager = CLLocationManager()
    let location = GetLocation()
    
    @IBOutlet var submitButton: UIButton!
    
    @IBOutlet var mapView: MKMapView!
     
    override func viewDidLoad() {
        
        
        submitButton.layer.cornerRadius = 15
        submitButton.clipsToBounds = true
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        viewLoadFunctions()
       
    }
    
    func viewLoadFunctions() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if studentSelectedCurrentLocation {
            
            location.getAddress { result in
                
                if let city = result["City"] as? String {
                    if let state = result["State"] as? String {
                        self.userLocationString = "\(city), \(state)"
                    } else {
                        self.userLocationString = "\(city)"
                    }
                    
                }
            }
            userLongitude = locationManager.location?.coordinate.longitude
            userLatitude = locationManager.location?.coordinate.latitude
            
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
            
            buildAnnotateAndZoomOnMap(student: student!)
            
        } else if userLatitude != nil && userLongitude != nil {
            
            buildAnnotateAndZoomOnMap(student: student!)
            
            
        }
        
    }
    
    func buildAnnotateAndZoomOnMap(student: StudentDetails) {
        
        let studentAnnotation = studentsSharedInstance.buildAnnotation(studentDetails: student, longitude: userLongitude, latitude: userLatitude)

        self.mapView.addAnnotation(studentAnnotation)
        
        let region = buildCurrentLocation(latitude: userLatitude!, longitude: userLongitude!)
        
        mapView?.setRegion(region, animated: true)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let annotationIndex = 0
        
        mapView.selectAnnotation(mapView.annotations[annotationIndex], animated: true)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        addStudentPresentingViewController = self.presentingViewController
        
        print(addStudentPresentingViewController)
    }


    @IBAction func dissmissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
  
    @IBAction func submitButton(_ sender: Any) {
        LoadingOverlay.shared.showOverlay()
        let firstName = (student?.firstName)! as String
        let lastname = (student?.lastName)! as String
        let uniqueKey = (student?.key)! as! String
        
        let parameters = [
            "uniqueKey": uniqueKey,
            "firstName": firstName,
            "lastName": lastname,
            "mapString": userLocationString!,
            "mediaURL": userWebsiteTextField!,
            "latitude": userLatitude!,
            "longitude": userLongitude!
            ] as [String:Any]

        client.taskForDetailsPost(parameters, completionHandlerForDetailsPost: { (response, error) in
            LoadingOverlay.shared.hideOverlayView()
            
            if error == nil {

                performUIUpdatesOnMain {
                    
                    guard (response?["error"] as? String) == nil else {
                        
                        performUIUpdatesOnMain {
                            
                            self.showAlert(title: "Alert", message: (response?["error"] as! String), buttonText: "Dismiss")
                            
                        }
                        
                        return
                    }
                    
                    guard let _ = response?["objectId"] as? String? else {
                        
                        print("Error: could not parse data: \(response!)")
                        self.showAlert(title: "Alert", message: "There was a problem posting your information. Please try again.", buttonText: "OK")
                        return
                    }
                    
                    self.dismiss(animated: true) {
                        // go back to MainMenuView as the eyes of the user
                        self.addStudentPresentingViewController?.dismiss(animated: false, completion: nil)
                    }
                }
                
            } else {
                
                performUIUpdatesOnMain {
                    
                    self.showAlert(title: "Alert", message: "There was a problem posting your information. Please try again.", buttonText: "OK")
                    print(error as Any)
                    return
                }
                
            }
            
        })
    }
    


}
