//
//  Scene.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class Scene : Node, Renderable {
    
    var nodes = [Node]()
    
    init(device: MTLDevice, view: MTKView) {
        super.init()
        
    }
    
    func addChild(_ node: Node) {
        node.parent = self
        nodes.append(node)
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        nodes.forEach { $0.renderable?.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time) }
    }
}
