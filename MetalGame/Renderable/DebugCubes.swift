//
//  DebugCubes.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

// This class is only for debbuging functionality with the cubes
// It shouldn't be used in the final product

class DebugCubes {
    
    var cube: BufferedCube
    var cube2: BufferedCube
    var cube3: BufferedCube
    
    var uniforms1: Uniforms!
    var uniforms2: Uniforms!
    var uniforms3: Uniforms!
    
    init(device: MTLDevice) {
        cube = BufferedCube(device: device, position:[0,0,0])
        cube2 = BufferedCube(device: device, position:[0,0,0])
        cube3 = BufferedCube(device: device, position:[0,0,0])
    }
    
    func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        
        // update uniforms
        let rotationX = float4x4(rotationAbout: [1,0,0], by: time)
        let rotationY = float4x4(rotationAbout: [0,1,0], by: time)
        let scale = float4x4(scaleBy: 0.1)
        let pulsating = sin(time*4)*0.5 + 3
        let pulsatingScale = float4x4(scaleBy: pulsating)
        let pulsatingRotationX = float4x4(rotationAbout: [1,0,0], by: sin(time)/4)
        let pulsatingRotationY = float4x4(rotationAbout: [0,1,0], by: sin(time)/4)
        let modelMatrix1 = rotationX * rotationY * float4x4(translationBy: [-1, 1, 0]) * scale
        let modelMatrix2 = float4x4(translationBy: [1, 1, 0]) * scale * rotationX * rotationY
        let modelMatrix3 =  scale * pulsatingScale * pulsatingRotationX * pulsatingRotationY
        
        let mvpMatrix1 = viewProjectionMatrix * modelMatrix1
        let mvpMatrix2 = viewProjectionMatrix * modelMatrix2
        let mvpMatrix3 = viewProjectionMatrix * modelMatrix3
        self.uniforms1 = Uniforms(modelViewProjectionMatrix: mvpMatrix1, xOffset: 0)
        self.uniforms2 = Uniforms(modelViewProjectionMatrix: mvpMatrix2, xOffset: 0)
        self.uniforms3 = Uniforms(modelViewProjectionMatrix: mvpMatrix3, xOffset: 0)
        
        // render pass
        commandEncoder.setVertexBuffer(cube.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&uniforms1, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)

        commandEncoder.setVertexBytes(&uniforms2, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.setVertexBytes(&uniforms3, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)
        
    }
}
