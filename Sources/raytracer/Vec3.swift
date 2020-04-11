//
//  Vec3.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

struct Vec3 {
    let x: Float64
    let y: Float64
    let z: Float64
    
    static func zeros() -> Vec3 {
        return Vec3(x: 0.0, y: 0.0, z: 0.0)
    }
    
    static func ones() -> Vec3 {
        return Vec3(x: 1.0, y: 1.0, z: 1.0)
    }
    
    static func random(range: ClosedRange<Float64>) -> Vec3 {
        return Vec3(x: Float64.random(in: range),
                    y: Float64.random(in: range),
                    z: Float64.random(in: range))
    }

    func negate() -> Vec3 {
        return Vec3(x: -x, y: -y, z: -z)
    }
    
    func dot(v: Vec3) -> Float64 {
        return ((x * v.x) + (y * v.y)) + (z * v.z)
    }
    
    func cross(v: Vec3) -> Vec3 {
        return Vec3(
            x: (y*v.z) - (z*v.y),
            y: (z*v.x) - (x*v.z),
            z: (x*v.y) - (y*v.x)
        )
    }
    
    func lenSqrt() -> Float64 {
        return ((x*x) + (y*y)) + (z*z)
    }
    
    func len() -> Float64 {
        return sqrt(lenSqrt())
    }
    
    func unitVector() -> Vec3 {
        return self / len()
    }
    
    func toArray() -> [Float64] {
        return [x, y, z]
    }
    
    func map(_ trans: (Float64) -> Float64) -> Vec3 {
        return Vec3(x: trans(x), y: trans(y), z: trans(z))
    }
}

infix operator +
func +(u: Vec3, v: Vec3) -> Vec3 {
    return Vec3(x: u.x + v.x, y: u.y + v.y, z: u.z + v.z)
}

func +(u: Vec3, s: Float64) -> Vec3 {
    return Vec3(x: u.x + s, y: u.y + s, z: u.z + s)
}

func +(s: Float64, u: Vec3) -> Vec3 {
    return u + s
}


infix operator -
func -(u: Vec3, v: Vec3) -> Vec3 {
    return Vec3(x: u.x - v.x, y: u.y - v.y, z: u.z - v.z)
}

func -(u: Vec3, s: Float64) -> Vec3 {
    return Vec3(x: u.x - s, y: u.y - s, z: u.z - s)
}

func -(s: Float64, u: Vec3) -> Vec3 {
    return u - s
}

infix operator *
func *(u: Vec3, v: Vec3) -> Vec3 {
    return Vec3(x: u.x * v.x, y: u.y * v.y, z: u.z * v.z)
}

func *(u: Vec3, s: Float64) -> Vec3 {
    return Vec3(x: u.x * s, y: u.y * s, z: u.z * s)
}

func *(s: Float64, u: Vec3) -> Vec3 {
    return u * s
}


infix operator /
func /(u: Vec3, s: Float64) -> Vec3 {
    let multiplier = 1.0 / s
    return u * multiplier
}
