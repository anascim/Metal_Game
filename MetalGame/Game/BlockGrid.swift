//
//  BlockGrid.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

/// This class is used to render a block grid on the screen.
/// The position of the blocks is dictated by the modelMatrix sent by uniform data.
/// The BlockGrid position represents its top-left corner, rendering the blocks from there.

class BlockGrid : Renderable {
    
    var device: MTLDevice
    var cubeVBO: VertexBufferDelegate?
    var uniforms: Uniforms!
    
    var position: float3
    var gridLayout: (UInt16, UInt16)
    var blockWidth: Float
    var blockHeight: Float
    
    init(device: MTLDevice, position: float3) {
        self.device = device
        self.position = position
        self.blockWidth = 0.4
        self.blockHeight = 0.2
        self.gridLayout = (7, 16)
    }
    
    public func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        guard let delegate = cubeVBO else { return }
        
        commandEncoder.setVertexBuffer(delegate.vertexBuffer, offset: 0, index: 0)
        for row in 0..<gridLayout.1 {
            for col in 0..<gridLayout.0 {
                
                // ---------------
                // Update uniforms
                // ---------------
                
                // scale to become more rectangular
                let scale = float4x4(scaleBy: [blockWidth/2, blockHeight/2, blockHeight/2])
                
                // position on the grid
                let translation = float4x4(translationBy: [Float(col) * blockWidth + position[0], Float(row) * -blockHeight + position[1], 0])
                
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
    }
}

