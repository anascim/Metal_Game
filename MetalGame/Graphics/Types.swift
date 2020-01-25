//
//  Types.swift
//  MetalGame
//
//  Created by Alex Nascimento on 19/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd

typealias float2 = SIMD2<Float>
typealias float3 = SIMD3<Float>
typealias float4 = SIMD4<Float>

struct Vertex {
    var position: float3
    var color: float4
}

public struct Uniforms {
    var modelViewProjectionMatrix: float4x4
    var xOffset: Float
}
