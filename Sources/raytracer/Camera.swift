//
//  Camera.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 10.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

class Camera {
    // Lens settings
    let vfov: Float64
    let aspect: Float64
    let aperture: Float64
    let focusDistance: Float64
    
    // Camera positioning
    let lookFrom: Vec3
    let lookAt: Vec3
    let vup: Vec3
    
    // Internals
    private let origin: Vec3
    private let lowerLeft: Vec3
    private let horizontal: Vec3
    private let vertical: Vec3
    private let lensRadius: Float64
    
    init(vfov: Float64, aspect: Float64, aperture: Float64, focusDistance: Float64,
         lookFrom: Vec3, lookAt: Vec3, vup: Vec3) {
        let theta = vfov.toRadians()
        let halfHeight = tan(theta / 2.0)
        let halfWidth = aspect * halfHeight
        
        self.vfov = vfov
        self.aspect = aspect
        self.aperture = aperture
        self.focusDistance = focusDistance

        self.origin = lookFrom
        self.lookAt = lookAt
        self.lookFrom = lookFrom
        self.vup = vup
        
        let w = (lookFrom - lookAt).unitVector()
        let u = vup.cross(v: w).unitVector()
        let v = w.cross(v: u)
        
        let uw = u * (halfWidth * focusDistance)
        let vh = v * (halfHeight * focusDistance)
        
        self.lowerLeft = origin - uw - vh - (w * focusDistance)
        self.horizontal = uw * 2.0
        self.vertical = vh * 2.0
        self.lensRadius = aperture / 2.0
    }
}

extension Camera {
    func sampleRay(u: Float64, v: Float64) -> Ray {
        let rand = lensRadius * randomInUnitDisk()
        let offset = u * rand.x + v * rand.y

        let rayOrigin = origin + offset
        let direction = lowerLeft + u * horizontal + v * vertical - origin - offset
        
        return Ray(origin: rayOrigin,
                   direction: direction)
    }
}
