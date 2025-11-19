//
//  ProgressSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Progress: Syncable {
    var remoteID: Int {
        get { progress_id }
        set { progress_id = newValue }
    }

    static func makeLocal(from remote: Progress) -> Progress {
        Progress(
            progress_id: remote.progress_id,
            user_id: remote.user_id,
            content_id: remote.content_id,
            grade: remote.grade,
            status: remote.status,
            local_user_reference: remote.local_user_reference,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Progress) {
        user_id = remote.user_id
        content_id = remote.content_id
        grade = remote.grade
        status = remote.status
        updatedAt = remote.updatedAt
    }
}
