//
//  Node.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class Node : NSObject {
    
    var position: SIMD3<Float>
    var children: [Node] = []
    unowned var parent: Node?
    
    override init() {
        self.position = [0, 0, 0]
        super.init()
    }
    
    init(position: SIMD3<Float>) {
        self.position = position
        super.init()
    }
    
    public func addChild(_ node: Node) {
        children.append(node)
    }
    
    public func removeFromParent() {
        parent = nil
        children.forEach { $0.removeFromParent() }
    }
    
    public func draw() {
        
    }
}
