//
//  RoomView.swift
//  SuumoKit
//
//  Created by NarimasaIwabuchi on 2016/02/14.
//  Copyright © 2016年 Nari. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SwiftyJSON

class RoomView: SCNView {
    private let cameraNode = SCNNode()
    private var pointBefore = CGPointZero
    private var lotateX: Float = 0.0
    private var lotateY: Float = 0.0
    private var sphereNode = SCNNode()
    private let accuracy: Float = Float(M_PI*2) / 1000.0
    private var imageSize = CGSizeZero
    private var ImageName = ""
    private var initCameraX = CGFloat(0)
    private let radiusSphere = CGFloat(10)
    private var doors = [DoorNode]()
    private var pointDistance = CGFloat(9.0)
    
    init(frame: CGRect, info: JSON, roomName: String, lookatX: CGFloat) {
        super.init(frame: frame)
        imageSize = CGSizeMake(CGFloat(info["rooms"][roomName]["image"]["width"].intValue), CGFloat(info["rooms"][roomName]["image"]["height"].intValue))
        ImageName = info["rooms"][roomName]["image"]["src"].string!
        initCameraX = lookatX
        setup()
        if let points = info["rooms"][roomName]["points"].array {
            for var index:Int = 0 ; index < points.count ;index += 1{
                addDoor(CGFloat(points[index]["x"].intValue), y: CGFloat(points[index]["y"].intValue), lookatX: CGFloat(points[index]["lookat_x"].intValue), name: points[index]["room"].string!)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect, options: [String : AnyObject]?) {
        super.init(frame: frame, options: options)
    }
    
    
    func setup(){
        let scene = SCNScene()
        cameraNode.camera = SCNCamera()
//        cameraNode.position = SCNVector3(0, 0, 30)
        scene.rootNode.addChildNode(cameraNode)
        
        let sphereGeometry = SCNSphere(radius: radiusSphere)
        sphereNode = SCNNode(geometry: sphereGeometry)
        
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: ImageName)
        sphereGeometry.firstMaterial?.doubleSided = true
        sphereGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1 ,1);
        sphereGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        scene.rootNode.addChildNode(sphereNode)
        
//        init lotate camera
        lotateX = -Float(convertX(initCameraX))
        sphereNode.rotation = SCNVector4(x:0, y:-1, z:0, w: lotateX)
        
        self.scene = scene
        self.allowsCameraControl = false
        self.backgroundColor = UIColor.grayColor()
    }
    
    func addDoor(x: CGFloat, y: CGFloat, lookatX: CGFloat, name: String){
        var angle = (x / imageSize.width * 360.0 + 180)
//        angle = 90
        print(angle)
        let rad = M_PI * Double(angle) / 180.0
        let nx = (pointDistance) * CGFloat(cos(rad))
        let ny = (pointDistance) * CGFloat(sin(rad))
        let door = DoorNode(point: SCNVector3(-ny, 0, nx))
//        door.rotation = SCNVector4(0, 0, 1, convertX(x))
        sphereNode.addChildNode(door)
        door.rotation = SCNVector4(x: 0, y: -1, z: 0, w: Float(convertX(x+imageSize.width/2)))
    }
    
    func convertX(x: CGFloat)-> CGFloat {
        return (x / imageSize.width * CGFloat(M_PI*2))
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        pointBefore = (touch?.locationInView(self))!
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {                let touch = touches.first
        let pointNow = (touch?.locationInView(self))!
        let pointDiff = CGPointMake(pointNow.x - pointBefore.x, pointNow.y - pointBefore.y)
        
        lotateX = (accuracy * Float(pointDiff.x) + lotateX) % Float(M_PI*2)
        sphereNode.rotation = SCNVector4(x:0, y:-1, z:0, w: lotateX)
        
        lotateY = (accuracy * Float(pointDiff.y) + lotateY)
        cameraNode.rotation = SCNVector4(x:1, y:0, z:0, w: lotateY)
        pointBefore = pointNow
    }

}