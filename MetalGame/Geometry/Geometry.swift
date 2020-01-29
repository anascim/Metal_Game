//
//  Geometry.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

/// This protocol is intended for geometry description only
/// Structs such as Cube, Plane etc must implement this protocol
/// No Metal logic or buffer creation.
/// Only static methods for creating vertices and indices.

protocol Geometry {
    
    static func buildVertices() -> [Vertex]
    static func buildIndices() -> [UInt16]
}
