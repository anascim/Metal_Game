//
//  BlockNode.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class BlockNode : Node, Renderable {
    
    var device: MTLDevice
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var uniforms: Uniforms!
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
    }
    
    init(device: MTLDevice) {
        self.device = device
        super.init()
        self.renderable = self
    }
}
