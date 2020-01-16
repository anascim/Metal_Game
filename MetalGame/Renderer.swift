//
//  Renderer.swift
//  MetalGame
//
//  Created by Alex Nascimento on 15/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

struct Vertex {
    var position: vector_float4
    var color: vector_float4
}

class Renderer: NSObject, MTKViewDelegate {
   
    let device: MTLDevice
    let commandQueue: MTLCommandQueue
    let vertexBuffer: MTLBuffer
    let renderPipeline: MTLRenderPipelineState
    
    let vertices: [Vertex] = [
        Vertex(position: [-0.5, -0.5, 0.0, 1.0], color: [1.0, 0.0, 0.0, 1.0]),
        Vertex(position: [0.0, 0.5, 0.0, 1.0], color: [0.0, 1.0, 0.0, 1.0]),
        Vertex(position: [0.5, -0.5, 0.0, 1.0], color: [0.0, 0.0, 1.0, 1.0])
    ]
    
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
        
        if let newVertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.size * vertices.count, options: []) {
            vertexBuffer = newVertexBuffer
        } else { fatalError("Couldn't make vertex buffer!") }
        
        renderPipeline = Renderer.buildRenderPipeline(device: device, mtkView: mtkView)
        
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
        
        do {
            return try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("Couldn't make MTLRenderPipelineState: \(error)")
        }
    }
    
    func draw(in view: MTKView) {
        guard let commandBuffer = commandQueue.makeCommandBuffer() else { return }
        if let renderPassDescriptor = view.currentRenderPassDescriptor, let drawable = view.currentDrawable {
            renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0.7, green: 0.12, blue: 0.0, alpha: 1.0)
            guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
            commandEncoder.setRenderPipelineState(renderPipeline)
            commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
            commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
            commandEncoder.endEncoding()
            commandBuffer.present(drawable)
            commandBuffer.commit()
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
