//
//  LifeMeter.swift
//  MetalGame
//
//  Created by Alex Nascimento on 30/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class LifeMeter : Node {
    
    var lifeCubes = [RectNode]()
    var distanceFromBorder: Float = 0.2
    var offset: Float = 0.1
    
    init(frame: float2, vbo: VertexBufferDelegate, maxLife: Int) {
        super.init()
        
        for i in 0..<maxLife {
            let x = -frame.width/2 + distanceFromBorder + Float(i) * offset
            let y = -frame.height/2 + distanceFromBorder
            let lifeCube = RectNode(position: [x,y,0], size: [0.05,0.05], vbo: vbo)
            lifeCubes.append(lifeCube)
        }
    }
    
    func setExtraBalls(_ life: Int) {
        removeAllChildren()
        if life == 0 { return }
        
        for i in 0..<life {
            addChild(lifeCubes[i])
        }
    }
}
