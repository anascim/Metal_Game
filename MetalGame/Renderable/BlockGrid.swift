//
//  BlockGrid.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

// This class is used to render a block grid on the screen.
// The position of the blocks is dictated by the modelMatrix sent by uniform data.
// The BlockGrid position represents its top-left corner, rendering the blocks from there.

class BlockGrid : Renderable {
    
    let device: MTLDevice
    var position: float3
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var uniforms: Uniforms!
    var gridLayout: (UInt16, UInt16)
    var geometry: Cube
    
    init(device: MTLDevice, position: float3) {
        self.device = device
        self.position = position
        self.gridLayout = (8, 16)
        self.geometry = Cube()
        self.buildBuffers()
    }
    
    private func buildBuffers() {
        let vertices = geometry.vertices
        let indices = geometry.indices
        
        if let buffer = device.makeBuffer(bytes: vertices,
                          length: MemoryLayout<Vertex>.stride * vertices.count,
                          options: .cpuCacheModeWriteCombined) {
            vertexBuffer = buffer
        } else { fatalError("BlockGrid:buildBuffers Couldn't make buffer!") }
        if let buffer = device.makeBuffer(bytes: indices,
                                          length: MemoryLayout<UInt16>.stride * indices.count,
                                          options: .cpuCacheModeWriteCombined) {
            indexBuffer = buffer
        } else { fatalError("BlockGrid:buildBuffers Couldn't make buffer!") }
    }
    
    public func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: matrix_float4x4) {
        
        // select block
        for row in 0..<gridLayout.1 {
            for col in 0..<gridLayout.0 {
                
                // ---------------
                // Update uniforms
                // ---------------
                
                // position on the grid
                let translation = matrix_float4x4(translationBy: [Float(col) * 2.5 - 9, Float(row) * -2.5  + 30, 0])
                
                // scale to become more rectangular
                let scale1 = matrix_float4x4(scaleBy: 0.1)
                let scale2 = matrix_float4x4(scaleBy: [1.618, 1, 1]) // golden ration
                let scale = scale1 * scale2
                
                let modelMatrix = scale * translation // scale and then translate
                let mvpMatrix = viewProjectionMatrix * modelMatrix
                uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
                
                // -----------
                // Render pass
                // -----------
                
                commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
                commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
                commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: geometry.indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
                
            }
        }
        
    }
}

