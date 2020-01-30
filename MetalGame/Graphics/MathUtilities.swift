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

let PI = Float.pi

func getAngle(_ p1: float2, _ p2: float2) -> Float {
    return atan2f(p2.y - p1.y, p2.x - p1.x)
}

extension float4x4 {
    init(scaleBy s: Float) {
        self.init(float4(s, 0, 0, 0),
                  float4(0, s, 0, 0),
                  float4(0, 0, s, 0),
                  float4(0, 0, 0, 1))
    }
    
    init(scaleBy s: float3) {
        self.init(float4(s[0],    0,    0, 0),
                  float4(   0, s[1],    0, 0),
                  float4(   0,    0, s[2], 0),
                  float4(   0,    0,    0, 1))
    }
    
    init(rotationAbout axis: float3, by radians: Float) {
        
        let c = cos(radians);
        let s = sin(radians);
        
        let X = float4(axis.x * axis.x + (1 - axis.x * axis.x) * c,
                              axis.x * axis.y * (1 - c) - axis.z * s,
                              axis.x * axis.z * (1 - c) + axis.y * s,
                              0.0)
        let Y = float4(axis.x * axis.y * (1 - c) + axis.z * s,
                              axis.y * axis.y + (1 - axis.y * axis.y) * c,
                              axis.y * axis.z * (1 - c) - axis.x * s,
                              0.0)
        let Z = float4(axis.x * axis.z * (1 - c) - axis.y * s,
                              axis.y * axis.z * (1 - c) + axis.x * s,
                              axis.z * axis.z + (1 - axis.z * axis.z) * c,
                              0.0)
        let W = float4(0.0, 0.0, 0.0, 1.0)
        
        self.init(X, Y, Z, W)
    }
    
    init(translationBy t: float3) {
        self.init(float4(   1,    0,    0, 0),
                  float4(   0,    1,    0, 0),
                  float4(   0,    0,    1, 0),
                  float4(t[0], t[1], t[2], 1))
    }
    
    init(perspectiveProjectionFov fovRadians: Float, aspectRatio aspect: Float, nearZ: Float, farZ: Float) {
        let yScale = 1 / tan(fovRadians * 0.5)
        let xScale = yScale / aspect
        let zRange = farZ - nearZ
        let zScale = -(farZ + nearZ) / zRange
        let wzScale = -2 * farZ * nearZ / zRange
        
        self.init(float4(xScale,      0,      0,  0),
                  float4(     0, yScale,      0,  0),
                  float4(     0,      0, zScale, -1),
                  float4(     0,      0, wzScale, 0))
    }
}
