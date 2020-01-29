//
//  CubicBall.swift
//  MetalGame
//
//  Created by Alex Nascimento on 29/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class CubicBall : Renderable {
    
    var uniforms: Uniforms!
    var xPosition: Float = 0
    var yPosition: Float = -2
    var cubeVBO: VertexBufferDelegate?
    let radius: Float = 0.06
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        guard let delegate = cubeVBO else { return }
        
        // ------
        // Update
        // ------
        
        let scale = float4x4(scaleBy: [radius, radius, radius])
        
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
