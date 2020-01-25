//
//  Cube.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import Foundation

struct Cube : Geometry {
    
    var vertices: [Vertex]
    var indices: [UInt16]
    
    init() {
        self.vertices = Cube.buildVertices()
        self.indices = Cube.buildIndices()
    }
    
    init(color: float4) {
        self.vertices = Cube.buildVertices(color: color)
        self.indices = Cube.buildIndices()
    }
    
    init(color1: float4, color2: float4) {
        self.vertices = Cube.buildVertices(color1: color1, color2: color2)
        self.indices = Cube.buildIndices()
    }
    
    static func buildVertices(color: float4) -> [Vertex] {
        return [
            Vertex(position: [-1.0, -1.0, 1.0], color: color),
            Vertex(position: [-1.0,  1.0, 1.0], color: color),
            Vertex(position: [-1.0, -1.0,-1.0], color: color),
            Vertex(position: [-1.0,  1.0,-1.0], color: color),
            Vertex(position: [ 1.0, -1.0, 1.0], color: color),
            Vertex(position: [ 1.0,  1.0, 1.0], color: color),
            Vertex(position: [ 1.0, -1.0,-1.0], color: color),
            Vertex(position: [ 1.0,  1.0,-1.0], color: color)
        ]
    }
    
    static func buildVertices(color1: float4, color2: float4) -> [Vertex] {
        return [
            Vertex(position: [-1.0, -1.0, 1.0], color: color1),
            Vertex(position: [-1.0,  1.0, 1.0], color: color1),
            Vertex(position: [-1.0, -1.0,-1.0], color: color1),
            Vertex(position: [-1.0,  1.0,-1.0], color: color1),
            Vertex(position: [ 1.0, -1.0, 1.0], color: color1),
            Vertex(position: [ 1.0,  1.0, 1.0], color: color1),
            Vertex(position: [ 1.0, -1.0,-1.0], color: color1),
            Vertex(position: [ 1.0,  1.0,-1.0], color: color1)
        ]
    }
    
    static func buildVertices() -> [Vertex] {
        return [
            Vertex(position: [-1.0, -1.0, 1.0], color: [0.0, 0.0, 1.0, 1.0]), // 0: blue
            Vertex(position: [-1.0,  1.0, 1.0], color: [0.0, 1.0, 1.0, 1.0]), // 1: cian
            Vertex(position: [-1.0, -1.0,-1.0], color: [1.0, 0.0, 1.0, 1.0]), // 2: pink
            Vertex(position: [-1.0,  1.0,-1.0], color: [1.0, 1.0, 1.0, 1.0]), // 3: white
            Vertex(position: [ 1.0, -1.0, 1.0], color: [0.0, 0.0, 0.0, 1.0]), // 4: black
            Vertex(position: [ 1.0,  1.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]), // 5: green
            Vertex(position: [ 1.0, -1.0,-1.0], color: [1.0, 0.0, 0.0, 1.0]), // 6: red
            Vertex(position: [ 1.0,  1.0,-1.0], color: [1.0, 1.0, 0.0, 1.0])  // 7: yellow
        ]
    }
    
    static func buildIndices() -> [UInt16] {
        return [
              0, 1, 2, 1, 3, 2,
              3, 6, 2, 3, 7, 6,
              7, 4, 6, 7, 5, 4,
              5, 0, 4, 5, 1, 0,
              1, 5, 7, 1, 7, 3,
              2, 6, 4, 2, 4, 0
          ]
    }
}
