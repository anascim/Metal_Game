//
//  BreakoutScene.swift
//  MetalGame
//
//  Created by Alex Nascimento on 18/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class BreakoutScene : Scene {
    
    var blockGrid: BlockGrid
    let blockFrame: BlockFrame
    let paddle: RectNode
    let cubicBall: RectNode
    
    let redCube: CubeVBO
    let whiteCube: CubeVBO
    let blueCube: CubeVBO
    let greenCube: CubeVBO
    let yellowCube: CubeVBO
    
    lazy var worldWidth = Float(view.drawableSize.width*0.004)
    lazy var worldHeight = Float(view.drawableSize.height*0.004)
    
    var xVel: Float
    var yVel: Float
    
    var level: Int = 1
    var life: UInt8 = 5
    let ballInitPosition: float3 = [0,-2,0]
    let ballInitVelocity: float2 = [0.03, 0.02]
    
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
        yellowCube = CubeVBO(device: device,
                             vertices: Cube.buildVertices(topColor: [0.8,0.8,0,1], bottomColor: [0.4,0.4,0,1]))
        
        blockGrid = BlockGrid(position: [0,0,0], gridAspect: (7,16), layout: LevelManager.getLevel(level), blockSize: [0.4,0.2], vbo1: greenCube, vbo2: yellowCube, vbo3: redCube)
        blockGrid.position = [blockGrid.centralizedOriginX, 3, 0] // note: if position is updated more than once it breaks
        
        blockFrame = BlockFrame(size: [Float(view.drawableSize.width*0.004),
                                    Float(view.drawableSize.height*0.004)], vbo: blueCube)
        // --------------------
        // Setup nodes on scene
        // --------------------
        
        paddle = RectNode(position: [0,-3,0], size: [0.8,0.2], vbo: redCube)
        cubicBall = RectNode(position: ballInitPosition, size: [0.12,0.12], vbo: whiteCube)
        xVel = ballInitVelocity.x
        yVel = ballInitVelocity.y
        
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
            
            if x + r > right { xVel = -abs(xVel) }
            if x - r < left { xVel = abs(xVel) }
            if y + r > top { yVel = -abs(yVel) }
            if y - r < bottom {
                ballOut()
            }
        }
        
        func paddleCollision() {
            if Collision.check(r1: paddle.rect, r2: cubicBall.rect) {
                // pegar valor de -1 até 1, baseado na distância entre o centro da bola e o centro do paddle,
                // com relação às extremidades: centro - width/2 / centro + width/2.
                let ndist: Float = simd_clamp((cubicBall.position.x - paddle.position.x) / (paddle.size.width/2), -1.0, 1.0)
                yVel = abs(yVel)
                let f: Float = 0.02
                // esse valor deve então ser aplicado à velocidade da bola.
                // o paddle soma um vetor de módulo v ao vetor velocidade após mudança de direção.
                xVel = xVel*0.7 + f * ndist
                let sin = sqrtf(1.005 - ndist*ndist)
                yVel = simd_min(yVel*0.7 + f * sin, 0.12) // max y velocity
                cubicBall.position.y = paddle.position.y + paddle.size.height/2 + cubicBall.size.height/2
            }
        }
        
        func blocksCollision() {
            for b in blockGrid.children as! [Block] {
                if Collision.check(r1: cubicBall.rect, r2: b.rect) {
                    b.takeHit()
                    switch Collision.checkDirection(subject: cubicBall.rect, target: b.rect, velocity: [xVel, yVel]) {
                    case .left: xVel = -xVel
                    case .up: yVel = -yVel
                    case .right: xVel = -xVel
                    case .down: yVel = -yVel
                    }
                    return // return garantees to always hit only one block at a time
                }
            }
        }
        
        frameCollision()
        paddleCollision()
        blocksCollision()
        
        cubicBall.position.x += xVel
        cubicBall.position.y += yVel
    }
    
    func buildLevel(level: String) {
        rootNode.removeChild(blockGrid)
        blockGrid = BlockGrid(position: [0,0,0], gridAspect: (7,16), layout: level, blockSize: [0.4,0.2], vbo1: greenCube, vbo2: yellowCube, vbo3: redCube)
        blockGrid.position = [blockGrid.centralizedOriginX, 3, 0] // note: if position is updated more than once it breaks
        rootNode.addChild(blockGrid)
    }
    
    func ballOut() {
        life -= 1
        if life == 0 {
            level += 1
            if level >= LevelManager.levels.count { level = 1 }
            buildLevel(level: LevelManager.getLevel(level))
            life = 5
            return
        }
        cubicBall.position = ballInitPosition
        let a: [Float] = [-1, 1]
        xVel = ballInitVelocity.x * a.randomElement()!
        yVel = ballInitVelocity.y
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
