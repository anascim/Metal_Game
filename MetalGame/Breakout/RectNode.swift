//
//  RectNode.swift
//  MetalGame
//
//  Created by Alex Nascimento on 29/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class RectNode : Node {
    
    var position: float3 {
        didSet { updateTransform() }
    }
    var size: float2 { didSet { updateTransform() } }
    var rect: float4 {
        get {
            let l = position.x - size.width/2
            let t = position.y + size.height/2
            let r = position.x + size.width/2
            let b = position.y - size.height/2
            return [l,t,r,b]
        }
    }
    
    private var modelMatrix: float4x4
    
    init(position: float3, size: float2, vbo: VertexBufferDelegate?) {
        self.position = position
        self.size = size
        self.modelMatrix = matrix_identity_float4x4
        
        super.init()
        self.vbo = vbo
        
        updateTransform()
    }
    
    private func updateTransform() {
        
        let scale = float4x4(scaleBy: [size.x/2, size.y/2, 0.05])
        let translation = float4x4(translationBy: [position.x,position.y,0])
        
        self.modelMatrix = translation * scale // scale and then translate
        self.transform = modelMatrix
    }
}
