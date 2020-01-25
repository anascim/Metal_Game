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
    var vertices: [Vertex]!
    var indices: [UInt16]!
    
    init(device: MTLDevice, color: float4) {
        self.device = device
        buildBuffers(color: color)
    }
    
    required init(device: MTLDevice) {
        self.device = device
        buildBuffers()
    }
    
    func buildBuffers(color: float4) {
        self.vertices = Plane.buildVertices(color: color)
        self.indices = Plane.buildIndices()

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
    
    func buildBuffers() {
        self.vertices = Plane.buildVertices(color: [0,0,0,0])
        self.indices = Plane.buildIndices()

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
