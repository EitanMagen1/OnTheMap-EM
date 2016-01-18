//
//  ParseModel.swift
//  OnTheMap-EM1
//
//  Created by Lauren Efron on 14/01/2016.
//  Copyright © 2016 Udacity. All rights reserved.
//

import Foundation

class ParseModel {
    
    static let sheredInstance = ParseModel()
    
    var AllstudentsDataJsonFormat :[[String : AnyObject]]?
    var objectID : String? = nil
    
    
    func GetingStudentLocations( completionHandeler : ( success: Bool, errorString: String?) ->Void)->Void {
       
        let params = ["limit": 100, "order": "-updatedAt"]
        let UrlString = ParseConstants.URLConstants.BaseURL + escapedParameters(params)

        let NSURLString = NSURL(string: UrlString)!
        let request = NSMutableURLRequest(URL: NSURLString)
        request.addValue(ParseConstants.URLConstants.ApplicationID, forHTTPHeaderField: ParseConstants.HTTPFields.AppID)
        request.addValue(ParseConstants.URLConstants.RestAPIKey, forHTTPHeaderField: ParseConstants.HTTPFields.RestAPIKey)
        
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .Parse ) { (result, error) -> Void in
            if   error == nil {
                guard let StudentData = result[ParseConstants.JSONKeys.Results] as? [[String : AnyObject]]! else {
                    completionHandeler(success: false, errorString: "Failed to get Students information ")
                    return
                }
                StudentLocationData.AllstudendsData = StudentLocationData.studentLocationsFromResults(StudentData)
                self.AllstudentsDataJsonFormat = StudentData
                completionHandeler(success: true, errorString: nil)
                
            }else if let error = error {
                completionHandeler(success: false, errorString: error.description)
                error_handeling.sheredInstance.presentError(error.description)
            }
        }
        return
    }
    
    func POSTingAStudentLocation( jsonBody: [String:AnyObject],completionHandler : ( success : Bool, errorType: String?)->Void)->Void{
        let UrlString = ParseConstants.URLConstants.BaseURL
        let NSURLString = NSURL(string: UrlString)!
        let request = NSMutableURLRequest(URL: NSURLString)
        request.HTTPMethod = "POST"
        request.addValue(ParseConstants.URLConstants.ApplicationID, forHTTPHeaderField: ParseConstants.HTTPFields.AppID)
        request.addValue(ParseConstants.URLConstants.RestAPIKey, forHTTPHeaderField: ParseConstants.HTTPFields.RestAPIKey)
        request.addValue( ParseConstants.HTTPFields.ApplicationJSON, forHTTPHeaderField: ParseConstants.HTTPFields.ContentType)
       
        do {
            request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(jsonBody, options: .PrettyPrinted)
        }
        
        /* 4. Make the request */
        SessionAndParseModel.sheredInstance.sessionAndParseTask(request, client: .Parse) { (result, error) -> Void in
            if error == nil {
                /* GUARD: Is the "account" key in parsedResult? */
                guard let objectId = result[ParseConstants.JSONKeys.ObjectID] as? String? else {
                    completionHandler(success: false, errorType: "Didnt succed in posting the student Data Please try again")
                    return
                }
                self.objectID = objectId
                completionHandler(success: true, errorType: nil)
                return
            }else if let error = error {
                completionHandler(success: false, errorType: error.description)
            }
            return
        }
    }
    func escapedParameters(parameters: [String : AnyObject]) -> String {
        
        var urlVars = [String]()
        
        for (key, value) in parameters {
            
            /* Make sure that it is a string value */
            let stringValue = "\(value)"
            
            /* Escape it */
            let escapedValue = stringValue.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
            
            /* Append it */
            urlVars += [key + "=" + "\(escapedValue!)"]
            
        }
        
        return (!urlVars.isEmpty ? "?" : "") + urlVars.joinWithSeparator("&")
    }

    
    // optional to Querying for a StudentLocation
    // optional PUTing (Updating) a StudentLocation
    
    
    
    
}
