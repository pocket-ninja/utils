//
//  Copyright © 2020 sroik. All rights reserved.
//

import UIKit

precedencegroup PipePrecedence {
    associativity: left
    higherThan: AssignmentPrecedence
}

precedencegroup Exponentiation {
    associativity: left
    higherThan: MultiplicationPrecedence
}

infix operator |>: PipePrecedence
infix operator **: Exponentiation

public func |> <T, U>(lhs: T, rhs: (T) throws -> U) rethrows -> U {
    return try rhs(lhs)
}

public func ** (lhs: Double, rhs: Double) -> Double {
    return pow(lhs, rhs)
}

public func ** (lhs: CGFloat, rhs: CGFloat) -> CGFloat {
    return pow(lhs, rhs)
}
