//
//  Vector.swift
//  HelloMetal
//
//  Created by Chris on 2015-12-27.
//  Copyright © 2015 Chris. All rights reserved.
//

import Foundation

func - (left: Vector, right: Vector) -> Vector{
    return Vector(  x: left.x - right.x,
                    y: left.y - right.y,
                    z: left.z - right.z)
}

func * (left: Vector, right: Vector) -> Float{
    return left.x * right.x + left.y * right.y + left.z * right.z
}

infix operator ** {}

func ** (left: Vector, right: Vector) -> Vector{
    return Vector(  x: left.y * right.z - left.z * right.y,
                    y: left.z * right.x - left.x * right.z,
                    z: left.x * right.y - left.y * right.x)
}

class Vector {
    var x, y, z: Float
    
    init(x:Float, y:Float, z:Float){
        self.x = x
        self.y = y
        self.z = z
    }
    
    func norm()->Float{
        return sqrtf(pow(x, 2) + pow(y, 2) + pow(y, 2))
    }
    
    func abs()->Vector{
        return Vector(x: sqrt(x*x), y: sqrt(y*y), z: sqrt(z*z))
    }
    
    func floatBuffer() -> [Float] {
        return [x, y, z]
    }
    
    
}

