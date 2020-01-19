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

struct Vertex {
    var position: vector_float4
    var color: vector_float4
}

struct Uniforms {
    var modelViewProjectionMatrix: float4x4
    var xOffset: Float
}

class Renderer: NSObject, MTKViewDelegate {
   
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let vertexBuffer: MTLBuffer
    let indexBuffer: MTLBuffer
    var uniforms = Uniforms(modelViewProjectionMatrix: float4x4.init(), xOffset: 0.3)
    let renderPipeline: MTLRenderPipelineState
    
    var depthState: MTLDepthStencilState
    var time: Float = 0
    
    let cube = Cube()
    
    init?(mtkView: MTKView){
        if let mtkDevice = mtkView.device {
            device = mtkDevice
        } else {
            print("MTKView doesn't have a device")
            return nil
        }
        
        if let newCommandQueue = device.makeCommandQueue() {
            commandQueue = newCommandQueue
        } else { fatalError("Couldn't make command queue!") }
        
        if let newVertexBuffer = device.makeBuffer(bytes: cube.vertices, length: MemoryLayout<Vertex>.size * cube.vertices.count, options: .cpuCacheModeWriteCombined) {
            vertexBuffer = newVertexBuffer
        } else { fatalError("Couldn't make vertex buffer!") }
        
        if let newIndexBuffer = device.makeBuffer(bytes: cube.indices, length: MemoryLayout<UInt16>.size * cube.indices.count, options: .cpuCacheModeWriteCombined) {
            indexBuffer = newIndexBuffer
        } else { fatalError("Couldn't make index buffer!") }
        renderPipeline = Renderer.buildRenderPipeline(device: device, mtkView: mtkView)
        depthState = Renderer.buildDepthState(device: device)
        super.init()
    }
    
    static func buildRenderPipeline(device: MTLDevice, mtkView: MTKView) -> MTLRenderPipelineState {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Couldn't find default library!")
        }
        let vertexFunction = library.makeFunction(name: "vertex_function")
        let fragmentFunction = library.makeFunction(name: "fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
        renderPipelineDescriptor.depthAttachmentPixelFormat = .depth32Float
        
        do {
            return try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("Couldn't make MTLRenderPipelineState: \(error)")
        }
    }
    
    static func buildDepthState(device: MTLDevice) -> MTLDepthStencilState {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        
        return device.makeDepthStencilState(descriptor: depthStencilDescriptor)!
    }
    
    func update(in view: MTKView) {
        time += 1.0/Float(view.preferredFramesPerSecond)
        
        let scaleFactor = sinf(time * 5) * 0.25 + 1
        let rotationAmount = time
        let rotationX = float4x4(rotationAbout: [1, 0, 0], by: rotationAmount)
        let rotationY = float4x4(rotationAbout: [0, 1, 0], by: rotationAmount)
        let scale = float4x4(scaleBy: scaleFactor)
        let modelMatrix = rotationX * rotationY * scale
        
        let cameraTranslation = SIMD3<Float>(0, 0,-5)
        let viewMatrix = float4x4(translationBy: cameraTranslation)
        
        let aspect: Float  = Float(view.drawableSize.width / view.drawableSize.height)
        let fov: Float = (2*Float.pi)/5
        let near: Float = 1
        let far: Float = 100
        let projectionMatrix = float4x4(perspectiveProjectionFov: fov, aspectRatio: aspect, nearZ: near, farZ: far)
        
        let mvpMatrix = projectionMatrix * viewMatrix * modelMatrix
        self.uniforms = Uniforms(modelViewProjectionMatrix: mvpMatrix, xOffset: 0)
    }
    
    func draw(in view: MTKView) {
        update(in: view)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        if let renderPassDescriptor = view.currentRenderPassDescriptor, let drawable = view.currentDrawable {
            renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0.7, green: 0.12, blue: 0.0, alpha: 1.0)
            guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            commandEncoder.setRenderPipelineState(renderPipeline)
            commandEncoder.setDepthStencilState(depthState)
            commandEncoder.setFrontFacing(.counterClockwise)
            commandEncoder.setCullMode(.back)
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder.setVertexBytes(&uniforms, length: MemoryLayout<Uniforms>.stride, index: 1)
            commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: cube.indices.count, indexType: .uint16, indexBuffer: indexBuffer, indexBufferOffset: 0)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
