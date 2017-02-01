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

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, ShowsAlert {
    
    var locationManager = CLLocationManager()
    
    var students = Students.sharedInstance()
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        mapView.delegate = self
        print("connected: \(isInternetAvailable())")
        getStudentLocationsFromUdacity()
        
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
    }
    
  
    @IBAction func findMeButton(_ sender: Any) {
        mapView.showsUserLocation = true
        mapView.setUserTrackingMode(.follow, animated: true)
    }

    
    func addStudentsToMap(arrayOfStudents: [Students.studentDetails]) {
        
        for student in arrayOfStudents {
            
            print(student)
            
            if student.latitude != nil && student.longitude != nil {
                
                let coordinates = [student.latitude as? Double, student.longitude as? Double]
                let firstName = student.lastName!
                let lastName = student.firstName!
                let subTitle = student.url!
                let title = "\(firstName) \(lastName)"
                
                let studentAnnotation = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: coordinates[0]! , longitude: coordinates[1]! ))
                studentAnnotation.title = title
                studentAnnotation.subtitle = subTitle

                self.mapView.addAnnotation(studentAnnotation)
                
            }
        }
        
        self.mapView.reloadInputViews()
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else { return nil }
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "Annotation") as? MKPinAnnotationView
        if annotationView == nil {
            let image = #imageLiteral(resourceName: "Arrow")
            let button = UIButton(type: .custom)
            button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            button.setImage(image, for: .normal)
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Annotation")
            annotationView?.canShowCallout = true
            annotationView?.rightCalloutAccessoryView = button
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if control == view.rightCalloutAccessoryView {
            print("Disclosure Pressed! \(view.annotation?.subtitle)")
            let url = ((view.annotation?.subtitle)!)! as String
            UIApplication.shared.open(URL(string: url)!)
            
        }
    }
    
    
    

    
    func getUserDataFromUdacity() {
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://www.udacity.com/api/users/3903878747")! as URL)
        
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
            
            guard let newData = data!.subdata(in: Range(uncheckedBounds: (lower: data!.startIndex.advanced(by: 5), upper: data!.endIndex))) as Data? else {
                
                print("Error: invalid range in data")
                
                return
            }
            
            guard let results = try? JSONSerialization.jsonObject(with: newData, options: .allowFragments) as AnyObject? else {
                
                print("Error: could not serialize data")
                
                return
            }
            
            print(results!)
            
        })
        
        dataTask.resume()
    }
    
    
}




