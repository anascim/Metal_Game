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
    let yPosition: Float = -3
    var cubeVBO: VertexBufferDelegate?
    let width: Float = 0.8
    let height: Float = 0.2
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        guard let delegate = cubeVBO else { return }
        
        let scale = float4x4(scaleBy: [width/2, height/2, 0.1])
        
        let translation = float4x4(translationBy: [xPosition,yPosition,0])
        
        let modelMatrix = translation * scale // scale and then translate
        let mvpMatrix = viewProjectionMatrix * modelMatrix
        
        uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
        
        // -----------
        // Render pass
        // -----------
        
        commandEncoder.setVertexBuffer(delegate.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: delegate.indices.count, indexType: .uint16, indexBuffer: delegate.indexBuffer, indexBufferOffset: 0)
    }
}
