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
        
        
//        blockGrid = BlockGrid(device: device, position: [-1.2,3,0])
        blockGrid = BlockGrid(position: [-1.2,3,0], gridAspect: (7,16), blockSize: [0.4,0.2], vbo: greenCube)
        blockFrame = BlockFrame(size: [Float(view.drawableSize.width*0.004),
                                    Float(view.drawableSize.height*0.004)], vbo: blueCube)
        // --------------------
        // Setup nodes on scene
        // --------------------
        
        paddle = RectNode(position: [0,-3,0], size: [0.8,0.2], vbo: redCube)
        cubicBall = RectNode(position: [0,-2,0], size: [0.12,0.12], vbo: whiteCube)
        
        
        super.init(device: device, view: view)
        
        rootNode.addChild(paddle)
        rootNode.addChild(cubicBall)
        rootNode.addChild(blockFrame)
        rootNode.addChild(blockGrid)
    }
    
    override func update() {
        
        let x = cubicBall.position.x
        let y = cubicBall.position.y
        let r = cubicBall.size.width/2
        
        func frameCollision() {
            let right = blockFrame.right.position.x - blockFrame.right.size.width/2
            let left = blockFrame.left.position.x + blockFrame.left.size.width/2
            let top = blockFrame.top.position.y - blockFrame.top.size.height/2
            let bottom =  blockFrame.bottom.position.y + blockFrame.bottom.size.height/2
            
            if x + r > right || x - r < left {
                xVel = -xVel
            }
            if y + r > top || y - r < bottom {
                yVel = -yVel
            }
        }
        
        func paddleCollision() {
            let right = paddle.position.x + paddle.size.width/2
            let left = paddle.position.x - paddle.size.width/2
            let top = paddle.position.y + paddle.size.height/2
            let bottom = paddle.position.y - paddle.size.height/2
            
            if x + r > left && x - r < right && y + r > bottom && y - r < top {
                yVel = -yVel
            }
        }
        
        frameCollision()
        paddleCollision()
        
        cubicBall.position.x += xVel
        cubicBall.position.y += yVel
    }
    
    override func touchBegan(location: CGPoint) {
        let pctx = Float(location.x / view.frame.width)
        let relativePosX = pctx * worldWidth - worldWidth/2
        paddle.position.x = Float(relativePosX)
//      print("relativePosX: \(relativePosX), location: \(location), pctx: \(pctx), frameWidth: \(view.frame.width)")
    }
    
    override func touchMoved(location: CGPoint) {
        let pctx = Float(location.x / view.frame.width)
        let relativePosX = pctx * worldWidth - worldWidth/2
        paddle.position.x = Float(relativePosX)
    }
}
