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
    
    let student = Students.sharedInstance().currentUserStudent
    
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
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        if studentSelectedCurrentLocation {
            
            location.getAdress { result in
                
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
            
            let coordinates = [userLatitude, userLongitude]
            let lastName = (student!.lastName!) as String
            let firstName = (student?.firstName!)!  as String
            let subTitle = userWebsiteTextField
            let title = "\(firstName) \(lastName)"
            let studentAnnotation = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates[0]! , longitude: coordinates[1]! ))
            
            studentAnnotation.title = title
            studentAnnotation.subtitle = subTitle
            
            self.mapView.addAnnotation(studentAnnotation)
            
            mapView.showsUserLocation = true
            mapView.setUserTrackingMode(.follow, animated: true)
            self.zoomInOnCurrentLocation(latitude: userLatitude!, longitude: userLongitude!)
            
        } else if userLatitude != nil && userLongitude != nil {
            
            let coordinates = [userLatitude, userLongitude]
            let lastName = (student?.lastName!)! as String
            let firstName = (student?.firstName!)!  as String
            let subTitle = userWebsiteTextField
            let title = "\(firstName) \(lastName)"
            let studentAnnotation = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates[0]! , longitude: coordinates[1]! ))
            
            studentAnnotation.title = title
            studentAnnotation.subtitle = subTitle
            
            self.mapView.addAnnotation(studentAnnotation)
            self.zoomInOnCurrentLocation(latitude: userLatitude!, longitude: userLongitude!)
            
        }
       
        
    }

    @IBAction func dissmissButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
  
    @IBAction func submitButton(_ sender: Any) {
        
        let firstName = (Students.sharedInstance().currentUserStudent?.firstName)! as String
        let lastname = (Students.sharedInstance().currentUserStudent?.lastName)! as String
        let uniqueKey = (Students.sharedInstance().currentUserStudent?.key)! as! String
        
        let parameters = [
            "uniqueKey": uniqueKey,
            "firstName": firstName,
            "lastName": lastname,
            "mapString": userLocationString!,
            "mediaURL": userWebsiteTextField!,
            "latitude": userLatitude!,
            "longitude": userLongitude!
            ] as [String:Any]
        
        OTMNetworkingClient.sharedInstance().taskForDetailsPost(parameters, completionHandlerForDetailsPost: { (response, error) in
            
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
                    
                    self.reloadStudentsMapView()
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
    
    
    func reloadStudentsMapView() {
        
        let tabViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarController")
        
        self.present(tabViewController, animated: true, completion: nil)
        
    }
    
    func zoomInOnCurrentLocation(latitude: Double, longitude: Double) {
        
        let userCoordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let longitudeDeltaDegrees : CLLocationDegrees = 0.03
        let latitudeDeltaDegrees : CLLocationDegrees = 0.03
        let userSpan = MKCoordinateSpanMake(latitudeDeltaDegrees, longitudeDeltaDegrees)
        let userRegion = MKCoordinateRegionMake(userCoordinate, userSpan)
        
        mapView?.setRegion(userRegion, animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        
        let yourAnnotationAtIndex = 0
        
        mapView.selectAnnotation(mapView.annotations[yourAnnotationAtIndex], animated: true)
    }

}
