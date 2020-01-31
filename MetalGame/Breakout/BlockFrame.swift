//
//  BlockFrame.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//
import MetalKit

/// This class is used to draw a frame on the screen composed of 4 alongated cubes.
/// The position is its center while the size dictates its width and height respectively

class BlockFrame : Node {
    
    var frame: float2
    let left: RectNode
    let right: RectNode
    let top: RectNode
    let bottom: RectNode
    
    init(frame: float2, vbo: VertexBufferDelegate) {
        self.frame = frame
        left = RectNode(position: [-frame.width/2,0,0], size: [0.05,100], vbo: vbo)
        right = RectNode(position: [frame.width/2,0,0], size: [0.05,100], vbo: vbo)
        top = RectNode(position: [0,frame.height/2,0], size: [100,0.05], vbo: vbo)
        bottom = RectNode(position: [0,-frame.height/2,0], size: [100,0.05], vbo: nil)
        
        super.init()
        
        addChild(left)
        addChild(right)
        addChild(top)
        addChild(bottom)
    }
}

