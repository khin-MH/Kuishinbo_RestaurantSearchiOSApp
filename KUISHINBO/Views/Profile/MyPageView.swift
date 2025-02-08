//
//  MyPageView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/06.
//

import SwiftUI

struct MyPageView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "person.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("会員の方はログインすると\nマイページをご確認いただけます。")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
          
            
            Button(action: {
                // Add login or register action here
            }) {
                Text("ログイン・会員登録する")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("マイページ")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MyPageView()
}
