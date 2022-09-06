//
//  Publisher+singleOutput.swift
//  CiThemes
//
//  Created by Loïc Heinrich on 09/08/2022.
//

import Foundation
import Combine

extension Publishers {
    struct MissingOutputError: Error {}
}

extension Publisher {
    func singleOutput() async throws -> Output {
        for try await output in values {
            return output
        }
        throw Publishers.MissingOutputError()
    }
}
