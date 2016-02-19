//
//  HouseView.swift
//  SuumoKit
//
//  Created by NarimasaIwabuchi on 2016/02/17.
//  Copyright © 2016年 Nari. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SwiftyJSON
import CoreMotion

class HouseView: UIView , SCNSceneRendererDelegate{
    private var currentRoom = ""
    private var json = JSON(data: NSData())
    private var roomView = RoomView()
    private  let motionManager = CMMotionManager()
    
    override init(frame: CGRect) {
        super.init(frame: frame == CGRectZero ? CGRectMake(0, 0, 100, 100) : frame)
        if frame != CGRectZero {
            setup()
            setupMotion()
        }
    }
    
    func setupMotion(){
        motionManager.accelerometerUpdateInterval = 0.001
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            let currentAttitude = motion!.attitude
                
            let roll = Float(currentAttitude.roll)
            let pitch = Float(currentAttitude.pitch)
            let yaw = Float(currentAttitude.yaw)

            self.roomView.cameraRollNode.eulerAngles = SCNVector3Make(0.0, 0.0, -roll)
            self.roomView.cameraPitchNode.eulerAngles = SCNVector3Make(pitch, 0.0, 0.0)
            self.roomView.cameraYawNode.eulerAngles = SCNVector3Make(0.0, yaw, 0.0)
        }
    }
    
    func setup(){
        let path : String = NSBundle.mainBundle().pathForResource("rooms", ofType: "json")!
        let fileHandle = NSFileHandle(forReadingAtPath: path)
        json = JSON(data: fileHandle!.readDataToEndOfFile())
        changeRoom(String(json["start"]), lookatX: 0)
    }
    
    func changeRoom(roomName: String, lookatX: CGFloat) {
        roomView.delegate = nil
        roomView.removeFromSuperview()
        currentRoom = roomName
        roomView = RoomView(frame: self.frame, info: json, roomName: currentRoom, lookatX: lookatX)
        roomView.parentView = self
        roomView.delegate = self
        self.addSubview(roomView)
    }

    func changeFrame(frame: CGRect){
        roomView.frame = frame
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}