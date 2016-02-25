//
//  DoorView.swift
//  SuumoKit
//
//  Created by NarimasaIwabuchi on 2016/02/16.
//  Copyright © 2016年 Nari. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit

class DoorNode: SCNNode {
    internal var roomName = ""
    internal var lookatX = Float(0)
    init(point: SCNVector3){
        super.init()
        self.position = point
        createDoor()
    }
    
    override init() {
        super.init()
        self.position = SCNVector3(0, 0, 9)
        createDoor()
    }
    
//    ドアを作成
    func createDoor(){
        let plane = SCNPlane(width: 1.5, height: 1.5)
        plane.cornerRadius = 0.75
        self.geometry = plane
        let door = SCNMaterial()
        door.diffuse.contents = UIImage(named:"door.png")
        door.doubleSided = true
        self.geometry!.firstMaterial = door
    }
    
    func rotate(value: Float){
        self.rotation = SCNVector4(x:0, y:1, z:0, w: value)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

