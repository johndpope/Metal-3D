//
//  Triangle.swift
//  HelloMetal
//
//  Created by Chris on 2015-01-27.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation
import Metal

class Triangle: Node {
    
    init(device: MTLDevice) {
        
        //let V0 = Vertex(x: 0.0, y: 1.0, z: 0.0, r: 1.0, g: 0.0, b: 0.0, a: 0.0)     // top
        //let V1 = Vertex(x: -1.0, y: -1.0, z: 0.0, r: 0.0, g: 1.0, b: 0.0, a: 0.0)   // bottom-left
        //let V2 = Vertex(x: 1.0, y: -1.0, z: 0.0, r: 0.0, g: 0.0, b: 1.0, a: 0.5)    // bottom-right
        
        let V0 = Vertex(position: Vector(x: -1.0, y: -1.0, z: 0.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 1.0, g: 0.0, b: 0.0, a: 0.0)
        let V1 = Vertex(position: Vector(x: 1.0, y: -1.0, z: 0.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 0.0, g: 1.0, b: 0.0, a: 0.0)
        let V2 = Vertex(position: Vector(x: -1.0, y: 1.0, z: 0.0), normal: Vector(x: 0.0, y: 0.0, z: 0.0), r: 0.0, g: 0.0, b: 1.0, a: 0.5)
        
        let verticesArray = [V0, V1, V2]
        super.init(name: "Triangle", vertices: verticesArray, device: device)
    }
}
