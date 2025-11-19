//
//  AdminSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Admin: Syncable {
    var remoteID: Int {
        get { admin_id }
        set { admin_id = newValue }
    }

    static func makeLocal(from remote: Admin) -> Admin {
        Admin(
            admin_id: remote.admin_id,
            name: remote.name,
            correo: remote.correo,
            cooperativa_id: remote.cooperativa_id,
            password: remote.password,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Admin) {
        name = remote.name
        correo = remote.correo
        cooperativa_id = remote.cooperativa_id
        password = remote.password
        updatedAt = remote.updatedAt
    }
}
