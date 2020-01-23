//
//  Renderer.swift
//  MetalGame
//
//  Created by Alex Nascimento on 15/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

// This file was heavily based on the book by Warren More, Metal by Example:
// https://metalbyexample.com/

import MetalKit

class Renderer : NSObject {
   
    let device: MTLDevice
    let view: MTKView
    let commandQueue: MTLCommandQueue
    
    var pipelineState: MTLRenderPipelineState!
    var depthStencilState: MTLDepthStencilState?
    
    var viewProjectionMatrix: matrix_float4x4
    
    var blockGrid: BlockGrid
    
    var cube: BufferedCube
    var cube2: BufferedCube
    var cube3: BufferedCube
    
    var uniforms1: Uniforms!
    var uniforms2: Uniforms!
    var uniforms3: Uniforms!
    
    var time: Float = 0
    
    init?(mtkView: MTKView){
        self.view = mtkView
        if let mtkDevice = mtkView.device {
            self.device = mtkDevice
        } else {
            print("MTKView doesn't have a device")
            return nil
        }
        
        if let newCommandQueue = device.makeCommandQueue() {
            commandQueue = newCommandQueue
        } else { fatalError("Couldn't make command queue!") }
        
        blockGrid = BlockGrid(device: device, position: [0,0,0])
        
        cube = BufferedCube(device: device, position:[0,0,0])
        cube2 = BufferedCube(device: device, position:[0,0,0])
        cube3 = BufferedCube(device: device, position:[0,0,0])
        
        viewProjectionMatrix = Renderer.buildViewProjectionMatrix(mtkView: view)
        
        super.init()
        self.buildPipeline()
        self.buildDepthState()
    }
    
    private func buildPipeline() {
        guard let library = self.device.makeDefaultLibrary() else {
            fatalError("Couldn't find default library!")
        }
        let vertexFunction = library.makeFunction(name: "vertex_function")
        let fragmentFunction = library.makeFunction(name: "fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = self.view.colorPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        let vertexDescriptor = MTLVertexDescriptor()
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<SIMD3<Float>>.stride
        vertexDescriptor.attributes[1].bufferIndex = 0
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        renderPipelineDescriptor.vertexDescriptor = vertexDescriptor
        do {
            try self.pipelineState = device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("Couldn't make MTLRenderPipelineState: \(error)")
        }
    }
    
    private func buildDepthState() {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        
        self.depthStencilState = self.device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
    
    static func buildViewProjectionMatrix(mtkView: MTKView) -> matrix_float4x4 {
        let cameraTranslation = SIMD3<Float>(0, 0,-5)
        let viewMatrix = float4x4(translationBy: cameraTranslation)
        
        let aspect: Float  = Float(mtkView.drawableSize.width / mtkView.drawableSize.height)
        let fov: Float = (2*Float.pi)/5
        let near: Float = 1
        let far: Float = 100
        let projectionMatrix = float4x4(perspectiveProjectionFov: fov, aspectRatio: aspect, nearZ: near, farZ: far)
        
        let viewProjectionMatrix = projectionMatrix * viewMatrix
        return viewProjectionMatrix
    }
    
    func updateUniforms(in view: MTKView) {
        time += 1.0/Float(view.preferredFramesPerSecond)
        
        let rotationX = matrix_float4x4(rotationAbout: [1,0,0], by: time)
        let rotationY = matrix_float4x4(rotationAbout: [0,1,0], by: time)
        let scale = matrix_float4x4(scaleBy: 0.1)
        let pulsating = sin(time*4)*0.5 + 3
        let pulsatingScale = matrix_float4x4(scaleBy: pulsating)
        let pulsatingRotationX = matrix_float4x4(rotationAbout: [1,0,0], by: pulsating)
        let pulsatingRotationY = matrix_float4x4(rotationAbout: [0,1,0], by: pulsating)
        let modelMatrix1 = rotationX * rotationY * matrix_float4x4(translationBy: [-1, 1, 0]) * scale
        let modelMatrix2 = matrix_float4x4(translationBy: [1, 1, 0]) * scale * rotationX * rotationY
        let modelMatrix3 = matrix_float4x4(translationBy: [0, 0, 0]) * scale * pulsatingScale * pulsatingRotationX * pulsatingRotationY
        
        let mvpMatrix1 = viewProjectionMatrix * modelMatrix1
        let mvpMatrix2 = viewProjectionMatrix * modelMatrix2
        let mvpMatrix3 = viewProjectionMatrix * modelMatrix3
        self.uniforms1 = Uniforms(modelViewProjectionMatrix: mvpMatrix1, xOffset: 0)
        self.uniforms2 = Uniforms(modelViewProjectionMatrix: mvpMatrix2, xOffset: 0)
        self.uniforms3 = Uniforms(modelViewProjectionMatrix: mvpMatrix3, xOffset: 0)
    }
}

extension Renderer : MTKViewDelegate {
    
    func draw(in view: MTKView) {
        updateUniforms(in: view)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let drawable = view.currentDrawable else { return }
    
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0.7, green: 0.12, blue: 0.0, alpha: 1.0)
    
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        commandEncoder.setDepthStencilState(depthStencilState)
        commandEncoder.setRenderPipelineState(pipelineState)
        
        commandEncoder.setVertexBuffer(cube.vertexBuffer, offset: 0, index: 0)
        commandEncoder.setVertexBytes(&uniforms1, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)

        commandEncoder.setVertexBytes(&uniforms2, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)
        
        commandEncoder.setVertexBytes(&uniforms3, length: MemoryLayout<Uniforms>.stride, index: 1)
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: cube.indexBuffer, indexBufferOffset: 0)
        
        blockGrid.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix)
        
        commandEncoder.endEncoding()
    
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
