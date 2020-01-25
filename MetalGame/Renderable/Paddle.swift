//
//  Padle.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class Paddle : Renderable {
    
    var uniforms: Uniforms!
    var xPosition: Float = 0
    var delegate: VertexBufferDelegate?
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        guard let delegate = delegate else { return }
        
        let scale = float4x4(scaleBy: [0.4, 0.1, 0.1])
        
        let translation = float4x4(translationBy: [0,-3,0])
        
        let modelMatrix = translation * scale // scale and then translate
        let mvpMatrix = viewProjectionMatrix * modelMatrix
        uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
        
        // -----------
        // Render pass
        // -----------
        
        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: delegate.indices.count, indexType: .uint16, indexBuffer: delegate.indexBuffer, indexBufferOffset: 0)
    }
}
