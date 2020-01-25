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
    let planeVBO: PlaneVBO
    
    let translucentPlane: TranslucentPlane
    
    override init(device: MTLDevice, view: MTKView) {
        cubeVBO = CubeVBO(device: device)
        planeVBO = PlaneVBO(device: device, color: [0,0,0,0])
        blockGrid = BlockGrid(device: device, position: [-1.2,3,0])
        blockFrame = BlockFrame(device: device, size: [Float(view.drawableSize.width*0.004),
                                                       Float(view.drawableSize.height*0.004)])
        paddle = Paddle()
        translucentPlane = TranslucentPlane(device: device, size: [Float(view.drawableSize.width*0.004),
                                                                   Float(view.drawableSize.height*0.004)])
        
        blockGrid.cubeVBO = cubeVBO
        blockFrame.cubeVBO = cubeVBO
        paddle.cubeVBO = cubeVBO
        
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
    
    override func touchMove(location: CGPoint) {
        // TODO: this conversion is not perfect. Make better screen to world conversion.
        let pctx = (location.x * 2 / view.drawableSize.width)
        let relativePosX = pctx * 6.624 - 3.312
        print("relativePosX: \(relativePosX), location: \(location), drawableSizeW: \(view.drawableSize.width)")
        paddle.xPosition = Float(relativePosX)
    }
}
