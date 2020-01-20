//
//  Types.swift
//  MetalGame
//
//  Created by Alex Nascimento on 19/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd

struct Vertex {
    var position: vector_float3
    var color: vector_float4
}

struct Uniforms {
    var modelViewProjectionMatrix: float4x4
    var xOffset: Float
}
