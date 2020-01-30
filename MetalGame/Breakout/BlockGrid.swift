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
    var gridAspect: (UInt16, UInt16)
    var blockWidth: Float
    var blockHeight: Float
    var xOffset: Float = 0.04
    var yOffset: Float = 0.04
    
    var centralizedOriginX: Float {
        return -totalWidth/2 + blockWidth/2 + xOffset
    }
    var totalWidth: Float {
        return Float(gridAspect.0) * (blockWidth + xOffset)
    }
    var totalHeight: Float {
        return Float(gridAspect.1) * (blockHeight + yOffset)
    }
    
    var vbo1: VertexBufferDelegate
    var vbo2: VertexBufferDelegate
    var vbo3: VertexBufferDelegate
    
    init(position: float3, gridAspect: (UInt16, UInt16), layout: String, blockSize: float2, vbo1: VertexBufferDelegate, vbo2: VertexBufferDelegate, vbo3: VertexBufferDelegate) {
        self.position = position
        self.gridAspect = gridAspect
        self.blockWidth = blockSize.width
        self.blockHeight = blockSize.height
        self.vbo1 = vbo1
        self.vbo2 = vbo2
        self.vbo3 = vbo3
        
        super.init()
        
        let charArray = Array(layout)
        for row in 0..<gridAspect.1 {
            for col in 0..<gridAspect.0 {
                
                let charIndex = Int(row * gridAspect.0 + col)
                var life: UInt8
                switch charArray[charIndex] {
                case "1":
                    life = 1
                case "2":
                    life = 2
                case "3":
                    life = 3
                default:
                    continue
                }
                let newBlock = Block(position: [Float(col) * (blockWidth+xOffset),
                                               Float(row) * -(blockHeight+yOffset), 0],
                                     size: [blockWidth, blockHeight], vbos: [vbo1, vbo2, vbo3], life: life)
                addChild(newBlock)
            }
        }
    }
}

class Block : RectNode {
    
    var life: UInt8
    
    var vbos: [VertexBufferDelegate]
    
    init(position: float3, size: float2, vbos: [VertexBufferDelegate], life: UInt8) {
        self.life = life
        self.vbos = vbos
        super.init(position: position, size: size, vbo: vbos[Int(life)-1])
    }
    
    public func takeHit() {
        life -= 1
        if life == 0 {
            self.removeFromParent()
        } else {
            self.vbo = vbos[Int(life)-1]
        }
    }
}

