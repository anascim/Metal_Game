//
//  RectNode.swift
//  MetalGame
//
//  Created by Alex Nascimento on 29/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class RectNode : Node {
    
    var position: float3 { didSet { update() } }
    var size: float2 { didSet { update() } }
    
    private var modelMatrix: float4x4
    
    init(position: float3, size: float2, vbo: VertexBufferDelegate) {
        self.position = position
        self.size = size
        self.modelMatrix = matrix_identity_float4x4
        
        super.init()
        self.vbo = vbo
        
        update()
    }
    
    private func update() {
        
        let scale = float4x4(scaleBy: [size.x/2, size.y/2, 0.05])
        let translation = float4x4(translationBy: [position.x,position.y,0])
        
        self.modelMatrix = translation * scale // scale and then translate
        self.transform = modelMatrix
    }
}
