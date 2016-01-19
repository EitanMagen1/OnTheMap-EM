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
               self.presentError("There was an error logging out. Please try again.\(errorString)")
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
            } else if errorString != nil {
               self.presentError("There was an error loading student locations.\(errorString)")
            }
        }
    }
    
    //MARK: Helpers
    
    //MARK: UITableViewDelegate protocol functions

    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationData.AllstudendsData.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let studentLocation = StudentLocationData.AllstudendsData[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("StudentLocationCell") as UITableViewCell!
        cell.textLabel?.text = studentLocation.firstName + " " + studentLocation.lastName + " " + " #\(indexPath.row)"
        cell.detailTextLabel?.text = studentLocation.mapString
        return cell
    }

    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let studentLocation = StudentLocationData.AllstudendsData[indexPath.row]
        if let requestUrl = NSURL(string: studentLocation.mediaURL) {
            UIApplication.sharedApplication().openURL(requestUrl)
        } else {
          self.presentError("There was an error opening url: \(studentLocation.mediaURL)")
        }
    }
    



}

