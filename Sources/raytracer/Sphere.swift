//
//  Sphere.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

struct Sphere : Hittable {
    let center: Vec3
    let radius: Float64
    let material: Material
    
    func hit(ray: Ray, tMin: Float64, tMax: Float64) -> Hit? {
        let oc = ray.origin - center
        let a = ray.direction.lenSqrt()
        let halfB = oc.dot(v: ray.direction)
        let c = oc.lenSqrt() - radius*radius
        let discriminant = halfB*halfB - a*c
        
        if discriminant > 0 {
            let root = sqrt(discriminant)
            var temp = (-halfB - root) / a
            if temp < tMax && temp > tMin {
                let p = ray.at(t: temp)
                let normal = (p - center) / radius
                let frontFace = ray.direction.dot(v: normal) < 0.0
                return Hit(p: p,
                           t: temp,
                           normal: frontFace ? normal: normal.negate(),
                           frontFace: frontFace,
                           material: material)
            }
            temp = (-halfB + root) / a
            if temp < tMax && temp > tMin {
                let p = ray.at(t: temp)
                let normal = (p - center) / radius
                let frontFace = ray.direction.dot(v: normal) < 0.0
                return Hit(p: p,
                           t: temp,
                           normal: frontFace ? normal: normal.negate(),
                           frontFace: frontFace,
                           material: material)
            }
        }
        return nil
    }
}
