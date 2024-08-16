//
//  Logger.swift
//  SharedLoggerKit
//
//  Created by XIAOCHUAN HE on R 5/06/21.
//

import Foundation
import os
fileprivate let kBundleID = Bundle.main.bundleIdentifier!
fileprivate let kTagColMax = 8

public protocol Log {
    var category:String { get }
    func debug(_ tag: String, _ msg: String)
    func info(_ tag: String, _ msg: String)
    func error(_ tag: String, _ msg: String)
}

@available(iOS 14.0, *)
public extension Log{
    
    var logger: Logger{
        Logger(subsystem: kBundleID, category: self.category)
    }
    func debug(_ tag: String, _ msg: String){
        #if DEBUG
        logger.debug("\("[\(tag)]", align: .left(columns: kTagColMax), privacy: .public)\(msg, privacy: .public)")
        #else
        logger.debug("\("[\(tag)]", align: .left(columns: kTagColMax), privacy: .public)\(msg, privacy: .private)")
        #endif
    }
    
    func info(_ tag: String, _ msg: String){
        logger.info("\("[\(tag)]", align: .left(columns: kTagColMax), privacy: .public)\(msg, privacy: .public)")
    }
    func error(_ tag: String, _ msg: String){
        logger.error("\("[\(tag)]", align: .left(columns: kTagColMax), privacy: .public)\(msg, privacy: .public)")
    }
}
