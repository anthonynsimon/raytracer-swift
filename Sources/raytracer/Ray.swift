//
//  Ray.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

struct Ray {
    let origin: Vec3
    let direction: Vec3
    
    func at(t: Float64) -> Vec3 {
        return origin + (direction * t)
    }

    func color(scene: Scene, depth: Int) -> Vec3 {
        if depth <= 0 {
            return black
        }
        
        // We hit an object (use small positive tMin to ignore hits due to floating point errors near 0.0
        if let hit = scene.hit(ray: self, tMin: 0.01, tMax: Float64.infinity) {
            if let materialHit = hit.material.scatter(ray: self, hit: hit) {
                return materialHit.attenuation * materialHit.scatter.color(scene: scene, depth: depth - 1)
            }
            return black
        }
        
        // No object hit
        let unitDirection = direction.unitVector()
        let t = (unitDirection.y + 1.0) * 0.5

        return white * (1.0 - t) + blue * t
    }
}
