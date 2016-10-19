//
//  ViewController.swift
//  Core Data Persistence
//
//  Created by Kim Topley on 10/26/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    private static let lineEntityName = "Line"
    private static let lineNumberKey = "lineNumber"
    private static let lineTextKey = "lineText"
    @IBOutlet var lineFields:[UITextField]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let appDelegate =
                    UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        let request = NSFetchRequest(entityName: ViewController.lineEntityName)
        
        do {
            let objects = try context.executeFetchRequest(request)
            for object in objects {
                let lineNum =
                    object.valueForKey(ViewController.lineNumberKey)!.integerValue
                let lineText = object.valueForKey(ViewController.lineTextKey) as? String ?? ""
                let textField = lineFields[lineNum]
                textField.text = lineText
            }
            
            let app = UIApplication.sharedApplication()
            NSNotificationCenter.defaultCenter().addObserver(self,
                            selector: "applicationWillResignActive:",
                            name: UIApplicationWillResignActiveNotification,
                            object: app)
       } catch {
            // Error thrown from executeFetchRequest()
            print("There was an error in executeFetchRequest(): \(error)")
       }
    }

    func applicationWillResignActive(notification:NSNotification) {
        let appDelegate =
            UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext
        for var i = 0; i < lineFields.count; i++ {
            let textField = lineFields[i]
            
            let request = NSFetchRequest(entityName: ViewController.lineEntityName)
            let pred = NSPredicate(format: "%K = %d", ViewController.lineNumberKey, i)
            request.predicate = pred
            
            do {
                let objects = try context.executeFetchRequest(request)
                var theLine:NSManagedObject! = objects.first as? NSManagedObject
                if theLine == nil {
                    // No existing data for this row – insert a new managed object for it
                    theLine =
                        NSEntityDescription.insertNewObjectForEntityForName(
                                ViewController.lineEntityName,
                                inManagedObjectContext: context)
                                as NSManagedObject
                }
            
                theLine.setValue(i, forKey: ViewController.lineNumberKey)
                theLine.setValue(textField.text, forKey: ViewController.lineTextKey)
            } catch {
                print("There was an error in executeFetchRequest(): \(error)")
            }
        }
        appDelegate.saveContext()
    }
}

