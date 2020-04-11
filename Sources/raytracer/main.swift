//
//  main.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

func buildScene(width: Int, height: Int) -> Scene {
    let aspect = Float64(width) / Float64(height)
    
    let vfov = 20.0
    let aperture = 0.28
    let lookFrom = Vec3(x: 0, y: 1.4, z: 6)
    let lookAt = Vec3(x: 0.33, y: 0.77, z: 0)
    let focusDistance = (lookFrom - lookAt).len()
    let vup = Vec3(x: 0, y: -1, z: 0)
    
    let camera = Camera(vfov: vfov, aspect: aspect, aperture: aperture, focusDistance: focusDistance,
                        lookFrom: lookFrom, lookAt: lookAt, vup: vup)
    
    let scene = Scene(camera: camera)
    
    let blueLambert = Lambertian(albedo: Vec3(x: 0.25, y: 0.25, z: 1.0))
    let greenLambert = Lambertian(albedo: Vec3(x: 0.3, y: 0.8, z: 0.2))
    let defaultLambert = Lambertian(albedo: Vec3(x: 0.5, y: 0.5, z: 0.5))
    let metal = Metal(albedo: Vec3(x: 0.8, y: 0.8, z: 0.8), fuzz: 0.45)
    let fuzzyMetal = Metal(albedo: Vec3(x: 0.1, y: 0.1, z: 0.1), fuzz: 1.0)
    let fuzzyRedMetal = Metal(albedo: Vec3(x: 1.0, y: 0.0, z: 0.0), fuzz: 1.0)
    let gold = Metal(albedo: Vec3(x: 0.6, y: 0.4, z: 0.0), fuzz: 1.0)
    let refractive = Dielectric(refractiveIndex: 1.5)
    

    scene.add(
        Sphere(center: Vec3(x: 0, y: 0.8, z: 0), radius: 0.8, material: metal),
        Sphere(center: Vec3(x: -2, y: 0.5, z: -3), radius: 0.5, material: blueLambert),
        Sphere(center: Vec3(x: 2, y: 0.25, z: -6), radius: 0.25, material: greenLambert),
        Sphere(center: Vec3(x: 1.4, y: 0.6, z: 2.7), radius: 0.6, material: gold),
        Sphere(center: Vec3(x: 2.3, y: 0.35, z: -2.7), radius: 0.35, material: fuzzyRedMetal),
        Sphere(center: Vec3(x: -1.5, y: 0.35, z: 0.8), radius: 0.35, material: fuzzyMetal),
        Sphere(center: Vec3(x: -1.1, y: 0.18, z: -0.5), radius: 0.18, material: refractive),

        // "Ground"
        Sphere(center: Vec3(x: 0, y: -1000, z: -1), radius: 1000, material: defaultLambert)
    )

    for x in stride(from: -6, to: 6, by: 2) {
        for z in stride(from: -16, to: 16, by: 4){
            scene.add(
                {
                    let radius = Float64.random(in: 0.2...0.6)
                    
                    let mat: Material = {
                        let rand = Int.random(in: 0...2)
                        switch rand {
                        case 0: return Metal(albedo: Vec3(x: Float64.random(in: 0...1), y: Float64.random(in: 0...1), z: Float64.random(in: 0...1)), fuzz: Float64.random(in: 0...1))
                        case 1: return Lambertian(albedo: Vec3(x: Float64.random(in: 0...1), y: Float64.random(in: 0...1), z: Float64.random(in: 0...1)))
                        case 2: return Dielectric(refractiveIndex: Float64.random(in: 1..<3))
                        default: return defaultLambert
                        }
                    }()
                    
                    return Sphere(center: Vec3(x: Float64(x) + Float64.random(in: -0.1...0.1),
                                               y: radius,
                                               z: Float64(z) + Float64.random(in: -0.1...0.1)),
                                  radius: radius,
                                  material: mat)
                }()
            )
        }
    }

    return scene
}

func main() {
    let (width, height) = (400, 200)
    let maxDepth = 10
    let samplesPerPixel = 64
    
    let scene = buildScene(width: width, height: height)
    let renderer = Renderer(scene: scene)
    
    let cores = ProcessInfo().activeProcessorCount
    
    log("Rendering using all available cores: \(cores)")
    let (image, tookMillis) = timeit {
        return renderer.render(width: width,
                               height: height,
                               concurrency: cores,
                               samplesPerPixel: samplesPerPixel,
                               maxDepth: maxDepth)
    }
    log("Rendering took \(tookMillis) ms")

    log("Writing image in Portable Bitmap Format")
    let header = "P3\n\(width) \(height)\n255\n"
    write(header)
    write(image.map({ $0.toRGBLine() }))
    
    log("Done")
}

main()