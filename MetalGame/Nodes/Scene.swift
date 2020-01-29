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
    var nodes = [Node]()
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
    }
    
    func addChild(_ node: Node) {
        nodes.append(node)
    }
    
    func removeChild(_ node: Node) {
        if let index = nodes.firstIndex(of: node) {
            nodes.remove(at: index)
        } else {
            print("Scene:removeChild() no index found for the node!")
        }
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        nodes.forEach { $0.renderable?.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time) }
    }
    
    func touchBegan(location: CGPoint) {
        
    }
    
    func touchMove(location: CGPoint) {
        
    }
    
    func touchEnded(location: CGPoint) {
        
    }
}
