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
    let path : String = NSBundle.mainBundle().pathForResource("rooms", ofType: "json")!
    var currentRoom = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let fileHandle = NSFileHandle(forReadingAtPath: path)
        let json = JSON(data: fileHandle!.readDataToEndOfFile())
        currentRoom = String(json["start"])
        let rv = RoomView(frame: self.view.frame, info: json, roomName: currentRoom, lookatX: 0)
        self.view.addSubview(rv)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "onOrientationChange:", name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    func onOrientationChange(notification: NSNotification){
        let deviceOrientation: UIDeviceOrientation!  = UIDevice.currentDevice().orientation
        if UIDeviceOrientationIsLandscape(deviceOrientation) {
            print("hoge")
        } else if UIDeviceOrientationIsPortrait(deviceOrientation){
        }
        
    }
}