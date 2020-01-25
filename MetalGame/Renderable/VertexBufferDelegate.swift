//
//  VertexBufferDelegate.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

protocol VertexBufferDelegate {
    
    var device: MTLDevice { get set }
    var vertexBuffer: MTLBuffer! { get set }
    var indexBuffer: MTLBuffer! { get set }
    var vertices: [Vertex]! { get set }
    var indices: [UInt16]! { get set }
    
    init(device: MTLDevice)
    
    func buildBuffers()
}
