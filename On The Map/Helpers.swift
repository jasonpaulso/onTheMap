//
//  Helpers.swift
//  On The Map
//
//  Created by Jason Southwell on 1/31/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//
import UIKit
import Foundation
import SystemConfiguration
import MapKit

// Mark: Connectivity Check

func isInternetAvailable() -> Bool {
    
    var zeroAddress = sockaddr_in()
    
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            
        }
        
    }
    
    var flags = SCNetworkReachabilityFlags()
    
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        
        return false
        
    }
    
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    
    return (isReachable && !needsConnection)
    
}

// Mark : Geocoding

struct Typealiases {
    typealias JSONDict = [String:Any]
}

class GetLocation {
    
    let locManager = CLLocationManager()
    var currentLocation: CLLocation!
    
    func getAddress(completion: @escaping (Typealiases.JSONDict) -> ()) {
        
        locManager.requestWhenInUseAuthorization()
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            currentLocation = locManager.location
            
            let geoCoder = CLGeocoder()
            geoCoder.reverseGeocodeLocation(currentLocation) { (placemarks, error) -> Void in
                
                if error != nil {
                    print("Error getting location: \(String(describing: error))")
                } else {
                    let placeArray = placemarks as [CLPlacemark]!
                    var placeMark: CLPlacemark!
                    placeMark = placeArray?[0]
                    completion(placeMark.addressDictionary as! Typealiases.JSONDict)
                }
            }
        }
    }
}







