//
//  Geometry.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

/// This protocol is intended for geometry description only
/// Classes such as Cube, Piramid etc must implement this protocol
/// No Metal logic or buffer creation
/// Only vertices and indices and methods linked with those

protocol Geometry {
    
    var vertices: [Vertex] { get set }
    var indices: [UInt16] { get set }
    
    static func buildVertices() -> [Vertex]
    static func buildIndices() -> [UInt16]
}
