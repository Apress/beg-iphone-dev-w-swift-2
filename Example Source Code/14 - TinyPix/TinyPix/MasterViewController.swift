//
//  MasterViewController.swift
//  TinyPix
//
//  Created by Kim Topley on 10/28/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController {
    @IBOutlet var colorControl: UISegmentedControl!
    private var documentFileURLs: [NSURL] = []
    private var chosenDocument: TinyPixDocument?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let addButton = UIBarButtonItem(
                barButtonSystemItem: UIBarButtonSystemItem.Add,
                target: self, action: "insertNewObject")
        navigationItem.rightBarButtonItem = addButton
        
        let prefs = NSUserDefaults.standardUserDefaults()
        let selectedColorIndex = prefs.integerForKey("selectedColorIndex")
        setTintColorForIndex(selectedColorIndex)
        colorControl.selectedSegmentIndex = selectedColorIndex
        
        reloadFiles()
    }
    
    private func urlForFileName(fileName: String) -> NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(
            .DocumentDirectory, inDomains: .UserDomainMask)
        return urls.first!.URLByAppendingPathComponent(fileName)
    }
    
    private func reloadFiles() {
        let fm = NSFileManager.defaultManager()
        let documentsURL = fm.URLsForDirectory(
                  .DocumentDirectory, inDomains: .UserDomainMask).first!
        do {
            let fileURLs = try fm.contentsOfDirectoryAtURL(documentsURL,
                                    includingPropertiesForKeys: nil, options: [])
            let sortedFileURLs = fileURLs.sort() { file1URL, file2URL in
                let attr1 = try! fm.attributesOfItemAtPath(file1URL.path!)
                let attr2 = try! fm.attributesOfItemAtPath(file2URL.path!)
                let file1Date = attr1[NSFileCreationDate] as! NSDate
                let file2Date = attr2[NSFileCreationDate] as! NSDate
                let result = file1Date.compare(file2Date)
                return result == NSComparisonResult.OrderedAscending
            }
            
            documentFileURLs = sortedFileURLs
            tableView.reloadData()
        } catch {
            print("Error listing files in directory \(documentsURL.path!): \(error)")
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentFileURLs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath
                            indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("FileCell")!
        let fileURL = documentFileURLs[indexPath.row]
        cell.textLabel!.text = fileURL.URLByDeletingPathExtension!.lastPathComponent
        return cell
    }
    
    @IBAction func chooseColor(sender: UISegmentedControl) {
        let selectedColorIndex = sender.selectedSegmentIndex
        setTintColorForIndex(selectedColorIndex)
            
        let prefs = NSUserDefaults.standardUserDefaults()
        prefs.setInteger(selectedColorIndex, forKey: "selectedColorIndex")
        prefs.synchronize()
    }
    
    private func setTintColorForIndex(colorIndex: Int) {
        colorControl.tintColor = TinyPixUtils.getTintColorForIndex(colorIndex)
    }
    
    func insertNewObject() {
        let alert = UIAlertController(title: "Choose File Name",
                    message: "Enter a name for your new TinyPix document",
                    preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler(nil)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let createAction = UIAlertAction(title: "Create", style: .Default) { action in
            let textField = alert.textFields![0] as UITextField
            self.createFileNamed(textField.text!)
        };
        
        alert.addAction(cancelAction)
        alert.addAction(createAction)
        
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func createFileNamed(fileName: String) {
        let trimmedFileName = fileName.stringByTrimmingCharactersInSet(
            NSCharacterSet.whitespaceCharacterSet())
         if !trimmedFileName.isEmpty {
            let targetName = trimmedFileName + ".tinypix"
            let saveUrl = urlForFileName(targetName)
            chosenDocument = TinyPixDocument(fileURL: saveUrl)
            chosenDocument?.saveToURL(saveUrl,
                    forSaveOperation: UIDocumentSaveOperation.ForCreating,
                    completionHandler: { success in
                if success {
                    print("Save OK")
                    self.reloadFiles()
                    self.performSegueWithIdentifier("masterToDetail", sender: self)
                } else {
                    print("Failed to save!")
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destination =
            segue.destinationViewController as! UINavigationController
        let detailVC =
            destination.topViewController as! DetailViewController
            
        if sender === self {
            // if sender === self, a new document has just been created,
            // and chosenDocument is already set.
            detailVC.detailItem = chosenDocument
        } else {
            // Find the chosen document from the tableview
            if let indexPath = tableView.indexPathForSelectedRow {
                let docURL = documentFileURLs[indexPath.row]
                chosenDocument = TinyPixDocument(fileURL: docURL)
                chosenDocument?.openWithCompletionHandler() { success in
                    if success {
                        print("Load OK")
                        detailVC.detailItem = self.chosenDocument
                    } else {
                        print("Failed to load!")
                    }
                }
            }
        }
    }
}

