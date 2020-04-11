# raytracer-swift

Zero-dependency, concurrent raytracer written in Swift. A simple weekend experiment following the excellent book at https://raytracing.github.io/.

Features:
- Positionable camera with Depth of Field and Field of View.
- Three kinds of materials: Lambertian, Dielectric and Metal.
- Configurable antialiasing.
- Optimized to make use of all available cores.
- Outputs Portable Bitmap Format files.

Usage:

Setup your scene in the `main.swift` file and run:

```
swift run > result.ppm
```

## Samples per pixel

You can configure the quality via the `samplesPerPixel` parameter.

### Samples per pixel: 2

![Example image 2 samples per pixel](assets/example-2-spp.png)


### Samples per pixel: 4

![Example image 4 samples per pixel](assets/example-4-spp.png)

### Samples per pixel: 16

![Example image 16 samples per pixel](assets/example-16-spp.png)

### Samples per pixel: 32

![Example image 32 samples per pixel](assets/example-32-spp.png)
