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
    
    var position: float3
    var gridLayout: (UInt16, UInt16)
    var blockWidth: Float
    var blockHeight: Float
    
    var vbo1: VertexBufferDelegate
    var vbo2: VertexBufferDelegate?
    var vbo3: VertexBufferDelegate?
    
    var blocks = [Block]()
    
    init(position: float3, gridAspect: (UInt16, UInt16), blockSize: float2, vbo: VertexBufferDelegate) {
        self.position = position
        self.gridLayout = gridAspect
        self.blockWidth = blockSize.width
        self.blockHeight = blockSize.height
        self.vbo1 = vbo
        
        super.init()
        
        for row in 0..<gridLayout.1 {
            for col in 0..<gridLayout.0 {
                
                let newBlock = Block(position: [Float(col) * blockWidth + position[0],
                                               Float(row) * -blockHeight + position[1], 0],
                                    size: [blockWidth, blockHeight], vbo: vbo1, life: 1)
                blocks.append(newBlock)
                addChild(newBlock)
            }
        }
    }
    
    func checkForCollisions(rect: float4) {
        for b in blocks {
            if Collision.check(r1: rect, r2: b.rect) {
                // collided with block
                b.life -= 1
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
}

