//
//  Hittable.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

struct Hit {
    let p: Vec3
    let t: Float64
    let normal: Vec3
    let frontFace: Bool
    let material: Material
}

protocol Hittable {
    func hit(ray: Ray, tMin: Float64, tMax: Float64) -> Hit?
}
