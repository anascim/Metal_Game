//
//  Plane.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

struct Plane : Geometry {
    
    var vertices: [Vertex]
    var indices: [UInt16]
    
    init() {
        self.vertices = Plane.buildVertices()
        self.indices = Plane.buildIndices()
    }
    
    init(color: float4) {
        self.vertices = Plane.buildVertices(color: color)
        self.indices = Plane.buildIndices()
    }
    
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
