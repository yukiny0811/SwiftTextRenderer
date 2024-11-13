//
//  DelaunayError.swift
//  iShapeTriangulation iOS
//
//  Created by Nail Sharipov on 04.01.2022.
//

public enum DelaunayError: Error {
    case notValidPath(PlainShape.Validation)
}
