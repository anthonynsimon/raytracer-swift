//
//  Scene.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

class Scene: Hittable {
    let camera: Camera

    init(camera: Camera) {
        self.camera = camera
    }

    private var hittables: [Hittable] = []

    func hit(ray: Ray, tMin: Float64, tMax: Float64) -> Hit? {
        var closest: Hit?
        for hittable in hittables {
            let hit = hittable.hit(ray: ray, tMin: tMin, tMax: closest?.t ?? tMax)
            if hit != nil {
                closest = hit
            }
        }
        return closest
    }

    func add(_ items: Hittable...) {
        hittables.append(contentsOf: items)
    }

    func clear() {
        hittables.removeAll()
    }
}
