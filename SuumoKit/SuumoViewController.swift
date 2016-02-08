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

class SuumoViewController: UIViewController {

    private let cameraNode = SCNNode()
    private var pointBefore = CGPointZero
    private var lotateX: Float = 0.0
    private var lotateY: Float = 0.0
    private var tubeNode = SCNNode()
    private var pixelWidth: CGFloat = 0
    private var pixelHeight: CGFloat = 0
    private let accuracy: Float = Float(M_PI*2) / 1000.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        pixelWidth = UIScreen.mainScreen().bounds.width / 1125
        pixelHeight = UIScreen.mainScreen().bounds.height / 2001
        let scene = SCNScene()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        let height = CGFloat(150)
        let width = CGFloat(50)
        
//        let tubeGeometry = SCNTube(innerRadius: width, outerRadius: width, height: height)
//        tubeNode = SCNNode(geometry: tubeGeometry)
//        tubeNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
//        tubeNode.pivot = SCNMatrix4MakeRotation(Float(M_PI_2), 1, 0, 0)
//        
//        tubeGeometry.firstMaterial?.diffuse.contents = UIImage(named: "01.jpg")
//        scene.rootNode.addChildNode(tubeNode)
        
        let tubeGeometry = SCNSphere(radius: 10.0)
        tubeNode = SCNNode(geometry: tubeGeometry)
        tubeNode.position = SCNVector3(x: 0.0, y: 0.0, z: 0.0)
        
        tubeGeometry.firstMaterial?.diffuse.contents = UIImage(named: "01.jpg")
        tubeGeometry.firstMaterial?.doubleSided = true
        tubeGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(-1,1,1);
        tubeGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        
        scene.rootNode.addChildNode(tubeNode)
        
        
        cameraNode.position = SCNVector3(x:0, y:0, z: 0)
        
        let scnView = self.view as! SCNView
        scnView.scene = scene
        scnView.allowsCameraControl = false
        scnView.backgroundColor = UIColor.grayColor()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        pointBefore = (touch?.locationInView(self.view))!
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {                let touch = touches.first
        let pointNow = (touch?.locationInView(self.view))!
        let pointDiff = CGPointMake(pointNow.x - pointBefore.x, pointNow.y - pointBefore.y)
        
        lotateX = (accuracy * Float(pointDiff.x) + lotateX) % Float(M_PI*2)
        tubeNode.rotation = SCNVector4(x:0, y:-1, z:0, w: lotateX)
        
        lotateY = (accuracy * Float(pointDiff.y) + lotateY)
        cameraNode.rotation = SCNVector4(x:1, y:0, z:0, w: lotateY)
        
        print(lotateX)
        print(lotateY)
        
        pointBefore = pointNow
    }

}