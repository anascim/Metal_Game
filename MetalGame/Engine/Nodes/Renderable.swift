//
//  Renderable.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//


import MetalKit

/// This protocol is inteded to be implemented by classes that contain MTLBuffers
/// and so has vertices to be rendered on the screen.

public protocol Renderable {
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float)
}
