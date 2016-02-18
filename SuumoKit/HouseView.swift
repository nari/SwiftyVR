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

class HouseView: UIView , SCNSceneRendererDelegate{
    private var currentRoom = ""
    private var json = JSON(data: NSData())
    private var roomView = RoomView()
    private var motionControl = false
    
    override init(frame: CGRect) {
        super.init(frame: frame == CGRectZero ? CGRectMake(0, 0, 100, 100) : frame)
        setup()
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
        roomView.isMotion = self.motionControl
        self.addSubview(roomView)
    }

    func changeFrame(frame: CGRect, isMotion: Bool){
        roomView.frame = frame
        roomView.isMotion = isMotion
        self.motionControl = isMotion
        self.frame = frame
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}