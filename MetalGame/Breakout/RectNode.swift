//
//  RectNode.swift
//  MetalGame
//
//  Created by Alex Nascimento on 29/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class RectNode : Node {
    
    var position: Vec3 {
        didSet { updateTransform() }
    }
    var size: Vec2 { didSet { updateTransform() } }
    var rect: Vec4 {
        get {
            let l = position.x - size.width/2
            let t = position.y + size.height/2
            let r = position.x + size.width/2
            let b = position.y - size.height/2
            return Vec4(l,t,r,b)
        }
    }
    
    private var modelMatrix: float4x4
    
    init(position: Vec3, size: Vec2, vbo: VertexBufferDelegate?) {
        self.position = position
        self.size = size
        self.modelMatrix = matrix_identity_float4x4
        
        super.init()
        self.vbo = vbo
        
        updateTransform()
    }
    
    private func updateTransform() {
        
        let scale = float4x4(scaleBy: Vec3(size.x/2, size.y/2, 0.05))
        let translation = float4x4(translationBy: Vec3(position.x,position.y,0))
        
        self.modelMatrix = translation * scale // scale and then translate
        self.transform = modelMatrix
    }
}
