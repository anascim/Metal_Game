//
//  Plane.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

/// Contains static methods that build vertices and indices that describe a plane.
/// Should not be instantiated. Use the static methods instead.

struct Plane : Geometry {
    
    static func buildVertices() -> [Vertex] {
        return [
            Vertex(position: [-1, 1,0], color: [0.0, 0.0, 1.0, 1.0]),
            Vertex(position: [-1,-1,0], color: [0.0, 1.0, 1.0, 1.0]),
            Vertex(position: [ 1,-1,0], color: [1.0, 0.0, 1.0, 1.0]),
            Vertex(position: [ 1, 1,0], color: [1.0, 1.0, 1.0, 1.0])
        ]
    }
    
    static func buildVertices(color: float4) -> [Vertex] {
        return [
            Vertex(position: [-1, 1,0], color: color),
            Vertex(position: [-1,-1,0], color: color),
            Vertex(position: [ 1,-1,0], color: color),
            Vertex(position: [ 1, 1,0], color: color)
        ]
    }
    
    static func buildIndices() -> [UInt16] {
        return [0,1,2,
                1,2,3]
    }
}
