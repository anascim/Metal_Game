//
//  Shaders.metal
//  MetalGame
//
//  Created by Alex Nascimento on 16/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct Vertex
{
    float4 position [[position]];
    float4 color;
};

vertex Vertex vertex_function(const device Vertex *vertices[[buffer(0)]],
                              uint vid [[vertex_id]])
{
    return vertices[vid];
}

fragment float4 fragment_function(Vertex inVertex[[stage_in]])
{
    return inVertex.color;
}
