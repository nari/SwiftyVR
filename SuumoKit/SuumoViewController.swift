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
    override func viewDidLoad() {
        super.viewDidLoad()
        let rv = RoomView(frame: self.view.frame)
        self.view.addSubview(rv)
    }
}