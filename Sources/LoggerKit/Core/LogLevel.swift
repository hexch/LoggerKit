//
//  LogLevel.swift
//  LoggerKit
//
//  Created by XIAOCHUAN HE on R 7/06/27.
//

import Foundation

public enum LogLevel: String, Comparable, Sendable{
    case debug
    case info
    case warning
    case error
    
    public static func < (lhs: LogLevel, rhs: LogLevel) -> Bool {
        let order: [LogLevel] = [.debug, .info, .warning, .error]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
