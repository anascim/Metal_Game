//
//  Cube.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import Foundation

class Cube : Geometry {
    
    var vertices: [Vertex]
    var indices: [UInt16]
    
    init() {
        self.vertices = Cube.buildVertices()
        self.indices = Cube.buildIndices()
    }
    
    static func buildVertices() -> [Vertex] {
        return [
            Vertex(position: [-1.0, -1.0, 1.0], color: [0.0, 0.0, 1.0, 1.0]),
            Vertex(position: [-1.0,  1.0, 1.0], color: [0.0, 1.0, 1.0, 1.0]),
            Vertex(position: [-1.0, -1.0,-1.0], color: [1.0, 0.0, 1.0, 1.0]),
            Vertex(position: [-1.0,  1.0,-1.0], color: [1.0, 1.0, 1.0, 1.0]),
            Vertex(position: [ 1.0, -1.0, 1.0], color: [0.0, 0.0, 0.0, 1.0]),
            Vertex(position: [ 1.0,  1.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]),
            Vertex(position: [ 1.0, -1.0,-1.0], color: [1.0, 0.0, 0.0, 1.0]),
            Vertex(position: [ 1.0,  1.0,-1.0], color: [1.0, 1.0, 0.0, 1.0])
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
