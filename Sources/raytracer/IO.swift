//
//  IO.swift
//  Raytracer
//
//  Created by Anthony Najjar Simon on 11.04.20.
//  Copyright © 2020 Anthony Najjar Simon. All rights reserved.
//

import Foundation

func log(_ msg: String) {
    FileHandle.standardError.write("\(msg)\n".data(using: .utf8)!)
}

func write(_ line: String) {
    print(line)
}

func write(_ lines: [String]) {
    print(lines.joined())
}
