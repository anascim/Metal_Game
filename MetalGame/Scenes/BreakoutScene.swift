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
        super.init(device: device, view: view)
        
        let gridNode = Node()
        let frameNode = Node()
        let paddleNode = Node()
        
        gridNode.renderable = blockGrid
        frameNode.renderable = blockFrame
        paddleNode.renderable = paddle
        
        addChild(gridNode)
        addChild(frameNode)
        addChild(paddleNode)
    }
}
