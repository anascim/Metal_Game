//
//  GameScene.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class BreakoutScene : Scene {
    
    let blockGrid: BlockGrid
    let blockFrame: BlockFrame
    let paddle: Paddle
    let cubeVBO: CubeVBO
    
    override init(device: MTLDevice, view: MTKView) {
        cubeVBO = CubeVBO(device: device)
        blockGrid = BlockGrid(device: device, position: [-1.2,3,0])
        blockGrid.delegate = cubeVBO
        blockFrame = BlockFrame(device: device, size: [Float(view.drawableSize.width*0.004),
                                                       Float(view.drawableSize.height*0.004)])
        paddle = Paddle()
        paddle.delegate = cubeVBO
        print(view.drawableSize.width*0.004)
        print(view.drawableSize.height*0.004)
        super.init(device: device, view: view)
    }
    
    override func render(commandEncoder: MTLRenderCommandEncoder, viewProjectionMatrix: float4x4, time: Float) {
        blockGrid.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
        blockFrame.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
        paddle.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
    }
}
