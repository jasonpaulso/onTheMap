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
    
    class var shared: Students {
        
        struct Static {
            
            static let instance: Students = Students()
            
        }
        
        return Static.instance
    }
    
    func buildAnnotation(studentDetails: StudentDetails, longitude: Double?, latitude: Double?) -> MKAnnotation {
        
        let coordinates = [studentDetails.latitude as? Double, studentDetails.longitude as? Double]
        let lastName = studentDetails.lastName!
        let firstName = studentDetails.firstName!
        let subTitle = studentDetails.url!
        let title = "\(firstName) \(lastName)"
        let latitude = latitude ?? coordinates[0]
        let longitude = longitude ?? coordinates[1]
        
        let studentAnnotation = StudentAnnotation(coordinate: CLLocationCoordinate2D(latitude: latitude! , longitude: longitude! ))
        studentAnnotation.title = title
        studentAnnotation.subtitle = subTitle
        
        return studentAnnotation
        
    }
    
    
}

struct StudentDetails {
    
    var firstName: String?
    var lastName: String?
    var latitude: Any?
    var longitude: Any?
    var mapTitle: String?
    var url: String?
    var key: Any?
    
    
    
    init(dictionary: [String:AnyObject], studentsArray: inout [StudentDetails]) {
        
        self.firstName = dictionary["firstName"] as? String ?? "Unknown"
        self.lastName = dictionary["lastName"] as? String  ?? "Unknown"
        self.latitude = dictionary["latitude"]
        self.longitude = dictionary["longitude"]
        self.mapTitle = dictionary["mapString"] as? String  ?? "Unknown"
        self.url = dictionary["mediaURL"] as? String  ?? "Unknown"
        self.key = dictionary["uniqueKey"] 
        
        studentsArray.append(self)
        
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












