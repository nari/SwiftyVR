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
    private var tapStart = CGPointZero // タップし始めた座標
    private var sphereNode = SCNNode() // 球のノード
    private var imageSize = CGSizeZero // 画像のサイズ
    private var ImageName = "" // 画像の名前
    private var initCameraX = CGFloat(0) // 最初のカメラのx座標
    private let radiusSphere = CGFloat(10) // 球の半径
    private var pointDistance = CGFloat(9.0) // ドアとの半径
    internal let camerasNode = SCNNode() // カメラを司るノード
    internal var cameraRollNode = SCNNode() // X回転を司るノード
    internal var cameraYawNode = SCNNode() // Y回転を司るノード
    internal var cameraPitchNode = SCNNode() // Z回転を司るノード
    internal var parentView = UIView() // HouseView
    
    init(frame: CGRect, info: JSON, roomName: String, lookatX: Float) {
        super.init(frame: frame == CGRectZero ? CGRectMake(0, 0, 1, 1) : frame)
//        json parse
        imageSize = CGSizeMake(CGFloat(info["rooms"][roomName]["image"]["width"].intValue), CGFloat(info["rooms"][roomName]["image"]["height"].intValue))
        ImageName = info["rooms"][roomName]["image"]["src"].string!
        setup()
        if let points = info["rooms"][roomName]["points"].array {
            setupDoor(points)
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
        
//        Setting Camera
        let camera = SCNCamera()
        camera.xFov = 80
        camera.yFov = 80
        camerasNode.camera = camera
        camerasNode.eulerAngles = SCNVector3Make(-Float(M_PI_2), 0, 0)
        cameraRollNode.addChildNode(camerasNode)
        cameraPitchNode.addChildNode(cameraRollNode)
        cameraYawNode.addChildNode(cameraPitchNode)
        scene.rootNode.addChildNode(cameraYawNode)
        
//        Setting Geometry for Background
        let sphereGeometry = SCNSphere(radius: radiusSphere)
        sphereNode = SCNNode(geometry: sphereGeometry)
        
//        Setting BackGround
        sphereGeometry.firstMaterial?.diffuse.contents = UIImage(named: ImageName)
        sphereGeometry.firstMaterial?.doubleSided = true
        sphereGeometry.firstMaterial?.diffuse.contentsTransform = SCNMatrix4MakeScale(-1, 1 ,1);
        sphereGeometry.firstMaterial?.diffuse.wrapS = SCNWrapMode.Repeat
        scene.rootNode.addChildNode(sphereNode)
        
        self.scene = scene
        self.allowsCameraControl = false
        self.backgroundColor = UIColor.clearColor()
    }
    
    func setupDoor(points: [JSON]){
        for var index:Int = 0 ; index < points.count ;index += 1{
            addDoor(Float(points[index]["x"].intValue), y: Float(points[index]["y"].intValue), lookatX: Float(points[index]["lookat_x"].intValue), name: points[index]["room"].string!)
        }
    }
    
//    球をradianだけ回転させる
    func rotateSphere(radian: Float){
        sphereNode.rotation = SCNVector4(0, 1, 0, radian)
    }
    
//    ドア画像を追加、カメラの方向に回転
    func addDoor(x: Float, y: Float, lookatX: Float, name: String){
        let angle = (x / Float(imageSize.width) * 360.0 + 180)
        let rad = M_PI * Double(angle) / 180.0
        let nx = (pointDistance) * CGFloat(cos(rad))
        let ny = (pointDistance) * CGFloat(sin(rad))
        let door = DoorNode(point: SCNVector3(-ny, 0, nx))
        door.roomName = name
        door.lookatX = lookatX
        sphereNode.addChildNode(door)
        door.rotation = SCNVector4(x: 0, y: -1, z: 0, w: Float(convertXtoRadian(x + Float(imageSize.width/2) )))
    }
    
//    画像の大きさとx座標からradianに変換
    func convertXtoRadian(x: Float)-> Float {
        return (x / Float(imageSize.width) * Float(M_PI*2))
    }
    
//    タッチし始めた
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        tapStart = (touch?.locationInView(self))!
    }

//    タッチし終わった
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        let touch = touches.first
        let point = (touch?.locationInView(self))!
        if point == tapStart {
            let hits = self.hitTest(point, options: nil)
            if hits.count < 2 {return}
            if let door = hits[0].node as? DoorNode {
                (self.parentView as! HouseView).changeRoom(door.roomName, lookatX: door.lookatX)
            }
        }
    }

}