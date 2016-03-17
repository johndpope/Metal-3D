//
//  Shaders.metal
//  HelloMetal
//
//  Created by Chris on 2015-01-24.
//  Copyright (c) 2015 Chris. All rights reserved.
//

#include <metal_stdlib>
//#include <metal_geometric>

using namespace metal;

constant float3 lightDirection(1.577, 0.577, 0.577);

struct Uniforms{
    float4x4 modelMatrix;
    float4x4 projectionMatrix;
    //float3x3 normalMatrix;
};

struct VertexIn{
    packed_float3 position;
    packed_float3 normal;
    packed_float4 color;
};

struct VertexOut{
    float4 position [[position]];
    float4 color;
};

struct ProjectedVertex{
    float4 position [[position]];
    //float3 eye;
    float3 normal;
    float4 color;
};

struct VertexInOut{
    float4 position [[position]];
    float2 texCoord [[user(textureCoord)]];
};

vertex ProjectedVertex basic_vertex(const device VertexIn* vertex_array [[buffer(0)]],
                                    const device Uniforms& uniforms [[buffer(1)]],
                                    const device packed_float3* normals [[buffer(2)]],
                                    unsigned int vid [[vertex_id]]){
    ProjectedVertex vertexOut;
    float4x4 mv_Matrix = uniforms.modelMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    VertexIn VertexIn = vertex_array[vid];
    int normal_id = vid / 3;
    
    vertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position, 1);
    vertexOut.normal = normals[normal_id];
    vertexOut.color = VertexIn.color;
    return vertexOut;
}

fragment half4 light_fragment(ProjectedVertex projVert [[stage_in]]){
    float intensity = saturate(dot(normalize(projVert.normal), lightDirection));
    return half4(intensity*projVert.color[0], intensity*projVert.color[1], intensity*projVert.color[2], 1*projVert.color[3]);
}

/*vertex VertexOut basic_vertex_old( const device VertexIn* vertex_array [[buffer(0)]],
                              const device Uniforms& uniforms [[buffer(1)]],
                              const device packed_float3& normals [[buffer(2)]],
                           unsigned int vid [[vertex_id]]){
    
    float4x4 mv_Matrix = uniforms.modelMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    VertexIn VertexIn = vertex_array[vid];
    
    VertexOut VertexOut;
    VertexOut.position = proj_Matrix * mv_Matrix * float4(VertexIn.position, 1);
    VertexOut.color = VertexIn.color;
    
    return VertexOut;
}*/

fragment half4 basic_fragment(VertexOut interpolated [[stage_in]]){
    return half4(interpolated.color[0], interpolated.color[1], interpolated.color[3] ,interpolated.color[3]);
}

/*vertex VertexInOut texturedQuadVertex(constant float4   *position       [[buffer(0)]],
                               constant packed_float2   *textureCoords  [[buffer(1)]],
                               constant float4x4        *mvpMatrix      [[buffer(2)]],
                               uint                     vid             [[vertex_id]])
{
    VertexInOut outVertices;
    
    outVertices.position = *mvpMatrix * position[vid];
    
    outVertices.texCoord = textureCoords[vid];
    
    return outVertices;
}*/

vertex VertexInOut texturedQuadVertex(const device VertexIn             *vertex_array        [[buffer(0)]],
                                      const device Uniforms&            uniforms             [[buffer(1)]],
                                      const device packed_float2        *textureCoords       [[buffer(2)]],
                                      uint                              vid                  [[vertex_id]])
{
    float4x4 mv_Matrix = uniforms.modelMatrix;
    float4x4 proj_Matrix = uniforms.projectionMatrix;
    
    VertexIn VertexIn = vertex_array[vid];
    
    VertexInOut outVertices;
    
    outVertices.position = proj_Matrix * mv_Matrix * float4(VertexIn.position, 1);
    outVertices.texCoord = textureCoords[vid];
    
    return outVertices;
}


fragment half4 texturedQuadFragment(VertexInOut     inFrag  [[stage_in]],
                                    texture2d<half> tex2D   [[texture(0)]])
{
    constexpr sampler quad_sampler;
    half4 color = tex2D.sample(quad_sampler, inFrag.texCoord);
    
    return color;
}