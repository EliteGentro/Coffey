//
//  DBSynchronize.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 18/11/25.
//

import Foundation
import Combine
import SwiftData

final class DBSynchronizer: ObservableObject {
    var syncProgress : Int = 0
    var isSynchronizing : Bool = false
    var isSynchronized : Bool = false
    func fullSynchronization(context: ModelContext) async throws {
        self.isSynchronizing = true
        
        //Declare VM
        let adminVM = AdminViewModel()
        let contentVM = ContentViewModel()
        let cooperativaVM = CooperativaViewModel()
        let financeVM = FinanceViewModel()
        let preferenceVM = PreferenceViewModel()
        let progressVM = ProgressViewModel()
        let userVM = UserViewModel()
        
        //First Sync objects with no references
        
        try await adminVM.syncAdmins(using: context)
        syncProgress += 14
        try await contentVM.syncContents(using: context)
        syncProgress += 14
        try await cooperativaVM.syncCooperativas(using: context)
        syncProgress += 14
        try await userVM.syncUsers(using: context)
        syncProgress += 14
        
        //Update Objects that depend on user to be updated first
        try await financeVM.syncFinances(using: context)
        syncProgress += 14
        try await preferenceVM.syncPreferences(using: context)
        syncProgress += 14
        try await progressVM.syncProgresses(using: context)
        syncProgress = 100
        
        self.isSynchronized = true
        self.isSynchronizing = false
    }
    
}
