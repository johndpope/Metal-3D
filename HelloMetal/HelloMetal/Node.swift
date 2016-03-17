//
//  Node.swift
//  HelloMetal
//
//  Created by Chris on 2015-01-26.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation
import Metal
import QuartzCore
import SceneKit

func computeNormals(vertices: [Vertex])->[Float]{
    var normalData = [Float]()
    for var i = 0; i < vertices.count; i += 3 {
        let v1 = vertices[i].position - vertices[i + 1].position
        let v2 = vertices[i].position - vertices[i + 2].position
        let normal = (v1 ** v2).abs()
        normalData += normal.floatBuffer()
    }
    return normalData
}

class Node {
    let name: String
    //let numTexCoords: Int
    var vertexCount: Int
    var vertexBuffer: MTLBuffer
    var normalBuffer: MTLBuffer
    var uniformBuffer: MTLBuffer?
    //var texCoordBuffer: MTLBuffer?
    var device: MTLDevice
    var time: CFTimeInterval = 0.0
    
    var positionX: Float
    var positionY: Float
    var positionZ: Float
    
    var rotation: Float
    
    var rotationX: Float
    var rotationY: Float
    var rotationZ: Float
    
    var scaleX: Float
    var scaleY: Float
    var scaleZ: Float
        
    init(name: String, vertices: [Vertex], device: MTLDevice) {
        //numTexCoords = 3//6
        /*let texCoords =
        [
            [0.0,0.0],
            [1.0,0.0],
            [0.0,1.0],
            
            [1.0,0.0],
            [0.0,1.0],
            [1.0,1.0]
        ]*/
        
        //var vertexData = Array<Float>()
        var vertexData = [Float]()
        for vertex in vertices {
            vertexData += vertex.floatBuffer()
        }
        
        var normalData = computeNormals(vertices)
        /*var normalData = [Float]()
        for var i = 0; i < vertices.count; i += 3 {
            let v1 = vertices[i].position - vertices[i + 1].position
            let v2 = vertices[i].position - vertices[i + 2].position
            let normal = v1 ** v2
            normalData += normal.floatBuffer()
        }*/
        
        let vertexDataSize = vertexData.count * sizeofValue(vertexData[0])
        let normalDataSize = normalData.count * sizeofValue(normalData[0])
        
        vertexBuffer = device.newBufferWithBytes(vertexData, length: vertexDataSize, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        normalBuffer = device.newBufferWithBytes(normalData, length: normalDataSize, options: MTLResourceOptions.CPUCacheModeDefaultCache)
        //texCoordBuffer = device.newBufferWithBytes(texCoords, length: numTexCoords * sizeof(Float), options: MTLResourceOptions.OptionCPUCacheModeWriteCombined)
        
        self.name = name
        self.device = device
        vertexCount = vertices.count
        
        positionX = 0.0
        positionY = 0.0
        positionZ = 0.0
        
        rotation = 0.0
        
        rotationX = 0.0
        rotationY = 0.0
        rotationZ = 0.0
        
        scaleX = 1.0
        scaleY = 1.0
        scaleZ = 1.0
        
    }
    
    
    
    func modelMatrix() -> SCNMatrix4 {
        var matrix = SCNMatrix4MakeTranslation(positionX, positionY, positionZ)
        matrix = SCNMatrix4Rotate(matrix, rotation, rotationX, rotationY, rotationZ)
        matrix = SCNMatrix4Scale(matrix, scaleX, scaleY, scaleZ)
        
        return matrix
    }
    
    func projectionMatrix(projectionMatrix: SCNMatrix4) -> SCNMatrix4 {
    
        return projectionMatrix
    }
    
    func updateWithDelta(delta: CFTimeInterval){
        time += delta
    }
    
    func render(commandQueue: MTLCommandQueue, pipelineState: MTLRenderPipelineState, drawable: CAMetalDrawable, parentModelViewMatrix: SCNMatrix4, projectionMatrix: SCNMatrix4, clearColor: MTLClearColor?, texture: MTLTexture){
        
        let renderPassDescriptor = MTLRenderPassDescriptor()
        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        renderPassDescriptor.colorAttachments[0].loadAction = .Clear
        renderPassDescriptor.colorAttachments[0].clearColor = clearColor!
        renderPassDescriptor.colorAttachments[0].storeAction = .Store
        
        let commandBuffer = commandQueue.commandBuffer()

        let renderEncoderOpt = commandBuffer.renderCommandEncoderWithDescriptor(renderPassDescriptor)
        let renderEncoder = renderEncoderOpt
            renderEncoder.setRenderPipelineState(pipelineState)

            var modelMatrix = self.modelMatrix()
            modelMatrix = SCNMatrix4Mult(modelMatrix, parentModelViewMatrix)
            var projMatrix = self.projectionMatrix(projectionMatrix)
            
            uniformBuffer = device.newBufferWithLength(sizeof(SCNMatrix4) * 2, options: MTLResourceOptions.CPUCacheModeDefaultCache)
            let bufferPointer  = uniformBuffer?.contents()
            memcpy(bufferPointer!, &modelMatrix, Int(sizeof(Float) * 16))
            memcpy(bufferPointer! + Int(sizeof(Float) * 16), &projMatrix, Int(sizeof(Float) * 16))
            //let texCoordBufferPointer = texCoordBuffer?.contents()
            //memcpy(texCoordBufferPointer!, &texCoordBuffer, Int(sizeof(Float) * numTexCoords))

            renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, atIndex: 0)
            renderEncoder.setVertexBuffer(uniformBuffer, offset: 0, atIndex: 1)
            renderEncoder.setVertexBuffer(normalBuffer, offset: 0, atIndex: 2)
            //renderEncoder.setVertexBuffer(texCoordBuffer, offset: 0, atIndex: 2)
            renderEncoder.setFragmentTexture(texture, atIndex: 0)
            renderEncoder.drawPrimitives(.Triangle, vertexStart: 0, vertexCount: vertexCount, instanceCount: vertexCount / 3)
            renderEncoder.endEncoding()
        
        
        commandBuffer.presentDrawable(drawable)
        commandBuffer.commit()

    }
}