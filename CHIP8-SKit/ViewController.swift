//
//  ViewController.swift
//  CHIP8-SKit
//
//  Created by Alin Baciu on 16/12/2017.
//  Copyright © 2017 Alin Baciu. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class ViewController: NSViewController{
    @IBOutlet var skView: SKView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameScene(size: view.bounds.size)
//        skView.showsFPS = true
//        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
}

