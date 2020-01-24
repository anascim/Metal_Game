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
    
    var standardPipeline: StandardPipeline
    
    var viewProjectionMatrix: float4x4
    
    var blockGrid: BlockGrid
    var blockFrame: BlockFrame
    
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
        
        standardPipeline = StandardPipeline(device: device, view: view)
        viewProjectionMatrix = ViewProjection.buildViewProjectionMatrix(mtkView: view)
        
        blockGrid = BlockGrid(device: device, position: [-1.2,3,0])
        blockFrame = BlockFrame(device: device, size: [2.5,6])
        
        super.init()
    }
}

extension Renderer : MTKViewDelegate {
    
    func draw(in view: MTKView) {
        time += 1.0/Float(view.preferredFramesPerSecond)
        
        guard let commandBuffer = commandQueue.makeCommandBuffer(),
        let renderPassDescriptor = view.currentRenderPassDescriptor,
        let drawable = view.currentDrawable else { return }
    
        renderPassDescriptor.colorAttachments[0].clearColor = .init(red: 0.7, green: 0.12, blue: 0.0, alpha: 1.0)
    
        guard let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else { return }
        
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        commandEncoder.setDepthStencilState(standardPipeline.depthStencilState)
        commandEncoder.setRenderPipelineState(standardPipeline.pipelineState)
        
        blockGrid.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
        blockFrame.render(commandEncoder: commandEncoder, viewProjectionMatrix: viewProjectionMatrix, time: time)
        
        commandEncoder.endEncoding()
    
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
}
