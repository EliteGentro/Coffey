
import SwiftUI
import Vision
import PhotosUI

struct ReceiptScannerView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var extractedText: String = ""
    @State private var isProcessing = false
    @State private var showCamera = false
    
    
    
    let user : User?
    
    let onFinish: (Finance) -> Void
    
    
    init(user: User?, onFinish: @escaping (Finance) -> Void) {
        self.user = user
        self.onFinish = onFinish
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.beige.ignoresSafeArea()
            VStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .strokeBorder(style: StrokeStyle(lineWidth: 2))
                        .foregroundColor(.gray.opacity(0.4))
                        .frame(height: 250)
                        .overlay {
                            if let image = selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .cornerRadius(15)
                                    .padding(6)
                            } else {
                                Text("Selecciona o toma una foto del recibo")
                                    .foregroundColor(.gray)
                            }
                        }
                }
                
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images, photoLibrary: .shared()) {
                        Label("Galería", systemImage: "photo")
                    }
                    .buttonStyle(.borderedProminent)
                    
                    Button {
                        showCamera.toggle()
                    } label: {
                        Label("Cámara", systemImage: "camera")
                    }
                    .buttonStyle(.borderedProminent)
                }
                
                if isProcessing {
                    ProgressView("Procesando...")
                        .padding()
                } else if !extractedText.isEmpty {
                    ScrollView {
                        Text(extractedText)
                            .scaledFont(.body)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .frame(maxHeight: 250)
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Escáner de Recibos")
            .toolbar{
                ToolbarItem(placement: .topBarTrailing){
                    SectionAudioControls(text: "Esta es la herramienta para escanear recibos. Puedes seleccionar una foto desde la galería o tomar una con la cámara. Después de elegir la imagen, la aplicación leerá el texto del recibo automáticamente. Si se detecta el servicio y el monto, se generará un registro de egreso para el usuario. Una vez finalizado el proceso, regresarás a la pantalla anterior. Selecciona una imagen o toma una foto para comenzar.")
                }
            }
            
            
            .onChange(of: selectedItem) { oldValue, newValue in
                Task { await loadImage(from: newValue) }
            }
            .sheet(isPresented: $showCamera) {
                CameraView(image: $selectedImage)
            }
            }
        }
    }
    
    private func loadImage(from item: PhotosPickerItem?) async {
        guard let item = item,
              let data = try? await item.loadTransferable(type: Data.self),
              let uiImage = UIImage(data: data)
        else { return }
        
        selectedImage = uiImage
        performTextRecognition(image: uiImage)
    }
    
    private func performTextRecognition(image: UIImage) {
        guard let cgImage = image.cgImage else { return }
        
        isProcessing = true
        extractedText = ""
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { (req, error) in
            defer { self.isProcessing = false }
            
            guard let observations = req.results as? [VNRecognizedTextObservation] else { return }
            
            let text = observations
                .compactMap { $0.topCandidates(1).first?.string }
                .joined(separator: "\n")
            
            DispatchQueue.main.async(execute: {
                self.extractedText = text
                
                let parsed = ReceiptParser.parse(from: text)
                print("EXTRAÍDO:", parsed)
                
                let finance = Finance(
                    finance_id: 0,
                    user_id: user?.user_id ?? 0,
                    name: parsed.serviceType ?? "Servicio",
                    date: Date(),
                    category: "Hogar",
                    amount: parsed.amount ?? 0.0,
                    type: "Egreso",
                    local_user_reference: user?.id ?? UUID(),
                    updatedAt: Date()
                )
                

                self.onFinish(finance)
                
                self.dismiss()
            })
        }
        
        request.recognitionLevel = VNRequestTextRecognitionLevel.accurate
        request.usesLanguageCorrection = true
        
        DispatchQueue.global(qos: .userInitiated).async {
            try? requestHandler.perform([request])
        }
    }
}


