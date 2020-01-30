//
//  Collision.swift
//  MetalGame
//
//  Created by Alex Nascimento on 29/01/20.
//  Copyright © 2020 Alex Nascimento. All rights reserved.
//

enum Direction {
    case up
    case down
    case left
    case right
}
class Collision {
    
    /// Checks if two rectangles are colliding.
    /// The parameters receive a float4 corresponding to the coordinates of the top-left (tl) and down-right (dr) points of the rectangle, as shown: [tr.x, tr.y, d]
    static func check(r1: float4, r2: float4) -> Bool {
        if r1[0] < r2[2] && r1[1] > r2[3] && r1[2] > r2[0] && r1[3] < r2[1] {
            return true
        }
        return false
    }
    
    /// Returns the direction the subject is suposed to go. It's required to check for collision before using this method.
    static func checkDirection(subject r1: float4, target r2: float4, velocity: float2) -> Direction {
        let tl = check(point: [r1[0], r1[1]], rect: r2)
        let tr = check(point: [r1[1], r1[2]], rect: r2)
        let bl = check(point: [r1[0], r1[3]], rect: r2)
        let br = check(point: [r1[2], r1[3]], rect: r2)
        
        // sides collision
        if tl && !tr && bl && !br { return Direction.right }
        if tl && tr && !bl && !br { return Direction.down }
        if !tl && tr && bl && !br { return Direction.left }
        if !tl && !tr && bl && br { return Direction.up }
        
        // corner collisions
        let previousRect: float4 = [r1[0] - velocity.x, r1[1] - velocity.y, r1[2] - velocity.x, r1[3] - velocity.y]
        if tl && !tr && !bl && !br {
            let a1 = getAngle([previousRect[0], previousRect[1]], [r2[2], r2[3]])
            let a2 = getAngle([previousRect[2], previousRect[3]], [r2[2], r2[3]])
            if a1 > a2 { return Direction.right } else { return Direction.down}
        }
        if !tl && tr && !bl && !br {
            let a1 = getAngle([previousRect[2], previousRect[1]], [r2[0], r2[3]])
            let a2 = getAngle([previousRect[0], previousRect[3]], [r2[0], r2[3]])
            if a1 > a2 { return Direction.down } else { return Direction.left }
        }
        if !tl && !tr && bl && !br {
            let a1 = getAngle([previousRect[0], previousRect[3]], [r2[2], r2[1]])
            let a2 = getAngle([previousRect[2], previousRect[1]], [r2[2], r2[1]])
            if a1 > a2 { return Direction.up } else { return Direction.right }
        }
        if !tl && !tr && !bl && br {
            let a1 = getAngle([previousRect[2], previousRect[3]], [r2[0], r2[1]])
            let a2 = getAngle([previousRect[0], previousRect[1]], [r2[0], r2[1]])
            if a1 > a2 { return Direction.left } else { return Direction.up }
        }
        
        // default (every point is inside or outside)
        return Direction.up
    }
    
    static func check(point: float2, rect: float4) -> Bool {
        if point[0] > rect[0] && point[0] < rect[2] && point[1] < rect[1] && point[1] > rect[3] {
            return true
        }
        return false
    }
}
