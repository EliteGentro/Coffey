//
//  ContentSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Content: Syncable {
    var remoteID: Int {
        get { content_id }
        set { content_id = newValue }
    }

    static func makeLocal(from remote: Content) -> Content {
        Content(
            content_id: remote.content_id,
            name: remote.name,
            details: remote.details,
            url: remote.url,
            resourceType: remote.resourceType,
            transcript: remote.transcript,
            isDownloaded: false,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Content) {
        name = remote.name
        details = remote.details
        url = remote.url
        resourceType = remote.resourceType
        transcript = remote.transcript
        updatedAt = remote.updatedAt
    }
}
