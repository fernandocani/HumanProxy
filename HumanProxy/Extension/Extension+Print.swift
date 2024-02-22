//
//  Extension+Print.swift
//  HumanProxy
//
//  Created by Fernando Cani on 19/02/24.
//

import Foundation

public func printInfo(
    _ items: Any...,
    file: String = #file,
    line: Int = #line,
    function: String = #function
) {
    print(items, /*"| #file: \(file)", */"| #line: \(line)", "| #function: \(function)")
}
