//
//  Keyboard.swift
//  VOWL
//
//  Created by Daniel Clelland on 15/11/15.
//  Copyright © 2015 Daniel Clelland. All rights reserved.
//

import UIKit

class Keyboard {
    
    struct Coordinates {
        var leftAxis: Int
        var rightAxis: Int
        
        init(withLeftAxis leftAxis: Int, rightAxis: Int) {
            self.leftAxis = leftAxis
            self.rightAxis = rightAxis
        }
    }
    
    var centerPitch = 60
    
    var leftAxisInterval = 4
    var rightAxisInterval = 7
    
    var horizontalRadius = 4
    var verticalRadius = 5
    
    // MARK: - Counts
    
    func numberOfRows() -> Int {
        return verticalRadius * 2 + 1
    }
    
    func numberOfKeysInRow(row: Int) -> Int {
        return self.rowIsOffset(row) ? horizontalRadius : horizontalRadius + 1
    }
    
    // MARK: - Keys
    
    func keyAtIndex(index: Int, inRow row: Int) -> KeyboardKey {
        let coordinates = self.coordinatesForIndex(index, inRow: row)
        
        let pitch = self.pitchForCoordinates(coordinates)
        let path = self.pathForCoordinates(coordinates)
        
        return KeyboardKey.init(withPitch: pitch, path: path)
    }
    
    // MARK: - Coordinates
    
    private func coordinatesForIndex(index: Int, inRow row: Int) -> Coordinates {
        let x = self.rowIsOffset(row) ? index * 2 + 1 : index * 2
        let y = row
        
        let verticalOffset = verticalRadius - y
        let horizontalOffset = horizontalRadius - x
        
        let leftAxis = Float(verticalOffset + horizontalOffset) / 2
        let rightAxis = Float(verticalOffset - horizontalOffset) / 2
        
        return Coordinates(withLeftAxis: Int(leftAxis), rightAxis: Int(rightAxis))
    }
    
    private func rowIsOffset(row: Int) -> Bool {
        if horizontalRadius.parity() == verticalRadius.parity() {
            return row.isOdd()
        } else {
            return row.isEven()
        }
    }
    
    // MARK: - Transforms
    
    private func pitchForCoordinates(coordinates: Coordinates) -> Int {
        return centerPitch + coordinates.leftAxis * leftAxisInterval + coordinates.rightAxis * rightAxisInterval
    }
    
    private func pathForCoordinates(coordinates: Coordinates) -> UIBezierPath {
        let location = self.locationForCoordinates(coordinates)
        
        let horizontalKeyRadius = 1.0 / (2.0 * CGFloat(horizontalRadius))
        let verticalKeyRadius = 1.0 / (2.0 * CGFloat(verticalRadius))
        
        let path = UIBezierPath()
        
        path.moveToPoint(CGPointMake(location.x, location.y - verticalKeyRadius))
        path.addLineToPoint(CGPointMake(location.x + horizontalKeyRadius, location.y))
        path.addLineToPoint(CGPointMake(location.x, location.y + verticalKeyRadius))
        path.addLineToPoint(CGPointMake(location.x - horizontalKeyRadius, location.y))
        path.closePath()
        
        return path
    }
    
    private func locationForCoordinates(coordinates: Coordinates) -> CGPoint {
        let horizontalKeyRadius = 1.0 / CGFloat(horizontalRadius) / 2.0
        let verticalKeyRadius = 1.0 / CGFloat(verticalRadius) / 2.0
        
        let leftAxisDifference = CGVectorMake(-horizontalKeyRadius * CGFloat(coordinates.leftAxis), -verticalKeyRadius * CGFloat(coordinates.leftAxis))
        let rightAxisDifference = CGVectorMake(horizontalKeyRadius * CGFloat(coordinates.rightAxis), -verticalKeyRadius * CGFloat(coordinates.rightAxis))
        
        return CGPointMake(0.5 + leftAxisDifference.dx + rightAxisDifference.dx, 0.5 + leftAxisDifference.dy + rightAxisDifference.dy)
    }
}
