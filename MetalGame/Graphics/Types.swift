//
//  Types.swift
//  MetalGame
//
//  Created by Alex Nascimento on 19/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd

struct Vertex {
    var position: float3
    var color: float4
}

public struct Uniforms {
    var modelViewProjectionMatrix: float4x4
    var xOffset: Float
}

typealias float2 = SIMD2<Float>
typealias float3 = SIMD3<Float>
typealias float4 = SIMD4<Float>

extension float2 {
    var x: Float { get { return self[0]} set { self[0] = newValue } }
    var y: Float { return self[1] }
    var width: Float { return self[0] }
    var height: Float { return self[1] }
}

extension float3 {
    var x: Float { return self[0] }
    var y: Float { return self[1] }
    var z: Float { return self[2] }
}

extension float4 {
    var x: Float { return self[0] }
    var y: Float { return self[1] }
    var z: Float { return self[2] }
    var w: Float { return self[3] }
}
