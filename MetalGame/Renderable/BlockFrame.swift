//
//  BlockFrame.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//
import MetalKit

/// This class is used to draw a frame on the screen composed of 4 alongated cubes.
/// The position is its center while the size dictates its width and height respectively

class BlockFrame : Renderable {
    
    let device: MTLDevice
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var uniforms: Uniforms!
    let geometry: Cube
    
    /// The center of the frame, defaluts to [0,0,0]
    var position: float3
    
    /// The size of the frame: [width, height]
    var size: float2
    
    init(device: MTLDevice, position: float3 = [0,0,0], size: float2) {
        self.device = device
        self.position = position
        self.size = size
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
        
        let modelMatrix1 = float4x4(translationBy: [0,size[1]/2,0]) * float4x4(scaleBy: [100, 0.05, 0.05])
        let modelMatrix2 = float4x4(translationBy: [0,-size[1]/2,0]) * float4x4(scaleBy: [100, 0.05, 0.05])
        let modelMatrix3 = float4x4(translationBy: [-size[0]/2,0,0]) * float4x4(scaleBy: [0.05, 100, 0.05])
        let modelMatrix4 = float4x4(translationBy: [size[0]/2,0,0]) * float4x4(scaleBy: [0.05, 100, 0.05])
        let modelMtxs = [modelMatrix1, modelMatrix2, modelMatrix3, modelMatrix4]
        
        for m in modelMtxs {
            let mvpMatrix = viewProjectionMatrix * m// scale and then translate
            uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
            
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
            commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: geometry.indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
        }
    }
}

