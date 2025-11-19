//
//  FinanceSyncable.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 19/11/25.
//

import Foundation
import SwiftData

extension Finance: Syncable {
    var remoteID: Int {
        get { finance_id }
        set { finance_id = newValue }
    }

    static func makeLocal(from remote: Finance) -> Finance {
        Finance(
            finance_id: remote.finance_id,
            user_id: remote.user_id,
            name: remote.name,
            date: remote.date,
            category: remote.category,
            amount: remote.amount,
            type: remote.type,
            local_user_reference: remote.local_user_reference,
            updatedAt: remote.updatedAt,
            deletedAt: nil
        )
    }

    func merge(from remote: Finance) {
        user_id = remote.user_id
        name = remote.name
        date = remote.date
        category = remote.category
        amount = remote.amount
        type = remote.type
        updatedAt = remote.updatedAt
    }
}
