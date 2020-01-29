//
//  Node.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd
import Foundation

/// Node of the game engine. Dictates the positioning of objects in the scene hierarchy.
/// A node always has one parent and possibly multiple children. Removing a node from it's parent will destroy the node and all it's children.
/// Subclassing renderable nodes should fill in the renderable property on initialization.

class Node : Equatable {
    
    /// Unique identifier for each node.
    let id = UUID()
    
    // Equatable required
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
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
        position = float3.zero
    }
}
