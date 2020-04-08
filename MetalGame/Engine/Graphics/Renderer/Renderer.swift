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

/// The Renderer is the system used to render a single scene on the screen.
/// It implements the MTKViewDelegate protocol, which is responsible for making the draw calls for the view.

class Renderer: NSObject {
   
    let device: MTLDevice
    let view: MTKView
    let commandQueue: MTLCommandQueue
    var standardPipeline: StandardPipeline
    var viewProjectionMatrix: float4x4
    
    var time: Float = 0
    
    var scene: Scene?
    
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
        
        standardPipeline = StandardPipeline(device: device, view: view)
        viewProjectionMatrix = ViewProjection.buildViewProjectionMatrix(mtkView: view)
        
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    
    func draw(in view: MTKView) {
        time += 1.0/Float(view.preferredFramesPerSecond)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let drawable = view.currentDrawable else { return }
    
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0)
    
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        commandEncoder.setDepthStencilState(standardPipeline.depthStencilState)
        commandEncoder.setRenderPipelineState(standardPipeline.pipelineState)
        
        scene?.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
        
        commandEncoder.endEncoding()
    
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
