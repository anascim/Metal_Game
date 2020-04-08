//
//  PlaneVBO.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class PlaneVBO : VertexBufferDelegate {
    
    var device: MTLDevice
    var vertexBuffer: MTLBuffer!
    var indexBuffer: MTLBuffer!
    var vertices: [Vertex]
    var indices: [UInt16]
    
    required init(device: MTLDevice, vertices: [Vertex]) {
        self.device = device
        self.vertices = vertices
        self.indices = Plane.buildIndices()
        buildBuffers()
    }
    
    func buildBuffers() {
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
