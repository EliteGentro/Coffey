//
//  ReceiptInfo.swift
//  Coffey
//
//  Created by Alumno on 13/11/25.
//

import Foundation


struct ReceiptData {
    var provider: String?
    var serviceType: String?
    var amount: Double?
    var date: Date?
}

class ReceiptParser {

    static func parse(from text: String) -> ReceiptData {
        var data = ReceiptData()
        

        let cleaned = text.lowercased()
            .replacingOccurrences(of: ",", with: "")
            .replacingOccurrences(of: "$", with: " ")
            .replacingOccurrences(of: "total:", with: "total ")
            .replacingOccurrences(of: ":", with: " ")

        let providers = [
            "cfe": "Luz",
            "comisión federal de electricidad": "Luz",
            "naturgy": "Gas",
            "gas natural": "Gas",
            "telmex": "Internet",
            "izzi": "Internet",
            "totalplay": "Internet",
            "megacable": "Internet",
            "infinitum": "Internet"
        ]

        for (keyword, service) in providers {
            if cleaned.contains(keyword) {
                data.provider = keyword.capitalized
                data.serviceType = service
            }
        }

        let amountRegex = #"(total|pagar|importe|cantidad)[^\d]*([\d]+\.\d{2})"#
        if let match = cleaned.firstMatch(of: amountRegex, group: 2) {
            data.amount = Double(match)
        } else {
            // fallback: buscar cualquier número grande (suele ser el monto)
            if let fallback = cleaned.firstMatch(of: #"(\d{2,5}\.\d{2})"#, group: 1) {
                data.amount = Double(fallback)
            }
        }

        return data
    }
}


extension String {
    func firstMatch(of pattern: String, group: Int) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive])
            let nsString = self as NSString
            let results = regex.firstMatch(in: self, range: NSRange(location: 0, length: nsString.length))
            if let r = results?.range(at: group), r.location != NSNotFound {
                return nsString.substring(with: r)
            }
        } catch {
            print("Regex error:", error)
        }
        return nil
    }
}

