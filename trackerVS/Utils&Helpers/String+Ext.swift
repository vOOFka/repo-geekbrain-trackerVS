//
//  String+Ext.swift
//  trackerVS
//
//  Created by Home on 10.05.2022.
//

import Foundation
import CryptoKit

extension String {
    var sha256: String {
        let inputData = Data(self.utf8)
        let hashed = SHA256.hash(data: inputData)
        let hashString = hashed.compactMap { String(format: "%02x", $0) }.joined()
        return hashString
    }
}
