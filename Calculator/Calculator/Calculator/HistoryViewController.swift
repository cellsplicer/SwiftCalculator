//
//  HistoryViewController.swift
//  Calculator
//
//  Created by Ray Tran on 16/04/2015.
//  Copyright (c) 2015 Ray Tran. All rights reserved.
//

import UIKit
import Foundation

protocol HistoryViewControllerDelegate : class {
    func giveStringForIndex(index: Int) -> String
    func giveNumberOfRows() -> Int
}

class HistoryViewController : UIViewController, UITableViewDataSource, UITableViewDelegate
{
    @IBOutlet var tbView: UITableView!
 
    let textCellIdentifier = "TextCell"
    
    var historyViewControllerDelegate : HistoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tbView.delegate = self
        tbView.dataSource = self
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ( historyViewControllerDelegate != nil) {
            var numberOfRows = historyViewControllerDelegate!.giveNumberOfRows()
            return numberOfRows
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(textCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        let row = indexPath.row
        
        if(historyViewControllerDelegate != nil) {
            cell.textLabel?.text = historyViewControllerDelegate!.giveStringForIndex(indexPath.row)
        }

        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let row = indexPath.row
    }
}