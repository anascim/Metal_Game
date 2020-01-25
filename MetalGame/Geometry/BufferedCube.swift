//
//  Cube.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

/// This is a convenience class for debugging,
/// the Cube class should be used instead

class BufferedCube : Geometry {
    
    var device: MTLDevice
    var vertexBuffer: MTLBuffer
    var indexBuffer: MTLBuffer
    var vertices: [Vertex]
    var indices: [UInt16]
    var position: float3
    
    init(device: MTLDevice, position: float3) {
        self.device = device
        self.position = position
        self.vertices = BufferedCube.buildVertices()
        self.indices = BufferedCube.buildIndices()
        self.vertexBuffer = BufferedCube.buildVertexBuffer(device, vertices)
        self.indexBuffer = BufferedCube.buildIndexBuffer(device, indices)
    }
    
    static func buildVertexBuffer(_ device: MTLDevice, _ vertices: [Vertex]) -> MTLBuffer {
        if let newVertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: .cpuCacheModeWriteCombined) {
            return newVertexBuffer
        } else { fatalError("Cube:buildBuffers: Couldn't make vertex buffer!") }
    }
    
    static func buildIndexBuffer(_ device: MTLDevice, _ indices: [UInt16]) -> MTLBuffer {
        if let newIndexBuffer = device.makeBuffer(bytes: indices, length: MemoryLayout<UInt16>.stride * indices.count, options: .cpuCacheModeWriteCombined) {
            return newIndexBuffer
        } else { fatalError("Cube:buildBuffers: Couldn't make index buffer!") }
    }
    
    static func buildVertices() -> [Vertex] {
        return [
            Vertex(position: [-1, 1, 1], color: [0,1,1,1]),
            Vertex(position: [-1,-1, 1], color: [0,0,1,1]),
            Vertex(position: [ 1,-1, 1], color: [1,0,1,1]),
            Vertex(position: [ 1, 1, 1], color: [1,1,1,1]),
            Vertex(position: [-1, 1,-1], color: [0,1,0,1]),
            Vertex(position: [-1,-1,-1], color: [0,0,0,1]),
            Vertex(position: [ 1,-1,-1], color: [1,0,0,1]),
            Vertex(position: [ 1, 1,-1], color: [1,1,0,1])
        ]
    }
    
    static func buildIndices() -> [UInt16] {
        return [
              3,2,6,6,7,3,
              4,5,1,1,0,4,
              4,0,3,3,7,4,
              1,5,6,6,2,1,
              0,1,2,2,3,0,
              7,6,5,5,4,7
          ]
    }
}
