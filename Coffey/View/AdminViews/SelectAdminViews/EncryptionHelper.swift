//
//  EncryptionHelper.swift
//  Coffey
//
//  Created by Augusto Orozco on 21/11/25.
//
//


import Foundation
import CommonCrypto

struct CryptoHelper {

    static func pbkdf2Hash(password: String, salt: Data, iterations: Int = 100_000) -> Data? {
        let keyLength = 32 // 256 bits
        var derivedKey = Data(repeating: 0, count: keyLength)

        let passwordData = password.data(using: .utf8)!

        let result = derivedKey.withUnsafeMutableBytes { derivedKeyBytes in
            salt.withUnsafeBytes { saltBytes in
                CCKeyDerivationPBKDF(
                    CCPBKDFAlgorithm(kCCPBKDF2),
                    password,
                    passwordData.count,
                    saltBytes.bindMemory(to: UInt8.self).baseAddress!,
                    salt.count,
                    CCPseudoRandomAlgorithm(kCCPRFHmacAlgSHA256),
                    UInt32(iterations),
                    derivedKeyBytes.bindMemory(to: UInt8.self).baseAddress!,
                    keyLength
                )
            }
        }

        return result == kCCSuccess ? derivedKey : nil
    }

    static func randomSalt(length: Int = 16) -> Data {
        var salt = Data(count: length)
        let _ = salt.withUnsafeMutableBytes { SecRandomCopyBytes(kSecRandomDefault, length, $0.baseAddress!) }
        return salt
    }

    static func encode(_ data: Data) -> String {
        data.base64EncodedString()
    }

    static func decode(_ string: String) -> Data? {
        Data(base64Encoded: string)
    }
}
