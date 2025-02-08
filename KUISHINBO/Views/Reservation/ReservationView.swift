//
//  ReservationView.swift
//  KUISHINBO
//
//  Created by KHIN MYOHTUN on 2025/02/06.
//
import SwiftUI

struct ReservationView: View {
    var body: some View {
        VStack(spacing: 20) {
            
            Image(systemName: "calendar.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.gray)
            
            Text("予約はありません。")
                .font(.headline)
                .foregroundColor(.gray)
            
            Text("会員の方はログインすると\n予約内容をご確認いただけます。")
                .font(.subheadline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            
            Button(action: {
                // Add login action here
            }) {
                Text("ログインする")
                    .font(.headline)
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .background(Color.orange)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .padding()
        .navigationTitle("予約")
        .navigationBarTitleDisplayMode(.inline)
    }
}



#Preview {
    ReservationView()
}
