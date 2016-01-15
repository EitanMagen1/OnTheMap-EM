//
//  StudentLocation.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import Foundation

struct StudentLocationData {
    
    //MARK: Properties
    
    var firstName = ""
    var lastName = ""
    var mapString = ""
    var mediaURL = ""
    var objectID = ""
    var uniqueKey = ""
    var latitude: Float = 0
    var longitude: Float = 0
    var createdAt = ""
    var updatedAt = ""
    
    //MARK: Initializer
    /* Construct a StudentLocation from a dictionary*/
    init(dictionary: [String: AnyObject]) {
       
        firstName = dictionary[ParseConstants.JSONKeys.FirstName] as! String
        lastName = dictionary[ParseConstants.JSONKeys.LastName] as! String
        mapString = dictionary[ParseConstants.JSONKeys.MapString] as! String
        mediaURL = dictionary[ParseConstants.JSONKeys.MediaURL] as! String
        objectID = dictionary[ParseConstants.JSONKeys.ObjectID] as! String
        uniqueKey = dictionary[ParseConstants.JSONKeys.UniqueKey] as! String
        latitude = dictionary[ParseConstants.JSONKeys.Latitude] as! Float
        longitude = dictionary[ParseConstants.JSONKeys.Longitude] as! Float
        createdAt = dictionary[ParseConstants.JSONKeys.CreatedAt] as! String
        updatedAt = dictionary[ParseConstants.JSONKeys.UpdatedAt] as! String
    }
    
    /* Thanks Jarrod Parkes for this awesome idea! */
    // taked an array of dictionaries with the students locations and returns an array of the students data
    static func studentLocationsFromResults(results: [[String:AnyObject]]) -> [StudentLocationData] {
        var studentLocations = [StudentLocationData]()//create an array of the the struct student
        
        for items in results { //go thru all of the items in results which are the Jason dictinary
            studentLocations.append(StudentLocationData(dictionary: items)) //look for matches as in the dictionary and append them into the swift array
        }
        
        return studentLocations
    }
    
}
