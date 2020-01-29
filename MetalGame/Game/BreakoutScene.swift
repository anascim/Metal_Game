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
    let cubicBall: CubicBall
    
    let redCube: CubeVBO
    let whiteCube: CubeVBO
    let blueCube: CubeVBO
    let greenCube: CubeVBO
    
    // This plane is intended to be used to render the ball on the fragment shader
//    let translucentPlane: TranslucentPlane
    
    override init(device: MTLDevice, view: MTKView) {
        
        // ----------------------------------
        // Initialize buffers and renderables
        // ----------------------------------
        redCube = CubeVBO(device: device,
                          vertices: Cube.buildVertices(topColor: [0.8,0,0,1], bottomColor: [0.4,0,0,1]))
        whiteCube = CubeVBO(device: device,
                            vertices: Cube.buildVertices(frontColor: [1,1,1,1], backColor: [0.6,0.6,0.6,1]))
        blueCube = CubeVBO(device: device,
                           vertices: Cube.buildVertices(topColor: [0,0,0.8,1], bottomColor: [0,0,0.4,1]))
        greenCube = CubeVBO(device: device,
                            vertices: Cube.buildVertices(topColor: [0,0.8,0,1], bottomColor: [0,0.4,0,1]))
        
        
        blockGrid = BlockGrid(device: device, position: [-1.2,3,0])
        blockFrame = BlockFrame(device: device, size: [Float(view.drawableSize.width*0.004),
                                                       Float(view.drawableSize.height*0.004)])
        paddle = Paddle()
        cubicBall = CubicBall()
        
        cubicBall.cubeVBO = whiteCube
        blockGrid.cubeVBO = greenCube
        paddle.cubeVBO = redCube
        blockFrame.cubeVBO = blueCube
        
        super.init(device: device, view: view)
        
        // ---------------------
        // Set up nodes on scene
        // ---------------------
        
        let gridNode = Node()
        let frameNode = Node()
        let paddleNode = Node()
        let ballNode = Node()
        
        gridNode.renderable = blockGrid
        frameNode.renderable = blockFrame
        paddleNode.renderable = paddle
        ballNode.renderable = cubicBall
        
        addChild(gridNode)
        addChild(frameNode)
        addChild(paddleNode)
        addChild(ballNode)
    }
    
    override func touchMove(location: CGPoint) {
        let worldWidth = view.drawableSize.width*0.004
        let pctx = (location.x / view.frame.width)
        let relativePosX = pctx * worldWidth - worldWidth/2
        print("relativePosX: \(relativePosX), location: \(location), pctx: \(pctx), frameWidth: \(view.frame.width)")
        paddle.xPosition = Float(relativePosX)
    }
}
