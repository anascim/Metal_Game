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
    static func check(r1: Vec4, r2: Vec4) -> Bool {
        if r1[0] < r2[2] && r1[1] > r2[3] && r1[2] > r2[0] && r1[3] < r2[1] {
            return true
        }
        return false
    }
    
    /// Returns the direction the subject is suposed to go. It's required to check for collision before using this method.
    static func checkDirection(subject r1: Vec4, target r2: Vec4, velocity: Vec2) -> Direction {
        let tl = check(point: Vec2(r1[0], r1[1]), rect: r2)
        let tr = check(point: Vec2(r1[2], r1[1]), rect: r2)
        let bl = check(point: Vec2(r1[0], r1[3]), rect: r2)
        let br = check(point: Vec2(r1[2], r1[3]), rect: r2)
        
        // sides collision
        if tl && !tr && bl && !br { return Direction.right }
        if tl && tr && !bl && !br { return Direction.down }
        if !tl && tr && !bl && br { return Direction.left }
        if !tl && !tr && bl && br { return Direction.up }
        
        // corner collisions
        let previousRect = Vec4(r1[0] - velocity.x, r1[1] - velocity.y, r1[2] - velocity.x, r1[3] - velocity.y)
        if tl && !tr && !bl && !br {
            let a = getAngle(Vec2(r2[2], r2[3]), Vec2(previousRect[0], previousRect[1]))
            if a > -PI/4 && a < 3*PI/4 { return Direction.right } else { return Direction.down }
        }
        if !tl && tr && !bl && !br {
            let a = getAngle(Vec2(r2[0], r2[3]), Vec2(previousRect[2], previousRect[1]))
            if a > -3*PI/4 && a < PI/4 { return Direction.down } else { return Direction.left }
        }
        if !tl && !tr && bl && !br {
            let a = getAngle(Vec2(r2[2], r2[1]), Vec2(previousRect[0], previousRect[3]))
            if a > -3*PI/4 && a < PI/4 { return Direction.right } else { return Direction.up }
        }
        if !tl && !tr && !bl && br {
            let a = getAngle(Vec2(r2[0], r2[1]), Vec2(previousRect[2], previousRect[3]))
            if a > -PI/4 && a < 3*PI/4 { return Direction.up } else { return Direction.left }
        }
        
        // default (every point is inside or outside)
        return Direction.up
    }
    
    static func check(point: Vec2, rect: Vec4) -> Bool {
        if point.x > rect[0] && point.x < rect[2] && point.y < rect[1] && point.y > rect[3] {
            return true
        }
        return false
    }
}
