//
//  LoginAdminView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct SelectAdminView: View {
    @Binding private var path: NavigationPath
    var onReset: () -> Void
    @State private var isAddedPresented = false
    @State private var showAlert = false
    @State private var alertMessage = ""

    // Fetch admins from SwiftData
    @Query private var admins: [Admin]
    @Query private var cooperativas: [Cooperativa]


    init(path: Binding<NavigationPath>, onReset: @escaping () -> Void = {}) {
        self._path = path
        self.onReset = onReset
        // Query all admins sorted by name
        self._admins = Query(sort: \.name, order: .forward)
    }

    var body: some View {
        ZStack{
            BackgroundView()
        ScrollView {
            
                
                
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 32) {
                    ForEach(admins) { admin in
                        NavigationLink(
                            destination: AdminLoginView(admin: admin, path: $path, onReset: onReset)
                        ) {
                            VStack(spacing: 8) {
                                InitialProfileCircleView(name: admin.name)
                                Text(admin.name)
                                    .scaledFont(.headline)
                                    .foregroundColor(.primary)
                            }
                            .padding()
                        }
                    }
                }
                .padding()
                .toolbar {
                    ToolbarItem {
                        Button("Add Admin", systemImage: "plus") {
                            if cooperativas.isEmpty {
                                alertMessage = "No se encontraron cooperativas. Inténtalo más tarde."
                                showAlert = true
                            } else {
                                isAddedPresented = true
                            }
                        }.buttonStyle(.borderedProminent).tint(.brown)
                    }
                }
                .alert("Error", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                } message: {
                    Text(alertMessage)
                }
                .sheet(isPresented: self.$isAddedPresented) {
                    AddAdminView(cooperativas: cooperativas)
                        .presentationDetents([.large])
                }
            }
            .navigationTitle("Select Admin")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    @Previewable @State var dummyPath = NavigationPath()
    NavigationStack {
        SelectAdminView(path: $dummyPath)
        .withPreviewSettings()
    }
}
