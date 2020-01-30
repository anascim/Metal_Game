//
//  Scene.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

/// Scene serves as the root node although it isn't one.
/// Every node has a parent and if it is removed from that parent, ARC deinitializes it.

class Scene :  Renderable {
    
    var device: MTLDevice
    var view: MTKView
    var rootNode = Node()
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
    }
    
    func update() {}
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        update()
        rootNode.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
    }
    
    func touchBegan(location: CGPoint) {
        
    }
    
    func touchMoved(location: CGPoint) {
        
    }
    
    func touchEnded(location: CGPoint) {
        
    }
}
