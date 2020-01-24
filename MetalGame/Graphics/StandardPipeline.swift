//
//  StandardPipeline.swift
//  MetalGame
//
//  Created by Alex Nascimento on 23/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

import MetalKit

class StandardPipeline {
    
    let device: MTLDevice
    let view: MTKView
    public var pipelineState: MTLRenderPipelineState
    public var depthStencilState: MTLDepthStencilState
    
    init(device: MTLDevice, view: MTKView) {
        self.device = device
        self.view = view
        do {
            self.pipelineState = try StandardPipeline.buildPipeline(device: device, view: view)
        } catch {
            fatalError("StandardPipeline failed to initialize. Error: \(error)")
        }
        self.depthStencilState = StandardPipeline.buildDepthState(device: device)
    }
    
    static func buildPipeline(device: MTLDevice, view: MTKView) throws -> MTLRenderPipelineState {
        guard let library = device.makeDefaultLibrary() else {
            fatalError("Couldn't find default library!")
        }
        let vertexFunction = library.makeFunction(name: "vertex_function")
        let fragmentFunction = library.makeFunction(name: "fragment_function")
        
        let renderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = view.colorPixelFormat
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
            return try device.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError("StandardPipeline:buildPipeline() Couldn't make MTLRenderPipelineState: \(error)")
        }
    }
    
    static func buildDepthState(device: MTLDevice) -> MTLDepthStencilState {
        let depthStencilDescriptor = MTLDepthStencilDescriptor()
        depthStencilDescriptor.isDepthWriteEnabled = true
        depthStencilDescriptor.depthCompareFunction = .less
        
        if let state = device.makeDepthStencilState(descriptor: depthStencilDescriptor) {
            return state
        } else { fatalError("StandardPipeline:buildDepthState() device returned nil DepthStencilState!") }
    }
}
