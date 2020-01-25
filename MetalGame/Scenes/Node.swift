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

class Node {
    
    var parent: Node?
    var children: [Node]?
    var renderable: Renderable?
    
    var position: float3
    var rotation: float4
    var scale: float3
    
    init() {
        position = float3.zero
        rotation = float4.zero
        scale = float3.zero
    }
    
    func removeFromParent() {
        parent = nil
    }
}
