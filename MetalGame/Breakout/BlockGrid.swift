//
//  BlockGrid.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

/// This class is used to render a block grid on the screen.
/// The position of the blocks is dictated by the modelMatrix sent by uniform data.
/// The BlockGrid position represents its top-left corner, rendering the blocks from there.

class BlockGrid : Node {
    
    // Short term solution. TODO: Have this integrate with transform instead.
    var position: float3 {
        didSet {
            for c in children as! [Block] {
                c.position = c.position + self.position
            }
        }
    }
    var gridLayout: (UInt16, UInt16)
    var blockWidth: Float
    var blockHeight: Float
    var xOffset: Float = 0.04
    var yOffset: Float = 0.04
    
    var centralizedOriginX: Float {
        return -totalWidth/2 + blockWidth/2 + xOffset
    }
    var totalWidth: Float {
        return Float(gridLayout.0) * (blockWidth + xOffset)
    }
    var totalHeight: Float {
        return Float(gridLayout.1) * (blockHeight + yOffset)
    }
    
    var vbo1: VertexBufferDelegate
    var vbo2: VertexBufferDelegate?
    var vbo3: VertexBufferDelegate?
    
    init(position: float3, gridAspect: (UInt16, UInt16), blockSize: float2, vbo: VertexBufferDelegate) {
        self.position = position
        self.gridLayout = gridAspect
        self.blockWidth = blockSize.width
        self.blockHeight = blockSize.height
        self.vbo1 = vbo
        
        super.init()
        
        for row in 0..<gridLayout.1 {
            for col in 0..<gridLayout.0 {
                
                let newBlock = Block(position: [Float(col) * (blockWidth+xOffset),
                                               Float(row) * -(blockHeight+yOffset), 0],
                                    size: [blockWidth, blockHeight], vbo: vbo1, life: 1)
                addChild(newBlock)
            }
        }
    }
}

class Block : RectNode {
    
    var life: UInt8
    
    init(position: float3, size: float2, vbo: VertexBufferDelegate, life: UInt8) {
        self.life = life
        super.init(position: position, size: size, vbo: vbo)
    }
    
    public func takeHit() {
        life -= 1
        if life == 0 {
            self.removeFromParent()
        }
    }
}

