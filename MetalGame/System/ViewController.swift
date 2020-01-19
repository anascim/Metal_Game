//
//  GameViewController.swift
//  MetalGame
//
//  Created by Alex Nascimento on 06/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import UIKit
import MetalKit


class ViewController: UIViewController {

    var renderer: Renderer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let mtkView = view as? MTKView else {
            print("View is not an MTKView!")
            return
        }
        
        guard let defaultDevice = MTLCreateSystemDefaultDevice() else {
            print("Metal not supported!")
            return
        }
        
        mtkView.device = defaultDevice
        mtkView.colorPixelFormat = .bgra8Unorm
        mtkView.depthStencilPixelFormat = .depth32Float
        mtkView.backgroundColor = .white
        
        renderer = Renderer(mtkView: mtkView)
        mtkView.delegate = renderer
    }
}
