//
//  Matrix.swift
//  HelloMetal
//
//  Created by Chris on 2015-02-02.
//  Copyright (c) 2015 Chris. All rights reserved.
//

import Foundation
import SceneKit

struct Matrix {
    
    let rows: Int, columns: Int
    var grid: [Double]
    
    init(rows: Int, columns: Int) {
        self.rows = rows
        self.columns = columns
        grid = Array(count: rows * columns, repeatedValue: 0.0)
    }
    
    func indexIsValid(row: Int, column: Int) -> Bool {
        return row >= 0 && row < rows
            && column >= 0 && column < columns
    }
        
    subscript(row: Int, column: Int) -> Double {
        get {
            assert(indexIsValid(row, column: column), "Index out of range")
            return grid[(row * columns) + column]
        }
        set {
            assert(indexIsValid(row, column: column), "Index out of range")
            grid[(row * columns) + column] = newValue
        }
    }
    
}
