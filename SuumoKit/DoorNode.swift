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
    init(point: SCNVector3){
        super.init()
        self.position = point
        create_door()
    }
    
    override init() {
        super.init()
        self.position = SCNVector3(0, 0, 9)
        create_door()
    }
    
    func create_door(){
        self.geometry = SCNCylinder(radius: 0.5, height: 0.1)
        let door = SCNMaterial()
        door.diffuse.contents = UIImage(named:"door.png")
        self.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1, 0, 0)
        self.geometry!.firstMaterial = door
    }
    
    func rotate(value: Float){
        self.rotation = SCNVector4(x:0, y:1, z:0, w: value)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

