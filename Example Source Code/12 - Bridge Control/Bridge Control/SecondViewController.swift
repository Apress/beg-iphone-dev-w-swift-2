//
//  SecondViewController.swift
//  Bridge Control
//
//  Created by Kim Topley on 10/18/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class SecondViewController: UIViewController {
    @IBOutlet var engineSwitch:UISwitch!
    @IBOutlet var warpFactorSlider:UISlider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func applicationWillEnterForeground(notification:NSNotification) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.synchronize()
        refreshFields()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onEngineSwitchTapped(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(engineSwitch.on, forKey: warpDriveKey)
        defaults.synchronize()
    }
    
    @IBAction func onWarpSliderDragged(sender: AnyObject) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(warpFactorSlider.value, forKey: warpFactorKey)
        defaults.synchronize()
    }
    
    @IBAction func onSettingsButtonTapped(sender: AnyObject) {
        UIApplication.sharedApplication().openURL(
            NSURL(string: UIApplicationOpenSettingsURLString)!)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        refreshFields()
        
        let app = UIApplication.sharedApplication()
        NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "applicationWillEnterForeground:",
                name: UIApplicationWillEnterForegroundNotification,
                object: app)
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
   
    func refreshFields() {
        let defaults = NSUserDefaults.standardUserDefaults()
        engineSwitch.on = defaults.boolForKey(warpDriveKey)
        warpFactorSlider.value = defaults.floatForKey(warpFactorKey)
    }
}

