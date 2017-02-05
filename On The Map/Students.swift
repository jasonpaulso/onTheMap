//
//  Structs.swift
//  On The Map
//
//  Created by Jason Southwell on 1/30/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import Foundation
import MapKit

class Students : NSObject {
    
    var arrayOfStudents = [StudentDetails]()
    
    class func sharedInstance() -> Students {
        struct Singleton {
            static var sharedInstance = Students()
        }
        return Singleton.sharedInstance
    }
    
}

struct StudentDetails {
    
    let firstName: String?
    let lastName: String?
    let latitude: Any?
    let longitude: Any?
    let mapTitle: String?
    let url: String?
    let key: Any?
    
    
    init(dictionary: [String:AnyObject]) {
        
        firstName = dictionary["firstName"] as? String
        lastName = dictionary["lastName"] as? String
        latitude = dictionary["latitude"]
        longitude = dictionary["longitude"]
        mapTitle = dictionary["mapString"] as? String
        url = dictionary["mediaURL"] as? String
        key = dictionary["uniqueKey"]
        
        Students.sharedInstance().arrayOfStudents.append(self)
        
    }
    
}


class StudentAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    
//    var firstName: String!
//    var lastname: String!
//    
//    var url: String!
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}










