//
//  ViewController.swift
//  MetalGame
//
//  Created by Alex Nascimento on 06/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import UIKit
import MetalKit


class ViewController: UIViewController {

    var renderer: Renderer!
    var mtkView: MTKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = view as? MTKView else {
            print("View is not an MTKView!")
            return
        }
        self.mtkView = mtkView
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal not supported!")
            return
        }
        
        print("atan2f(1,0): \(atan2f(1, 0))")
        print("atan2f(0,1): \(atan2f(0, 1))")
        print("atan2f(-1,0): \(atan2f(-1, 0))")
        print("atan2f(0,-1): \(atan2f(0, -1))")
        
        mtkView.device = defaultDevice
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        mtkView.backgroundColor = .white
        
        renderer = Renderer(mtkView: mtkView)
        mtkView.delegate = renderer
        renderer.scene = BreakoutScene(device: defaultDevice, view: mtkView)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.scene?.touchBegan(location: touches.first!.location(in: mtkView))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer.scene?.touchMoved(location: touches.first!.location(in: mtkView))
    }
}
