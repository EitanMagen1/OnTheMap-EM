//
//  TableViewController.swift
//  On The Map
//
//  Created by Eitan Magen on 06/1/16.
//  Copyright © 2016 Eitan Magen . All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {

    //MARK: Lifecycle functions

    override func viewDidLoad() {
        super.viewDidLoad()
        parentViewController!.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .Plain, target: self, action: "logoutButtonTouchUp")
        parentViewController?.navigationItem.rightBarButtonItems = [UIBarButtonItem(barButtonSystemItem: .Refresh, target: self, action: "refreshTable"), UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addButtonTouchUp")]
        refreshTable()
    }
 
    //MARK: Button Touch Up Functions
    
    func logoutButtonTouchUp() {
        UdacityModel.sheredInstance.requestForDELETESession { (success, errorString) -> Void in
            if success {
                self.parentViewController?.dismissViewControllerAnimated(true, completion: nil)
            }
            else {
                print(errorString)
                self.presentError("There was an error logging out. Please try again.")
            }
        }
    }
    
    func addButtonTouchUp() {
        let controller = storyboard?.instantiateViewControllerWithIdentifier("InfoPostingViewController") as UIViewController!
        self.presentViewController(controller, animated: true, completion: nil)
    }
    
    func refreshTable() {
        ParseModel.sheredInstance.GetingStudentLocations { (success, errorString) -> Void in
            if success {
                self.tableView.reloadData()
                self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: true)
            } else {
                print(errorString)
                self.presentError("There was an error loading student locations.")
            }
        }
    }
    
    //MARK: Helpers
    
    func presentError(errorString: String) {
        let ac = UIAlertController(title: "Error", message: errorString, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    //MARK: UITableViewDelegate protocol functions

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ParseModel.sheredInstance.AllstudendsData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentLocation = ParseModel.sheredInstance.AllstudendsData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell") as UITableViewCell!
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName + " " + " #\(indexPath.row)"
        cell.detailTextLabel?.text = studentLocation.mapString
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = ParseModel.sheredInstance.AllstudendsData[indexPath.row]
        if let requestUrl = NSURL(string: studentLocation.mediaURL) {
            UIApplication.sharedApplication().openURL(requestUrl)
        } else {
            print("Error opening url: " + studentLocation.mediaURL)
            presentError("There was an error opening url: \(studentLocation.mediaURL)")
        }
    }
    



}

