//
//  Node.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import simd
import Foundation

// This class was heavily influenced by Warren More's Pickind and Hit Testing in Metal:
// https://metalbyexample.com/picking-hit-testing/
// https://github.com/metal-by-example/metal-picking/blob/master/Shared/Scene/Node.swift

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
    
    weak var parent: Node?
    var children = [Node]()
    var renderable: Renderable?
    
    
    func addChild(_ node: Node) {
        if node.parent != nil {
            node.removeFromParent()
        }
        children.append(node)
    }
    
    func removeChild(_ node: Node) {
        children.removeAll(where: { $0 == node })
    }
    
    func removeFromParent() {
        parent?.removeChild(self)
    }
    
    var position: float3
    
    // TODO: include rotation and scale to nodes
//    var rotation: float4
//    var scale: float3
    
    init() {
        position = float3.zero
    }
}
