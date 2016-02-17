//
//  GameViewController.swift
//  SuumoKit
//
//  Created by NarimasaIwabuchi on 2016/02/03.
//  Copyright (c) 2016年 Nari. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SwiftyJSON

class SuumoViewController: UIViewController {
    var houseView = HouseView()
    private var currentRoom = ""
    private var json = JSON(data: NSData())
    private var roomView = RoomView(frame: CGRectMake(0, 0, 5, 5))
    override func viewDidLoad() {
        super.viewDidLoad()
        houseView = HouseView(frame: self.view.frame)
        self.view.addSubview(houseView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
        
    func onOrientationChange(notification: NSNotification){
        houseView.changeFrame(self.view.frame)
        
    }
}