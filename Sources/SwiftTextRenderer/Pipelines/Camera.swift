//
//  File.swift
//  SwiftTextRenderer
//
//  Created by Yuki Kuwashima on 2024/11/13.
//

import simd

public struct Camera {

    let frameWidth: Float
    let frameHeight: Float
    private let fovInDegrees: Float
    private let near: Float
    private let far: Float

    public var viewMatrix: f4x4 = .createIdentity()
    public var perspectiveMatrix: f4x4 = .createIdentity()

    public init(
        width: Float,
        height: Float,
        translation: f3 = f3(0, 0, -30),
        rotationAngle: Float = 0,
        rotationAxis: f3 = f3(0, 1, 0),
        fovInDegrees: Float = 85,
        near: Float = 0.01,
        far: Float = 1000
    ) {
        self.frameWidth = width
        self.frameHeight = height
        self.fovInDegrees = fovInDegrees
        self.near = near
        self.far = far

        let rotationMatrix = f4x4.createRotation(angle: rotationAngle, axis: rotationAxis)
        let translationMatrix = f4x4.createTranslation(translation.x, translation.y, translation.z)
        self.viewMatrix = translationMatrix * rotationMatrix
        self.perspectiveMatrix = f4x4.createPerspective(
            fov: Float.degreesToRadians(fovInDegrees),
            aspect: frameWidth / frameHeight,
            near: near,
            far: far
        )
    }
}

fileprivate extension Float {
    static func degreesToRadians(_ deg: Float) -> Self {
        return Self(deg / 360 * Float.pi * 2)
    }
}
