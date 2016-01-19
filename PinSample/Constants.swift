//
//  Constants.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import Foundation

// MARK: Enum to indicate client
enum ClientSelection {
    case Udacity
    case Parse
}

class ParseConstants  {
    //Parse Application ID and REST API Key for “On the Map”:
    struct URLConstants {
        static let ApplicationID: String = "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr"
        static let RestAPIKey: String = "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"
        static let BaseURL: String = "https://api.parse.com/1/classes/StudentLocation"
    }
    
    struct Parameters {
        static let Order: String = "order"
        static let Limit: String = "limit"
        static let Where: String = "where"
    }
    
    struct HTTPFields {
        static let AppID: String = "X-Parse-Application-Id"
        static let RestAPIKey: String = "X-Parse-REST-API-Key"
        static let ApplicationJSON = UdacityConstants.HTTPFields.ApplicationJSON
        static let ContentType: String = UdacityConstants.HTTPFields.ContentType
    }
    
    struct JSONKeys {
        /* GETting StudentLocations Response */
        static let Results = "results" //outer dictionary
        
        /* also POSTing StudentLocation Body keys */
        static let FirstName = "firstName"
        static let LastName = "lastName"
        static let Latitude = "latitude"
        static let Longitude = "longitude"
        static let MapString = "mapString"
        static let MediaURL = "mediaURL"
        static let UniqueKey = "uniqueKey" //also in POSTing StudentLocations
        static let ObjectID = "objectId" //also used in request to PUT (update) StudentLocation
        
        /* POSTing StudentLocations Response */
        static let CreatedAt = "createdAt"
        
        /* PUTting StudentLocations Response */
        static let UpdatedAt = "updatedAt"
    }
}

class  UdacityConstants {
    
    struct URLConstants {
        static let BaseURL: String = "https://www.udacity.com/api/"
        static let SignUpURL: String = "https://www.udacity.com/account/auth#!/signin"
    }
    
    struct Methods {
        static let Session = "session"
        static let UserData = "users/"
    }
    struct UserData {
        static var UserSessionKey = ""
    }
    
    struct HTTPFields {
        static let XSRFToken = "X-XSRF-TOKEN"
        static let ApplicationJSON = "application/json"
        static let Accept = "Accept"
        static let ContentType = "Content-Type"
    }
    
    struct JSONKeys {
        /* POSTing (Creating) a Session */
        static let Account = "account" //outer dictionary
        static let Registered = "registered"
        static let Key = "key" //also used in GET
        static let Udacity = "udacity" //httpbody outer
        static let Username = "username"
        static let Password = "password"
        static let facebook_mobile = "facebook_mobile"
        static let access_token = "access_token"
        

        static let Session = "session" //outer dict; also used in DELETE
        static let SessionID = "id" //also used in DELETE
        static let Expiration = "expiration" //also used in DELETE
        
        /* GET public user data */
        static let UserDictionary = "user"
        static let LastName = "last_name"
        static let FirstName = "first_name"
    }
}