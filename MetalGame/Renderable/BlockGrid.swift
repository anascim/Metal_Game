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
    
    let device: MTLDevice
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var uniforms: Uniforms!
    var geometry: Cube
    
    var position: float3
    var gridLayout: (UInt16, UInt16)
    var blockPadding: Float
    
    init(device: MTLDevice, position: float3) {
        self.device = device
        self.position = position
        self.blockPadding = 0.5
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
    
    public func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        for row in 0..<gridLayout.1 {
            for col in 0..<gridLayout.0 {
                
                // ---------------
                // Update uniforms
                // ---------------
                
                // position on the grid
                let translation = float4x4(translationBy: [Float(col) * blockPadding + position[0], Float(row) * -blockPadding + position[1], 0])
                
                // scale to become more rectangular
                let scale1 = float4x4(scaleBy: 0.1)
                let scale2 = float4x4(scaleBy: [1.618, 1, 1])
                let scale = scale1 * scale2
                
                let modelMatrix = translation * scale // translate and then scale
                let mvpMatrix = viewProjectionMatrix * modelMatrix
                uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
                
                // -----------
                // Render pass
                // -----------
                
                commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
                commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: geometry.indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
            }
        }
        
    }
}

