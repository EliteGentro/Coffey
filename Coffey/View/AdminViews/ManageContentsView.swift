//
//  DownloadContentsView.swift
//  Coffey
//
//  Created by Humberto Genaro Cisneros Salinas on 17/10/25.
//

import SwiftUI
import SwiftData

struct ManageContentsView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var contentVM: ContentViewModel
    @Query var contents: [Content]
    @State private var selectedFilter: String
    private let filters = ["No Descargados", "Descargados"]

    init(selectedFilter: String = "No Descargados") {
        _contentVM = StateObject(wrappedValue: ContentViewModel())
        _selectedFilter = State(initialValue: selectedFilter)
    }

    private var filteredContents: [Content] {
        contents.filter { content in
            selectedFilter == "No Descargados" ? !content.isDownloaded : content.isDownloaded
        }
    }
    
    var body: some View {
        ZStack{
            Color.beige.ignoresSafeArea()
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
            // First sync remote -> local, then fetch local to display
            do {
                try await contentVM.syncContents(using: context)
            } catch {
                print("Sync failed:", error)
                // Still attempt to fetch local contents so UI can show cached rows
                contentVM.loadLocalContents(using: context)
            }
        }
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
