//
//  SubtitleTime.swift
//  Napi
//
//  Created by Mateusz Karwat on 09/02/16.
//  Copyright © 2016 Mateusz Karwat. All rights reserved.
//

import Foundation

/// Represents a stamp to determine how many given units
/// passed since some point in time. For example: it can
/// represent a point when a subtitle should appear on a 
/// screen since the beginning of the movie.
struct Timestamp {

    /// Represents a "time" unit to differentiate `Timestamp`
    /// for different purposes.
    enum Unit {
        case milliseconds
        case deciseconds
        case seconds
        case minutes
        case hours
        case frames(frameRate: Double)

        /// Returns a number which represents how many
        /// base values given unit represents.
        /// For example: `seconds` represents 1000 base values,
        /// but `millisecond` represents only one base value.
        /// In other words: 1000 base units equals 1 second.
        var baseValueMultiplier: Double {
            switch self {
            case .milliseconds:
                return 1
            case .deciseconds:
                return 100
            case .seconds:
                return 1000
            case .minutes:
                return 1000 * 60
            case .hours:
                return 1000 * 60 * 60
            case let .frames(frameRate: rate):
                return 1000 / rate
            }
        }
    }

    /// Represents a number of `units`.
    let value: Double

    /// Represnts a unit in which `Timestamp` calculates `baseValue`.
    let unit: Unit

    /// Represents a value which doesn't depend on any unit
    /// or unit's value. It can be treated as a base unit
    /// which all `Unit`s can be calculated from or stored in.
    /// Its value depends on a multiplier specified for each `Unit`.
    let baseValue: Double
}

// MARK: - Initializers

extension Timestamp {

    /// Creates a new instance with given `value` in specified
    /// `unit`. `baseValue` is calculaed based on `value` and `unit`.
    ///
    /// - Parameters:
    ///     - value: Number of units.
    ///     - unit:  Unit in which `Timestamp` is represented.
    init(value: Double, unit: Unit) {
        self.value = value
        self.unit = unit
        self.baseValue = value * unit.baseValueMultiplier
    }

    /// Creates a new instance with given `value` in specified
    /// `unit`. `baseValue` is calculaed based on `value` and `unit`.
    ///
    /// - Parameters:
    ///     - value: Number of units.
    ///     - unit:  Unit in which `Timestamp` is represented.
    init(value: Int, unit: Unit) {
        self.init(value: Double(value), unit: unit)
    }

    /// Creates a new instance with given `baseValue` in specified
    /// `unit`. `value` is calculaed based on `baseValue` and `unit`.
    ///
    /// - Parameters:
    ///     - baseValue: Calculated baseValue.
    ///     - unit:      Unit in which `Timestamp` is represented.
    init(baseValue: Double, unit: Unit) {
        self.baseValue = baseValue
        self.unit = unit
        self.value = baseValue / unit.baseValueMultiplier
    }

    /// Creates a new instance with given `baseValue` in specified
    /// `unit`. `value` is calculaed based on `baseValue` and `unit`.
    ///
    /// - Parameters:
    ///     - baseValue: Calculated baseValue.
    ///     - unit:      Unit in which `Timestamp` is represented.
    init(baseValue: Int, unit: Unit) {
        self.init(baseValue: Double(baseValue), unit: unit)
    }
}

// MARK: - Unit Calculations

extension Timestamp {

    /// Returns a number of units calculated based on current
    /// `baseValue` rounded down.
    ///
    /// For example:
    ///
    ///     59.seconds.numberOfFull(.minutes) // Returns 0
    ///     61.seconds.numberOfFull(.minutes) // Returns 1
    ///
    /// - Parameter otherUnit: Specifies which `Unit`'s maximum size
    ///   should be checked of how many of them fits in current `Timestamp`.
    func numberOfFull(_ otherUnit: Unit) -> Int {
        return Int(baseValue / otherUnit.baseValueMultiplier)
    }

    /// Returns a rounded number of units calculated based on current
    /// `baseValue`.
    ///
    /// For example:
    ///     
    ///     59.seconds.numberOfFull(.minutes) // Returns 1
    ///     61.seconds.numberOfFull(.minutes) // Returns 1
    ///
    /// - Parameter otherUnit: Specifies to which `Unit` current
    ///   `baseValue` should be rounded.
    func roundedValue(in unit: Unit) -> Int {
        return Int(round(baseValue / unit.baseValueMultiplier))
    }

    /// Returns a new instance of `Timestamp` calculated to given `Unit`.
    /// New `Timestamp` will have different `value`,
    /// but `baseValue` will not change.
    ///
    /// - Parameter otherUnit: Specified in which `Unit` 
    ///   new `Timestamp` should be represented.
    func converted(to otherUnit: Unit) -> Timestamp {
        return Timestamp(baseValue: baseValue, unit: otherUnit)
    }

    /// Returns a new instance of `Timestamp` with given `Unit`.
    /// New `Timestamp` will have different `baseValue`,
    /// but `value` will not change.
    ///
    /// - Parameter otherUnit: Specified in which `Unit`
    ///   new `Timestamp` should be represented.
    func changed(to otherUnit: Unit) -> Timestamp {
        return Timestamp(value: value, unit: otherUnit)
    }
}

// MARK: - Auxiliary Functions

extension Timestamp {

    /// Checks if `Timestamps` unit is based on frames.
    var isFrameBased: Bool {
        if case .frames(frameRate: _) = self.unit {
            return true
        }
        return false
    }
}

// MARK: - Arithmetic Operators

/// Returns new `Timestamp` which is a result of adding `baseValues`
/// of both parameters. New `Timestamp` has the same `Unit` as `lhs`.
func +(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
    return Timestamp(baseValue: lhs.baseValue + rhs.baseValue, unit: lhs.unit)
}

/// Returns new `Timestamp` which is a result of subtracting 
/// `rhs`'s `baseValue` from `lhs`'s. New `Timestamp` has the same `Unit` as `lhs`.
func -(lhs: Timestamp, rhs: Timestamp) -> Timestamp {
    return Timestamp(baseValue: lhs.baseValue - rhs.baseValue, unit: lhs.unit)
}
