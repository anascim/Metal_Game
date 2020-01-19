//
//  MathUtilities.swift
//  MetalGame
//
//  Created by Alex Nascimento on 16/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

// This file was heavily based by this example by Warren More:
// https://github.com/metal-by-example/modern-metal/blob/master/modern-metal/modern-metal/MathUtilities.swift

import simd

extension matrix_float4x4 {
    init(scaleBy s: Float) {
        self.init(SIMD4<Float>(s, 0, 0, 0),
                  SIMD4<Float>(0, s, 0, 0),
                  SIMD4<Float>(0, 0, s, 0),
                  SIMD4<Float>(0, 0, 0, 1))
    }
    
    init(rotationAbout axis: SIMD3<Float>, by radians: Float) {
        
        let c = cos(radians);
        let s = sin(radians);
        
        let X = vector_float4(axis.x * axis.x + (1 - axis.x * axis.x) * c,
                              axis.x * axis.y * (1 - c) - axis.z * s,
                              axis.x * axis.z * (1 - c) + axis.y * s,
                              0.0)
        let Y = vector_float4(axis.x * axis.y * (1 - c) + axis.z * s,
                              axis.y * axis.y + (1 - axis.y * axis.y) * c,
                              axis.y * axis.z * (1 - c) - axis.x * s,
                              0.0)
        let Z = vector_float4(axis.x * axis.z * (1 - c) - axis.y * s,
                              axis.y * axis.z * (1 - c) + axis.x * s,
                              axis.z * axis.z + (1 - axis.z * axis.z) * c,
                              0.0)
        let W = vector_float4(0.0, 0.0, 0.0, 1.0)
        
        self.init(X, Y, Z, W)
    }
    
    init(translationBy t: SIMD3<Float>) {
        self.init(SIMD4<Float>(   1,    0,    0, 0),
                  SIMD4<Float>(   0,    1,    0, 0),
                  SIMD4<Float>(   0,    0,    1, 0),
                  SIMD4<Float>(t[0], t[1], t[2], 1))
    }
    
    init(perspectiveProjectionFov fovRadians: Float, aspectRatio aspect: Float, nearZ: Float, farZ: Float) {
        let yScale = 1 / tan(fovRadians * 0.5)
        let xScale = yScale / aspect
        let zRange = farZ - nearZ
        let zScale = -(farZ + nearZ) / zRange
        let wzScale = -2 * farZ * nearZ / zRange
        
        self.init(SIMD4<Float>(xScale,  0,  0,  0),
                  SIMD4<Float>( 0, yScale,  0,  0),
                  SIMD4<Float>( 0,  0, zScale, -1),
                  SIMD4<Float>( 0,  0, wzScale,  0))
    }
}
