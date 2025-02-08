//
//  SplashScreenView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/08.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @StateObject private var savedRestaurantsModel = SavedRestaurantsModel()
    
    var body: some View {
        if isActive {
            ContentView() // Replace with your main content view
                .environmentObject(savedRestaurantsModel) // Provide environment object
        } else {
            VStack {
                Image("SplashScreenImage") // Use the name of the image added to assets
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color("SplashBackground")) // Optional: Add background color
            .edgesIgnoringSafeArea(.all)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}


#Preview {
    SplashScreenView()
}
