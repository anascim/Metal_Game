//
//  TranslucentPlane.swift
//  MetalGame
//
//  Created by Alex Nascimento on 24/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class TranslucentPlane : Renderable {
    
       var device: MTLDevice
       var uniforms: Uniforms!
       var vertexBufferDelegate: VertexBufferDelegate?
       
       /// The center of the frame, defaluts to [0,0,0]
       var position: Vec3
       
       /// The size of the frame: [width, height]
       var size: Vec2
       
       init(device: MTLDevice, position: Vec3 = Vec3(0,0,0), size: Vec2) {
           self.device = device
           self.position = position
           self.size = size
       }
       
       public func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
           guard let delegate = vertexBufferDelegate else { return }
           
        let modelMatrix1 = float4x4(translationBy: Vec3(0,size.height/2,0)) * float4x4(scaleBy: Vec3(100, 0.05, 0.05))
        let modelMatrix2 = float4x4(translationBy: Vec3(0,-size.height/2,0)) * float4x4(scaleBy: Vec3(100, 0.05, 0.05))
        let modelMatrix3 = float4x4(translationBy: Vec3(-size.width/2,0,0)) * float4x4(scaleBy: Vec3(0.05, 100, 0.05))
        let modelMatrix4 = float4x4(translationBy: Vec3(size.width/2,0,0)) * float4x4(scaleBy: Vec3(0.05, 100, 0.05))
           let modelMtxs = [modelMatrix1, modelMatrix2, modelMatrix3, modelMatrix4]
           
           for m in modelMtxs {
               let mvpMatrix = viewProjectionMatrix * m // scale and then translate
               uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
               
               commandEncoder.setVertexBuffer(delegate.vertexBuffer, offset: 0, index: 0)
               commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
               commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: delegate.indices.count, indexType: .uint16, indexBuffer: delegate.indexBuffer, indexBufferOffset: 0)
           }
       }
}
