//
//  PreferenceSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Preference: Syncable {
    var remoteID: Int? {
        get { preference_id }
        set { preference_id = newValue }
    }

    static func makeLocal(from remote: Preference) -> Preference {
        Preference(
            preference_id: remote.preference_id,
            user_id: remote.user_id,
            local_user_reference: remote.local_user_reference,
            font_multiplier: remote.font_multiplier,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Preference) {
        user_id = remote.user_id
        font_multiplier = remote.font_multiplier
        updatedAt = remote.updatedAt
    }
}
