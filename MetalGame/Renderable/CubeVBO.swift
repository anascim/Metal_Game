//
//  CubeVBO.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class CubeVBO : VertexBufferDelegate {
    
    var device: MTLDevice
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var vertices: [Vertex]!
    var indices: [UInt16]!
    
    required init(device: MTLDevice) {
        self.device = device
        buildBuffers()
    }
    
    func buildBuffers() {
        self.vertices = Cube.buildVertices()
        self.indices = Cube.buildIndices()

        if let buffer = device.makeBuffer(bytes: vertices,
                         length: MemoryLayout<Vertex>.stride * vertices.count,
                         options: .cpuCacheModeWriteCombined) {
           vertexBuffer = buffer
        } else { fatalError("CubeVBO:buildBuffers Couldn't make buffer!") }
        if let buffer = device.makeBuffer(bytes: indices,
                                         length: MemoryLayout<UInt16>.stride * indices.count,
                                         options: .cpuCacheModeWriteCombined) {
           indexBuffer = buffer
        } else { fatalError("CubeVBO:buildBuffers Couldn't make buffer!") }
    }
}
