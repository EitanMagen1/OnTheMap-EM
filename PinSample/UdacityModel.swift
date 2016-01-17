//
//  UdacityModel.swift
//  OnTheMap-EM1
//
//  Created by Lauren Efron on 14/01/2016.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

class UdacityModel {
    
    static let sheredInstance = UdacityModel()
    
    
    //logging in to udacity
    func requestForPOSTSession(jsonBody: [String:AnyObject], completionHandler:(success : Bool , errorType : String?)-> Void) -> Void {
        
        let urlString = UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.Session
        let url = NSURL(string: urlString)!
        
        /* 3. Configure the request */
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        request.addValue(UdacityConstants.HTTPFields.ApplicationJSON, forHTTPHeaderField: UdacityConstants.HTTPFields.Accept)
        request.addValue(UdacityConstants.HTTPFields.ApplicationJSON, forHTTPHeaderField: UdacityConstants.HTTPFields.ContentType)
        
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .Udacity) { (result, error) -> Void in
            if error == nil {
                /* GUARD: Is the "account" key in parsedResult? */
                guard let accountStatus = result[UdacityConstants.JSONKeys.Account] as? [String : AnyObject] else {
                    completionHandler(success: false, errorType: "No match on email/password combination.")
                    return
                }
                guard let sessionKey = accountStatus[UdacityConstants.JSONKeys.Key] as? String else {
                    completionHandler(success: false, errorType:  "No match on email/password combination.")
                    return
                }
                UdacityConstants.UserData.UserSessionKey = sessionKey
                completionHandler(success: true, errorType: nil)
                
            }else if error != nil{
                if error?.code == 403 {
                    completionHandler(success: false, errorType:  "No match on email/password combination.")
                    
                }else{
                    completionHandler(success: false, errorType:  "Network Error")
                }
            }
        }
        
        return
    }
    
    func requestForDELETESession(completionHandler :( success : Bool , errorString :String?)-> Void )-> Void {
        
        let NSURLString = UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.Session
        let request = NSMutableURLRequest(URL: NSURL(string: NSURLString)!)
        request.HTTPMethod = "DELETE"
        var xsrfCookie: NSHTTPCookie? = nil
        let sharedCookieStorage = NSHTTPCookieStorage.sharedHTTPCookieStorage()
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .Udacity) { (result, error) -> Void in
            //here if there are no errores we will get back the parsed data after serialization ready for inspection
            // 1. if the errror responder was empty
            if error == nil {
                if let sessionDictionary = result[UdacityConstants.JSONKeys.Session] as? [String:AnyObject] {
                    if let _ = sessionDictionary[UdacityConstants.JSONKeys.SessionID] as? String {
                        completionHandler(success: true, errorString: nil)
                    } else {
                        completionHandler(success: false, errorString: "Logout fail: reading sessionId from Udacity")
                    }
                } else {
                    completionHandler(success: false, errorString: "Logout fail: reading response from Udacity")
                }
            } else if let error = error {
                completionHandler(success: false, errorString: error.description)
            }
        }
        return
    }
    
    func requestForGETUserData(completionHandler: (userInfo: [String:String]?,  errorString: String?) -> Void) -> Void {
        
        var userInfo = [String:String]()
        let request = NSMutableURLRequest(URL: NSURL(string: UdacityConstants.URLConstants.BaseURL + UdacityConstants.Methods.UserData + UdacityConstants.UserData.UserSessionKey)!)
        request.HTTPMethod = "GET"
        
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .Udacity) { (result, error) in
            if error == nil {
                if let userDictionary = result[UdacityConstants.JSONKeys.UserDictionary] as? [String:AnyObject] {
                    // we don't need anything other than full name so create new shorter dictionary and send that instead
                    if let lastName = userDictionary[UdacityConstants.JSONKeys.LastName] as? String {
                        userInfo[UdacityConstants.JSONKeys.LastName] = lastName
                    }
                    if let firstName = userDictionary[UdacityConstants.JSONKeys.FirstName] as? String {
                        userInfo[UdacityConstants.JSONKeys.FirstName] = firstName
                    }
                    if let uniqueKey = userDictionary[UdacityConstants.JSONKeys.Key] as? String {
                        userInfo[UdacityConstants.JSONKeys.Key] = uniqueKey
                    }

                    completionHandler(userInfo: userInfo, errorString: nil)
                } else {
                    completionHandler(userInfo: nil, errorString: "User data fail: reading response from Udacity")
                }
            } else if let error = error {
                completionHandler(userInfo: nil, errorString: error.description)
            }
        }
        return
    }

    
    
}
