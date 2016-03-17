//
//  Cube.swift
//  HelloMetal
//
//  Created by Chris on 2015-02-01.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation
import UIKit
import Metal

class Cube: Node {
    
    init(device: MTLDevice){
        
        // Front
        let A = Vertex(position: Vector(x: -1.0, y: 1.0, z: 1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let B = Vertex(position: Vector(x: -1.0, y: -1.0, z: 1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let C = Vertex(position: Vector(x: 1.0, y: -1.0, z: 1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let D = Vertex(position: Vector(x: 1.0, y: 1.0, z: 1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        
        // Back
        let Q = Vertex(position: Vector(x: -1.0, y: 1.0, z: -1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let R = Vertex(position: Vector(x: 1.0, y: 1.0, z: -1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let S = Vertex(position: Vector(x: -1.0, y: -1.0, z: -1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        let T = Vertex(position: Vector(x: 1.0, y: -1.0, z: -1.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 1.0)
        
        let verticesArray:Array<Vertex> = [
            A,B,C ,A,C,D, // Front
            R,T,S ,Q,R,S, // Back
            
            Q,S,B ,Q,B,A,
            D,C,T ,D,T,R,
            
            Q,A,D ,Q,D,R,
            B,S,T ,B,T,C,
        ]
        super.init(name: "Cube", vertices: verticesArray, device: device)
    }
    
    override func updateWithDelta(delta: CFTimeInterval) {
        super.updateWithDelta(delta)
        
        //var secsPerMove: Float = 6.0
        
        //rotation = sinf(Float(time) * 2.0 * Float(M_PI) / secsPerMove)
        rotationY = 1.0
    }
}
