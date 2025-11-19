//
//  UserSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension User: Syncable {
    var remoteID: Int {
        get { user_id }
        set { user_id = newValue }
    }

    static func makeLocal(from remote: User) -> User {
        User(
            user_id: remote.user_id,
            name: remote.name,
            cooperativa_id: remote.cooperativa_id,
            puntaje_aprendizaje: remote.puntaje_aprendizaje,
            contenidos_terminados: remote.contenidos_terminados,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: User) {
        name = remote.name
        cooperativa_id = remote.cooperativa_id
        puntaje_aprendizaje = remote.puntaje_aprendizaje
        contenidos_terminados = remote.contenidos_terminados
        updatedAt = remote.updatedAt
    }
}
