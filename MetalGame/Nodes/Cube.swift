//
//  Cube.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class Cube : Node {
    
    let vertices: [Vertex] = [
          Vertex(position: [-1.0, -1.0, 1.0, 1.0], color: [0.0, 0.0, 1.0, 1.0]),
          Vertex(position: [-1.0,  1.0, 1.0, 1.0], color: [0.0, 1.0, 1.0, 1.0]),
          Vertex(position: [-1.0, -1.0,-1.0, 1.0], color: [1.0, 0.0, 1.0, 1.0]),
          Vertex(position: [-1.0,  1.0,-1.0, 1.0], color: [1.0, 1.0, 1.0, 1.0]),
          Vertex(position: [ 1.0, -1.0, 1.0, 1.0], color: [0.0, 0.0, 0.0, 1.0]),
          Vertex(position: [ 1.0,  1.0, 1.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]),
          Vertex(position: [ 1.0, -1.0,-1.0, 1.0], color: [1.0, 0.0, 0.0, 1.0]),
          Vertex(position: [ 1.0,  1.0,-1.0, 1.0], color: [1.0, 1.0, 0.0, 1.0])
      ]
    
      let indices: [UInt16] = [
          0, 1, 2, 1, 3, 2,
          3, 6, 2, 3, 7, 6,
          7, 4, 6, 7, 5, 4,
          5, 0, 4, 5, 1, 0,
          1, 5, 7, 1, 7, 3,
          2, 6, 4, 2, 4, 0
      ]
    
    override init() {
        super.init()
        
    }
}
