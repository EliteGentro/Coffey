//
//  CooperativaSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Cooperativa: Syncable {
    var remoteID: Int {
        get { cooperativa_id }
        set { cooperativa_id = newValue }
    }

    static func makeLocal(from remote: Cooperativa) -> Cooperativa {
        Cooperativa(
            cooperativa_id: remote.cooperativa_id,
            name: remote.name,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Cooperativa) {
        name = remote.name
        updatedAt = remote.updatedAt
    }
}
