//
//  Renderable.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

// This protocol is inteded to be implemented by classes that contain MTLBuffers
// and so has vertices to be rendered on the screen.

import MetalKit

public protocol Renderable {
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: matrix_float4x4)
}
