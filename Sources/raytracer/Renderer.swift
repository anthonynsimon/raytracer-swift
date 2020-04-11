//
//  Renderer.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 11.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

class Renderer {
    private let scene: Scene

    init(scene: Scene) {
        self.scene = scene
    }

    func render(width: Int, height: Int,
                concurrency: Int = 1,
                samplesPerPixel: Int = 1,
                maxDepth: Int) -> [Vec3] {
        let camera = scene.camera

        var image = Array(repeating: Vec3.zeros(), count: width * height)

        // Write queue to serialize access to the mutable array
        let writeQueue = Dispatch.DispatchQueue(label: "writes")

        // Cache random samples per pixel
        let randSamples = (0 ..< (2 * samplesPerPixel)).map { _ in Float64.random(in: 0.0 ... 1.0) }
        let sampleScale = 1.0 / Float64(samplesPerPixel)

        DispatchQueue.concurrentPerform(iterations: concurrency, execute: { slice in
            typealias Position = Int
            var assignedSection = [(Position, Vec3)]()

            let start = slice * height / concurrency
            let end = (slice + 1) * height / concurrency

            for j in start ..< end {
                for i in 0 ..< width {
                    var pixel = Vec3.zeros()

                    for s in 0 ..< samplesPerPixel {
                        let u = (Float64(i) + randSamples[s]) / Float64(width)
                        let v = (Float64(j) + randSamples[s + samplesPerPixel]) / Float64(height)

                        let ray = camera.sampleRay(u: u, v: v)
                        let sample = ray.color(scene: scene, depth: maxDepth)
                        pixel = pixel + sample
                    }

                    // Average out the sampled pixels
                    // Divide the color total by the number of samples and gamma-correct for a gamma value of 2.0.
                    pixel = (pixel * sampleScale).map(sqrt)

                    let pos = j * width + i
                    assignedSection.append((pos, pixel))
                }
            }

            writeQueue.sync {
                for (pos, pixel) in assignedSection {
                    image[pos] = pixel
                }
            }
        })

        return image
    }
}
