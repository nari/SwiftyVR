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

class HouseView: UIView{
    private var currentRoom = ""
    private var json = JSON(data: NSData())
    private var roomView = RoomView()
    private let motionManager = CMMotionManager()
    private var beforeYow = Float(0)
    private var quaternion = CMQuaternion()
    
    override init(frame: CGRect) {
//        sceneViewは1px以上確保する必要があるため
        super.init(frame: frame == CGRectZero ? CGRectMake(0, 0, 1, 1) : frame)
        if frame != CGRectZero {
            setup()
            setupMotion()
        }
    }
    
//    デバイスモーションを設定する
    func setupMotion(){
        motionManager.accelerometerUpdateInterval = 0.001
        motionManager.startDeviceMotionUpdatesToQueue(NSOperationQueue.mainQueue()) { (motion: CMDeviceMotion?, error: NSError?) -> Void in
            let currentAttitude = motion!.attitude
            self.quaternion = currentAttitude.quaternion
            let roll = Float(currentAttitude.roll)
            let pitch = Float(currentAttitude.pitch)
            let yaw = Float(currentAttitude.yaw)

            self.roomView.cameraRollNode.eulerAngles = SCNVector3Make(0.0, 0.0, -roll)
            self.roomView.cameraPitchNode.eulerAngles = SCNVector3Make(pitch, 0.0, 0.0)
            self.roomView.cameraYawNode.eulerAngles = SCNVector3Make(0.0, yaw, 0.0)
        }
    }
    
//    一番初めのセットアップ
    func setup(){
        let path : String = NSBundle.mainBundle().pathForResource("rooms", ofType: "json")!
        let fileHandle = NSFileHandle(forReadingAtPath: path)
        json = JSON(data: fileHandle!.readDataToEndOfFile())
        changeRoom(String(json["start"]), lookatX: 0)
    }
    
//    部屋を変える
    func changeRoom(roomName: String, lookatX: Float) {
        self.convertAngle(self.roomView.cameraRollNode.eulerAngles.z, yaw: self.roomView.cameraYawNode.eulerAngles.y, pitch: self.roomView.cameraPitchNode.eulerAngles.x)
        roomView.removeFromSuperview()
        currentRoom = roomName
        roomView = RoomView(frame: self.frame, info: json, roomName: currentRoom, lookatX: lookatX)
        roomView.parentView = self
        roomView.rotateSphere(beforeYow)
        self.addSubview(roomView)
    }
    
//    縦横のカメラの部屋移動の誤差吸収
    func convertAngle(roll: Float, yaw: Float, pitch: Float){
        let c_pitch = pitch * 180.0 / Float(M_PI_2)
        let c_yaw = yaw * (c_pitch / 180.0) + ((180 - c_pitch) / 180) * roll
//        let c_roll = roll * (c_pitch / 180.0) + ((180 - c_pitch) / 180) * yaw
        if quaternion.y < 0 {
            beforeYow = c_yaw
        }else{
            beforeYow = c_yaw
        }
    }

//    画面ロック外したときに画面回転したときの設定
    func changeFrame(frame: CGRect){
        roomView.frame = frame
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}