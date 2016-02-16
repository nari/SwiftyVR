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

class RoomView: SCNView {
    private let cameraNode = SCNNode()
    private var pointBefore = CGPointZero
    private var lotateX: Float = 0.0
    private var lotateY: Float = 0.0
    private var sphereNode = SCNNode()
    private var pixelWidth: CGFloat = 0
    private var pixelHeight: CGFloat = 0
    private let accuracy: Float = Float(M_PI*2) / 1000.0
    
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
        pixelWidth = UIScreen.mainScreen().bounds.width / 1125
        pixelHeight = UIScreen.mainScreen().bounds.height / 2001
        let scene = SCNScene()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        let sphereGeometry = SCNSphere(radius: 10.0)
        sphereNode = SCNNode(geometry: sphereGeometry)
        sphereNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: "01.jpg")
        sphereGeometry.firstMaterial?.doubleSided = true
        sphereGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1 ,1);
        sphereGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        scene.rootNode.addChildNode(sphereNode)
        
        let doorNode = DoorNode()
        sphereNode.addChildNode(doorNode)
        
        cameraNode.position = SCNVector3(x:0, y:0, z: 0)
        
        self.scene = scene
        self.allowsCameraControl = false
        self.backgroundColor = UIColor.grayColor()
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