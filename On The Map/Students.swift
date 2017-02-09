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
    
    var currentUserStudentKey: String?
    var currentUserStudent: StudentDetails?
    var arrayOfStudents = [StudentDetails]()
    
    var showCurrentStudentOnMap = false
    var selectedStudentCoordinates: (Double, Double)?
    
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
        
        self.firstName = dictionary["firstName"] as? String
        self.lastName = dictionary["lastName"] as? String
        self.latitude = dictionary["latitude"]
        self.longitude = dictionary["longitude"]
        self.mapTitle = dictionary["mapString"] as? String
        self.url = dictionary["mediaURL"] as? String
        self.key = dictionary["uniqueKey"]
        
        Students.sharedInstance().arrayOfStudents.append(self)
        
    }
    
}


class StudentAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
}










