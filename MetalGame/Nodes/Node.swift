//
//  Node.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd

/// Node of the game engine. Dictates the positioning of objects in the scene hierarchy.
/// A node always has one parent, with the exception of the Scene, and possibly multiple children.
/// Subclassing renderable nodes should fill in the renderable property on initialization.

class Node : Equatable {
    
    /// Unique identifier for each node. This class breaks if the number of created nodes exceeds 2ˆ32 in a given runtime.
    let id: UInt32
    
    static var counter: UInt32 = 0
    
    // Equatable required
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func getAvailableId() -> UInt32 {
        counter += 1
        return counter
    }
    
    // TODO: resolve the dependency problem on the parent-child node relation (weak or unowned not supported on arrays)
//    var parent: Node?
//    var children: [Node]?
    var renderable: Renderable?
    
    var position: float3
    
    // TODO: include rotation and scale to nodes
//    var rotation: float4
//    var scale: float3
    
    init() {
        id = Node.getAvailableId()
        position = float3.zero
    }
}
