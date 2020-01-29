//
//  BreakoutScene.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class BreakoutScene : Scene {
    
    let blockGrid: BlockGrid
    let blockFrame: BlockFrame
    let paddle: RectNode
    let cubicBall: RectNode
    
    let redCube: CubeVBO
    let whiteCube: CubeVBO
    let blueCube: CubeVBO
    let greenCube: CubeVBO
    
    // This plane is intended to be used to render the ball on the fragment shader
//    let translucentPlane: TranslucentPlane
    
    lazy var worldWidth = Float(view.drawableSize.width*0.004)
    lazy var worldHeight = Float(view.drawableSize.height*0.004)
    
    var xVel: Float = 0.03
    var yVel: Float = 0.02
    
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
        
        paddle = RectNode(position: [0,-3,0], size: [0.8,0.2], vbo: redCube)
        cubicBall = RectNode(position: [0,-2,0], size: [0.06,0.06], vbo: whiteCube)
        
        blockGrid.cubeVBO = greenCube
        blockFrame.cubeVBO = blueCube
        
        super.init(device: device, view: view)
        
        // ---------------------
        // Set up nodes on scene
        // ---------------------
        
        let gridNode = Node()
        let frameNode = Node()
        
//        rootNode.addChild(gridNode)
//        rootNode.addChild(frameNode)
        rootNode.addChild(paddle)
        rootNode.addChild(cubicBall)
    }
    
    override func update() {
        if cubicBall.position.x > worldWidth/2 || cubicBall.position.x < -worldWidth/2 {
            xVel = -xVel
        }
        if cubicBall.position.y >= worldHeight/2 || cubicBall.position.y < -worldHeight/2 {
            yVel = -yVel
        }
        cubicBall.position.x += xVel
        cubicBall.position.y += yVel
    }
    
    override func touchMove(location: CGPoint) {
        let pctx = Float(location.x / view.frame.width)
        let relativePosX = pctx * worldWidth - worldWidth/2
        print("relativePosX: \(relativePosX), location: \(location), pctx: \(pctx), frameWidth: \(view.frame.width)")
        paddle.position.x = Float(relativePosX)
    }
}
