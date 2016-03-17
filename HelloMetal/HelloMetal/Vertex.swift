//
//  Vertex.swift
//  HelloMetal
//
//  Created by Chris on 2015-01-26.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation

struct Vertex{
    var position: Vector
    var normal: Vector
    var r, g, b, a: Float   // color data
    func floatBuffer() -> [Float] {
        return [position.x, position.y, position.z, normal.x, normal.y, normal.z, r, g, b, a]
    }
};