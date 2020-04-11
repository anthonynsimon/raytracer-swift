//
//  Material.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 11.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

struct MaterialHit {
    let attenuation: Vec3
    let scatter: Ray
}

protocol Material {
    func scatter(ray: Ray, hit: Hit) -> MaterialHit?
}

struct Lambertian: Material {
    let albedo: Vec3

    func scatter(ray _: Ray, hit: Hit) -> MaterialHit? {
        let scatterDirection = hit.normal + randomUnitVector()
        let scattered = Ray(origin: hit.p, direction: scatterDirection)
        return MaterialHit(attenuation: albedo, scatter: scattered)
    }
}

struct Metal: Material {
    let albedo: Vec3
    let fuzz: Float64

    init(albedo: Vec3, fuzz: Float64) {
        self.albedo = albedo
        self.fuzz = fuzz < 1 ? fuzz : 1.0
    }

    func scatter(ray: Ray, hit: Hit) -> MaterialHit? {
        let reflected = reflect(v: ray.direction, normal: hit.normal) + (randomInUnitSphere() * fuzz)
        let scattered = Ray(origin: hit.p, direction: reflected)

        if scattered.direction.dot(v: hit.normal) > 0.0 {
            return MaterialHit(attenuation: albedo, scatter: scattered)
        }

        return nil
    }
}

struct Dielectric: Material {
    let refractiveIndex: Float64

    func scatter(ray: Ray, hit: Hit) -> MaterialHit? {
        let attenuation = Vec3.ones()
        let etaiOverEtat = hit.frontFace ? (1.0 / refractiveIndex) : refractiveIndex
        let unitDirection = ray.direction.unitVector()
        let cosTheta = min(unitDirection.negate().dot(v: hit.normal), 1.0)
        let sinTheta = sqrt(1.0 - (cosTheta * cosTheta))

        if (etaiOverEtat * sinTheta) > 1.0 {
            let reflected = reflect(v: unitDirection, normal: hit.normal)
            let scattered = Ray(origin: hit.p, direction: reflected)
            return MaterialHit(attenuation: attenuation, scatter: scattered)
        }

        let reflectProbability = schlick(cosine: cosTheta, refractiveIndex: etaiOverEtat)
        if Float64.random(in: 0 ... 1) < reflectProbability {
            let reflected = reflect(v: unitDirection, normal: hit.normal)
            let scattered = Ray(origin: hit.p, direction: reflected)
            return MaterialHit(attenuation: attenuation, scatter: scattered)
        }

        let refracted = refract(uv: unitDirection, normal: hit.normal, etaiOverEtat: etaiOverEtat)
        let scattered = Ray(origin: hit.p, direction: refracted)
        return MaterialHit(attenuation: attenuation, scatter: scattered)
    }
}
