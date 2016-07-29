//
//  ViewController.swift
//  WWSuspendedBall
//
//  Created by wuwei on 16/7/29.
//  Copyright © 2016年 wuwei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGrayColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func safsff(sender: AnyObject) {
        
        let _ = IMOSuspendedBallView.init(frame: CGRectMake(0, 0, 0, 0))
        
    }
}

