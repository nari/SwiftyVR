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
    var postion = SCNVector3(0, 0, 9)
    init(position: SCNVector3) {
        super.init()
        self.position = position
        create_door()
    }
    
    override init() {
        super.init()
        create_door()
    }
    
    func create_door(){
        self.geometry = SCNCylinder(radius: 0.5, height: 0.1)
        self.position = SCNVector3(0, 4, 9)
        let door = SCNMaterial()
        door.diffuse.contents = UIImage(named:"door.png")
        self.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1, 0, 0)
        self.rotation = SCNVector4(x: 0, y: 0, z: 1, w: Float(M_PI / 2))
        self.geometry!.firstMaterial = door
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

