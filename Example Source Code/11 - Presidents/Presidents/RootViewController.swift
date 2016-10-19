//
//  RootViewController.swift
//  Presidents
//
//  Created by Kim Topley on 10/17/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

class RootViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
        let splitVC = viewControllers[0]
        let newTraits = traitCollection
        if newTraits.horizontalSizeClass == .Compact
                && newTraits.verticalSizeClass == .Compact {
            let childTraits = UITraitCollection(horizontalSizeClass: .Regular)
            setOverrideTraitCollection(childTraits, forChildViewController: splitVC)
        } else {
            setOverrideTraitCollection(nil, forChildViewController: splitVC)
        }
    }
}
