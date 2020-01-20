//
//  Cube.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class Cube {
    
    var device: MTLDevice
    var view: MTKView
    var pipelineState: MTLRenderPipelineState!
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var vertices: [Vertex]!
    var indices: [UInt16]!
    var modelUniforms: Uniforms?
    
    init(device: MTLDevice, mtkView: MTKView) {
        self.device = device
        self.view = mtkView
        buildVertices()
        buildBuffers()
    }
    
    func buildBuffers() {
        if let newVertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: .cpuCacheModeWriteCombined) {
            vertexBuffer = newVertexBuffer
        } else { fatalError("Couldn't make vertex buffer!") }
        
        if let newIndexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<UInt16>.stride * indices.count, options: .cpuCacheModeWriteCombined) {
            indexBuffer = newIndexBuffer
        } else { fatalError("Couldn't make index buffer!") }
    }
    
    func buildVertices() {
        self.vertices = [
              Vertex(position: [-1.0, -1.0, 1.0], color: [0.0, 0.0, 1.0, 1.0]),
              Vertex(position: [-1.0,  1.0, 1.0], color: [0.0, 1.0, 1.0, 1.0]),
              Vertex(position: [-1.0, -1.0,-1.0], color: [1.0, 0.0, 1.0, 1.0]),
              Vertex(position: [-1.0,  1.0,-1.0], color: [1.0, 1.0, 1.0, 1.0]),
              Vertex(position: [ 1.0, -1.0, 1.0], color: [0.0, 0.0, 0.0, 1.0]),
              Vertex(position: [ 1.0,  1.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]),
              Vertex(position: [ 1.0, -1.0,-1.0], color: [1.0, 0.0, 0.0, 1.0]),
              Vertex(position: [ 1.0,  1.0,-1.0], color: [1.0, 1.0, 0.0, 1.0])
          ]
        
        self.indices = [
              0, 1, 2, 1, 3, 2,
              3, 6, 2, 3, 7, 6,
              7, 4, 6, 7, 5, 4,
              5, 0, 4, 5, 1, 0,
              1, 5, 7, 1, 7, 3,
              2, 6, 4, 2, 4, 0
          ]
    }
    
//    public func render(commandEncoder: MTLRenderCommandEncoder, mvpMatrix: matrix_float4x4) {
//
//        modelUniforms?.modelViewProjectionMatrix = mvpMatrix
//
//        commandEncoder.setRenderPipelineState(pipelineState)
//        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
//        commandEncoder.setVertexBytes(&modelUniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
//        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
//    }
}
