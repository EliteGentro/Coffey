//
//  DownloadContentsView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI

struct ManageContentsView: View {
    @StateObject private var contentVM: ContentViewModel
    @State private var selectedFilter: String
    private let filters = ["No Descargados", "Descargados"]

    init(contents: [Content] = [], selectedFilter: String = "No Descargados") {
        _contentVM = StateObject(wrappedValue: ContentViewModel())
        _selectedFilter = State(initialValue: selectedFilter)
    }

    private var filteredContents: [Content] {
        contentVM.arrContents.filter { content in
            if selectedFilter == "No Descargados" {
                return !content.isDownloaded
            } else {
                return content.isDownloaded
            }
        }
    }
    var body: some View {
        ScrollView {
            VStack {
                // Segmented picker to filter content
                Picker("Filtrar Contenido", selection: $selectedFilter) {
                    ForEach(filters, id: \.self) { filter in
                        Text(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // Grid of learning content
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())]) {
                    ForEach(filteredContents) { content in
                        // Navigate to detailed content view on tap
                        NavigationLink(destination: ContentDetailAdminView(content: content)) {
                            MenuCellView(
                                systemName: content.resourceType == "video" ? "video.fill" : "book.fill",
                                title: content.name
                            )
                        }
                    }
                }
            }
            .padding(20)
        }
        .navigationTitle("Contenidos de Aprendizaje")
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await loadContents()
        }
    }
    
    private func loadContents() async {
        do {
            try await contentVM.getContents()
        } catch {
            print(error)
        }
    }
    
    
}


#Preview {
    ManageContentsView()
}
