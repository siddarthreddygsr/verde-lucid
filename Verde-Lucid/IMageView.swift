//
//  IMageView.swift
//  Verde-Lucid
//
//  Created by Siddarth Reddy on 18/11/23.
//

import SwiftUI
import PhotosUI

struct IMageView: View {
    @State var selectedImage: [PhotosPickerItem] = []
    @State var data: Data?
    
    var body: some View {
        VStack{
            if let data = data, let uiimage = UIImage(data:data) {
                Image(uiImage: uiimage)
                    .resizable()
            }
            Spacer()
            PhotosPicker(
                selection: $selectedImage,
                maxSelectionCount : 1,
                matching: .images
                
            ){
                Text("Pick Image")
            }
            .onChange(of: selectedImage) { newValue in
                guard let item = selectedImage.first else{
                    return
                }
                item.loadTransferable(type: Data.self) { result in
                    switch result{
                    case .success(let data):
                        if let data = data {
                            self.data = data
                        } else {
                            print("data is nil")
                        }
                    case .failure(let failure):
                        fatalError("\(failure)")
                    }
                }
            }
        }
    }
}

#Preview {
    IMageView()
}
