import SwiftUI
import MapKit

struct MuseumMapView: View {
    @State var museumVM = MuseumViewModel()
    @Binding var selectedMuseum: Museum?
    @Binding var tabSelection: Int

    var body: some View {
        ZStack {
            Map {
                ForEach(museumVM.museums) { museum in
                    Annotation(museum.name,
                               coordinate: museumVM.coordinate(for: museum)) {
                        Button {
                            selectedMuseum = museum
                        } label: {
                            VStack(spacing: 2) {
                                Image(systemName: "mappin.circle.fill")
                                    .font(.title)
                                    .foregroundColor(.red)
                                // Translate museum name label
                                TranslatedText(original: museum.name, font: .caption)
                            }
                        }
                    }
                }
            }
            .ignoresSafeArea()

            if let museum = selectedMuseum {
                VStack {
                    Spacer()
                    MuseumDetailView(
                        museum: museum,
                        onClose: { selectedMuseum = nil },
                        tabSelection: $tabSelection
                    )
                    .padding()
                    .background(.ultraThinMaterial)
                    .cornerRadius(12)
                    .shadow(radius: 5)
                }
                .transition(.move(edge: .bottom))
            }
        }
        // Keep static nav title for system bar (String only)
        .navigationTitle("Nearby Museums")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MuseumMapView(selectedMuseum: .constant(Museum.mock), tabSelection: .constant(1))
}
