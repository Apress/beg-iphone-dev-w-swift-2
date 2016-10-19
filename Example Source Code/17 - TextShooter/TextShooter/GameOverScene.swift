//
//  GameOverScene.swift
//  TextShooter
//
//  Created by Kim Topley on 11/11/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene {
    
    override init(size: CGSize) {
        super.init(size: size)
        backgroundColor = SKColor.purpleColor()
        let text = SKLabelNode(fontNamed: "Courier")
        text.text = "Game Over"
        text.fontColor = SKColor.whiteColor()
        text.fontSize = 50
        text.position = CGPointMake(frame.size.width/2, frame.size.height/2)
        addChild(text)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToView(view: SKView) {
        dispatch_after(
            dispatch_time(DISPATCH_TIME_NOW, 3 * Int64(NSEC_PER_SEC)),
            dispatch_get_main_queue()) {
                let transition = SKTransition.flipVerticalWithDuration(1)
                let start = StartScene(size: self.frame.size)
                view.presentScene(start, transition: transition)
            }
    }

}
