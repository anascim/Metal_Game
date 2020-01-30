//
//  Node.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

// This class is an adaptation of Warren More's Picking and Hit Testing in Metal:
// https://metalbyexample.com/picking-hit-testing/
// https://github.com/metal-by-example/metal-picking/blob/master/Shared/Scene/Node.swift

/// Node of the game engine. Dictates the positioning of objects in the scene hierarchy.
/// A node always has one parent and possibly multiple children. Removing a node from it's parent will destroy the node and all it's children.
/// Subclassing renderable nodes should fill in the renderable property on initialization.

class Node : Equatable, Renderable {
    
    /// Unique identifier for each node.
    let id = UUID()
    
    weak var parent: Node?
    var children = [Node]()
    
    var vbo: VertexBufferDelegate?
    var uniforms: Uniforms!
    
    var transform: float4x4
    var worldTransform: float4x4 {
        if let parent = parent {
            return parent.worldTransform * transform
        } else {
            return transform
        }
    }
    
    init() {
        transform = matrix_identity_float4x4
    }
    
    func addChild(_ node: Node) {
        if node.parent != nil {
            node.parent!.removeChild(node)
        }
        children.append(node)
        node.parent = self
    }
    
    func removeChild(_ node: Node) {
        children.removeAll(where: { $0 == node })
    }
    
    func removeAllChildren() {
        children.removeAll()
    }
    
    func removeFromParent() {
        parent?.removeChild(self)
        children.forEach{ $0.removeFromParent() }
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        children.forEach { $0.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)}
        
        // Setup render
        guard let vbo = vbo else { return }
        let mvp = viewProjectionMatrix * worldTransform
        uniforms = Uniforms(modelViewProjectionMatrix: mvp, xOffset: 0)
        
        // Render Pass
        commandEncoder.setVertexBuffer(vbo.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: vbo.indices.count, indexType: .uint16, indexBuffer: vbo.indexBuffer, indexBufferOffset: 0)
    }
    
    // Equatable required
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.id == rhs.id
    }
}
