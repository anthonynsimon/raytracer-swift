//
//  Utils.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//
import Foundation

let black = Vec3.zeros()
let white = Vec3.ones()
let blue = Vec3(x: 0.5, y: 0.7, z: 1.0)

func floatToRGB(_ value: Float64) -> UInt8 {
    guard !(value.isNaN || value.isInfinite) else {
        return 0
    }
    return UInt8(clamp(value: ceil(255 * value), min: 0, max: 255))
}

extension Vec3 {
    func toRGBLine() -> String {
        return "\(floatToRGB(x)) \(floatToRGB(y)) \(floatToRGB(z))\n"
    }
}

func clamp(value: Float64, min: Float64, max: Float64) -> Float64 {
    if value > max {
        return max
    } else if value < min {
        return min
    }
    return value
}

func timeit<T>(_ block: () -> T) -> (T, UInt) {
    let started = Date()
    let result = block()
    let tookMillis = UInt(Date().timeIntervalSince(started) * 1000)
    return (result, tookMillis)
}

func randomInUnitSphere() -> Vec3 {
    while true {
        let p = Vec3.random(range: -1.0 ... 1.0)
        if p.lenSqrt() >= 1 {
            continue
        }
        return p
    }
}

func randomInUnitDisk() -> Vec3 {
    while true {
        let p = Vec3(x: Float64.random(in: -1 ... 1), y: Float64.random(in: -1 ... 1), z: 0.0)
        if p.lenSqrt() >= 1 {
            continue
        }
        return p
    }
}

func randomUnitVector() -> Vec3 {
    let a = Float64.random(in: 0.0 ... 2.0 * Float64.pi)
    let z = Float64.random(in: -1.0 ... 1.0)
    let r = sqrt(1.0 - z * z)
    return Vec3(x: r * cos(a), y: r * sin(a), z: z)
}

extension Float64 {
    func toRadians() -> Float64 {
        return self * .pi / 180.0
    }
}

func refract(uv: Vec3, normal: Vec3, etaiOverEtat: Float64) -> Vec3 {
    let cosTheta = uv.negate().dot(v: normal)
    let rayParallel = etaiOverEtat * (uv + cosTheta * normal)
    let rayPerpendicular = (-sqrt(1.0 - rayParallel.lenSqrt())) * normal
    return rayParallel + rayPerpendicular
}

func reflect(v: Vec3, normal: Vec3) -> Vec3 {
    return v - ((normal * v.dot(v: normal)) * 2.0)
}

func schlick(cosine: Float64, refractiveIndex: Float64) -> Float64 {
    let r0 = pow((1.0 - refractiveIndex) / (1.0 + refractiveIndex), 2.0)
    return r0 + (1.0 - r0) * pow(1.0 - cosine, 5)
}
