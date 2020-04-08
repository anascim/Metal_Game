//
//  Types.swift
//  MetalGame
//
//  Created by Alex Nascimento on 19/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd

struct Vertex {
    var position: SIMD3<Float>
    var color: SIMD4<Float>
}

public struct Uniforms {
    var modelViewProjectionMatrix: float4x4
    var xOffset: Float
}

typealias float4 = SIMD4<Float>

struct Vec2 {
    var x, y: Float
    
    var width: Float { return x }
    var height: Float { return y }
    
    init(_ x: Float, _ y: Float) {
        self.x = x
        self.y = y
    }
    
    static func + (lhs: Vec2, rhs: Vec2) -> Vec2 {
        return Vec2(lhs.x + rhs.x,
                    lhs.y + rhs.y)
    }
    
    subscript(index: Int) -> Float {
        switch index {
        case 0: return x
        case 1: return y
        default: fatalError("Vec2 index out of range!")
        }
    }
}

struct Vec3 {
    var x, y, z: Float
    
    init(_ x: Float, _ y: Float, _ z: Float) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    static func + (lhs: Vec3, rhs: Vec3) -> Vec3 {
        return Vec3(lhs.x + rhs.x,
                    lhs.y + rhs.y,
                    lhs.z + rhs.z)
    }
    
    subscript(index: Int) -> Float {
        switch index {
        case 0: return x
        case 1: return y
        case 2: return z
        default: fatalError("Vec3 index out of range!")
        }
    }
}

struct Vec4 {
    var x, y, z, w: Float
    
    init(_ x: Float, _ y: Float, _ z: Float, _ w: Float) {
        self.x = x
        self.y = y
        self.z = z
        self.w = w
        
    }
    
    static func + (lhs: Vec4, rhs: Vec4) -> Vec4 {
        return Vec4(lhs.x + rhs.x, lhs.y + rhs.y,
                    lhs.z + rhs.z, lhs.w + rhs.w)
    }
    
    subscript(index: Int) -> Float {
        switch index {
        case 0: return x
        case 1: return y
        case 2: return z
        case 3: return w
        default: fatalError("Vec4 index out of range!")
        }
    }
}

