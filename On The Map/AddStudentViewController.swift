//
//  AddStudentViewController.swift
//  On The Map
//
//  Created by Jason Southwell on 2/5/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class AddStudentViewController: UIViewController, UITextFieldDelegate {
    

    
    var locationManager = CLLocationManager()
    let geocoder = CLGeocoder()

    @IBOutlet var userWebsiteTextField: UITextField!
    @IBOutlet var userWebSiteTextFieldAlt: UITextField!
    @IBOutlet var userLocationTextField: UITextField!

    @IBOutlet var searchByCurrentLocationButton: UIButton!
    @IBOutlet var searchByInputButton: UIButton!
    @IBOutlet var orLabel: UILabel!
    
    var userWebSite: String?
    
    override func viewDidLoad() {
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            
            self.locationManager.requestWhenInUseAuthorization()
            
        }
        
        if CLLocationManager.authorizationStatus() == .denied {

            userWebsiteTextField.isUserInteractionEnabled = false
            searchByCurrentLocationButton.isUserInteractionEnabled = false
            
        }
        
        
        super.viewDidLoad()
        
        userWebsiteTextField.delegate = self
        userWebSiteTextFieldAlt.delegate = self
        userLocationTextField.delegate = self

        searchByCurrentLocationButton.layer.cornerRadius = 15
        searchByCurrentLocationButton.clipsToBounds = true
        
        searchByInputButton.layer.cornerRadius = 15
        searchByInputButton.clipsToBounds = true
        
    }


    @IBAction func findUserByCurrentLocation(_ sender: Any) {
        
        LoadingOverlay.shared.showOverlay()
        
        var locationAvailable: Bool?
        
        if locationManager.location != nil{
            
            locationAvailable = true
            
        } else {
            
            locationAvailable = false
            
        }
        
         print("Available?", locationAvailable!)
        
        if locationAvailable! {
            
            if didValidateTextEntry(webSiteString: userWebsiteTextField.text!, locationString: "auto") {
                
                LoadingOverlay.shared.hideOverlayView()
                
                self.loadMapView(longitude: nil, latitude: nil, websiteString: userWebSite!, mapString: nil, findLocation: true)
                
                
            } else {
                
                LoadingOverlay.shared.hideOverlayView()
                
                self.showAlert(title: "Alert", message: "Website address is not valid", buttonText: "OK")
                
                return
            }
            
        } else {
            
            LoadingOverlay.shared.hideOverlayView()
            
            self.showAlert(message: "Your location is currently unavailable. Please search by input or try again later.")
            
            return
        }
        

    }

    
    
    @IBAction func findUserByInput(_ sender: Any) {
        
        LoadingOverlay.shared.hideOverlayView()
        
        let addressString = userLocationTextField.text!
        
        if didValidateTextEntry(webSiteString: userWebSiteTextFieldAlt.text!, locationString: addressString) {
            
            geocoder.geocodeAddressString(addressString) { placemarks, error in
                    
                guard error == nil else {
                    
                    print(error!)
                    LoadingOverlay.shared.hideOverlayView()
                    
                    self.showAlert(message: "Could not find this location. Please try something else.")
                    
                    return
                }
                
                guard let location = placemarks?[0] else {
                    
                    LoadingOverlay.shared.hideOverlayView()
                    
                    self.showAlert(message: "Could not find this location. Please try something else.")
                    
                    return
                }
                
                let longitude = (location.location?.coordinate.longitude)! as Double?
                let latitude = (location.location?.coordinate.latitude)! as Double?
                
                LoadingOverlay.shared.hideOverlayView()
                
                self.loadMapView(longitude: longitude, latitude: latitude, websiteString: self.userWebSite, mapString: addressString)
                    
                    
            }

        }
        
        
    }
    
    
    @IBAction func dissmissViewButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: {})
        
    }
    
    func didValidateTextEntry(webSiteString: String, locationString: String?) -> Bool {
        
        var isValidated = false
        var isLocationStringValid = false
        let validatedWebSite = formatAndValidateUrl(urlString: webSiteString)
        let isWebSiteStringValid = validatedWebSite.0
        
        userWebSite = validatedWebSite.1
        
        if locationString == "auto" {
            
            isLocationStringValid = true
            
        } else {
            
            isLocationStringValid = isValidString(string: locationString!)
            
        }
        
        
        if isLocationStringValid && isWebSiteStringValid {
            
            print("text entry validated.")
            
            isValidated = true
            
        } else if !isWebSiteStringValid {
            
            print("invalid website address")
            
            self.showAlert(title: "Alert", message: "Website address is not valid", buttonText: "OK")
            
            isValidated = false
            
        } else if !isLocationStringValid {
            
            print("invalid location String")
            
            self.showAlert(title: "Alert", message: "Please enter a location", buttonText: "OK")
            
            isValidated = false
            
        }
        
        return isValidated
    }
    
    

        
    
    private func loadMapView(longitude: Double? = nil, latitude: Double? = nil, websiteString: String?, mapString: String?, findLocation: Bool? = false) {
        
        let addStudentMapView = storyboard?.instantiateViewController(withIdentifier: "AddNewStudentMapViewController") as! AddNewStudentMapViewController
        
        addStudentMapView.studentSelectedCurrentLocation = findLocation!
        addStudentMapView.userWebsiteTextField = websiteString
        addStudentMapView.userLatitude = latitude
        addStudentMapView.userLongitude = longitude
        addStudentMapView.userLocationString = mapString
        
        self.present(addStudentMapView, animated: true, completion: nil)
       
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }

}
