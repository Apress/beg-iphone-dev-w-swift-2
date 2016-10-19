//
//  Geometry.swift
//  TextShooter
//
//  Created by Kim Topley on 11/9/15.
//  Copyright © 2015 Apress Inc. All rights reserved.
//

import UIKit

// Takes a CGVector and a CGFLoat.
// Returns a new CGFloat where each component of v has been multiplied by m.

func vectorMultiply(v: CGVector, _ m: CGFloat) -> CGVector {
    return CGVectorMake(v.dx * m, v.dy * m)
}

// Takes two CGPoints.
// Returns a CGVector representing a direction from p1 to p2.
func vectorBetweenPoints(p1: CGPoint, _ p2: CGPoint) -> CGVector {
    return CGVectorMake(p2.x - p1.x, p2.y - p1.y)
}

// Takes a CGVector.
// Returns a CGFloat containing the length of the vector, calculated using
// Pythagoras' theorem.
func vectorLength(v: CGVector) -> CGFloat {
    return CGFloat(sqrtf(powf(Float(v.dx), 2) + powf(Float(v.dy), 2)))
}

// Takes two CGPoints. Returns a CGFloat containing the distance between them,
// calculated with Pythagoras' theorem.
func pointDistance(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return CGFloat(
    sqrtf(powf(Float(p2.x - p1.x), 2) + powf(Float(p2.y - p1.y), 2)))
}
