//
//  String+CommandLine.swift
//  PolymorphCLI
//
//  Created by Benoit BRIATTE on 23/06/2017.
//

import Foundation

extension String {

    public func arguments() -> [String] {

        var arguments: [String] = []
        var str = ""
        var escape: Bool = false
        var quote: Character? = nil
        for ch in self {
            if escape {
                escape = false
                if ch == "n" {
                    str += "\n"
                } else if ch == "t" {
                    str += "\t"
                } else if ch == "\"" || ch == "'" {
                    str.append(ch)
                }
            } else if ch == "\"" || ch == "'" {
                if str.count == 0 && quote == nil {
                    quote = ch
                } else if let q = quote, q == ch {
                    arguments.append(str)
                    str = ""
                    escape = false
                    quote = nil
                } else {
                    str.append(ch)
                }
            } else if ch == " " && quote == nil {
                if str.count > 0 {
                    arguments.append(str)
                    str = ""
                    escape = false
                    quote = nil
                }
            } else if ch == "\\" {
                escape = true
            } else {
                str.append(ch)
            }
        }
        if str.count > 0 {
            arguments.append(str)
        }
        return arguments
    }
}
