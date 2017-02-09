//
//  StringValidation.swift
//  On The Map
//
//  Created by Jason Southwell on 2/8/17.
//  Copyright © 2017 Jason Southwell. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import MapKit

func isValidUserEmail(usernameString: String) -> Bool {
    
    var returnValue = true
    
    let emailRegEx = "[A-Z0-9a-z.-_]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,3}"
    
    do {
        let regex = try NSRegularExpression(pattern: emailRegEx)
        
        let nsString = usernameString as NSString
        
        let results = regex.matches(in: usernameString, range: NSRange(location: 0, length: nsString.length))
        
        if results.count == 0 {
            
            returnValue = false
            
        }
        
    } catch let error as NSError {
        
        print("invalid regex: \(error.localizedDescription)")
        
        returnValue = false
        
    }
    
    return  returnValue
    
}

func isValidString(string: String) -> Bool {
    
    var returnValue = true
    
    let whitespace = NSCharacterSet.whitespaces
    
    if ((string.trimmingCharacters(in: whitespace)) == "") {
        
        returnValue = false
        
    }
    
    return returnValue
}


func formatAndValidateUrl(urlString: String?) -> (Bool, String?) {
    
    var returnedUrl = urlString
    
    var isValid = false
    
    print("first", returnedUrl!)
    
    if isValidString(string: urlString!) {
        
        if let urlString = returnedUrl {
            
            if let url = NSURL(string: urlString) {
                
                if UIApplication.shared.canOpenURL(url as URL) {
                    
                    returnedUrl = returnedUrl!
                    
                    isValid = true
                    
                } else {
                    
                    if returnedUrl?[0..<4] != "http" {
                        
                        let formattedUrl = "http://\(returnedUrl! as String)"
                        
                        if let url = NSURL(string: formattedUrl) {
                            
                            if UIApplication.shared.canOpenURL(url as URL) {
                                
                                returnedUrl = formattedUrl
                                
                                isValid = true
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    
    
    return (isValid, returnedUrl!)
}

extension String {
    
    var length: Int {
        return self.characters.count
    }
    
    subscript (i: Int) -> String {
        return self[Range(i ..< i + 1)]
    }
    
    func substring(from: Int) -> String {
        return self[Range(min(from, length) ..< length)]
    }
    
    func substring(to: Int) -> String {
        return self[Range(0 ..< max(0, to))]
    }
    
    subscript (r: Range<Int>) -> String {
        let range = Range(uncheckedBounds: (lower: max(0, min(length, r.lowerBound)),
                                            upper: min(length, max(0, r.upperBound))))
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(start, offsetBy: range.upperBound - range.lowerBound)
        return self[Range(start ..< end)]
    }
    
}
