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

class HouseView: UIView {
    private var currentRoom = ""
    private var json = JSON(data: NSData())
    private var roomView = RoomView()
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
        currentRoom = roomName
        roomView.removeFromSuperview()
        roomView = RoomView(frame: self.frame, info: json, roomName: currentRoom, lookatX: lookatX)
        roomView.parentView = self
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