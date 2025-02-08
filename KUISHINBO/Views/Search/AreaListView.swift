//
//  AreaListView.swift
//  KUISHINBO
//
//
//  Created by KHIN MYOHTUN on 2025/02/02.
//
import SwiftUI

struct AreaListView: View {
    let areas: [String] = [
            "新宿", "渋谷", "池袋", "銀座", "上野", "秋葉原", "六本木", "浅草", "中野", "恵比寿",
            "東京駅", "品川", "田町", "大井町", "赤坂", "神田", "吉祥寺", "立川", "お台場", "豊洲",
            "自由が丘", "表参道", "原宿", "高円寺", "下北沢", "築地", "神楽坂", "門前仲町", "三軒茶屋", "押上"
        ]
    @Binding var selectedArea: String? // Track the selected area
    @State private var navigateToDetail = false // For navigation
    @Environment(\.presentationMode) var presentationMode

    @StateObject private var searchAreaModel = SearchAreaModel() // Fetch area restaurants

    var body: some View {
        NavigationView {
            VStack {
                List(areas, id: \.self) { area in
                    HStack {
                        Text(area)
                            .font(.body)
                        Spacer()
                        if selectedArea == area {
                            Image(systemName: "checkmark")
                                .foregroundColor(.orange)
                        }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        selectedArea = area
                    }
                }
                .listStyle(PlainListStyle())
                
                // Confirm Button
                Button(action: {
                    if let selected = selectedArea {
                        Task {
                            await searchAreaModel.fetchRestaurants(for: selected)
                            navigateToDetail = true
                        }
                    }
                }) {
                    Text("確定")
                        .font(.headline)
                        .frame(maxWidth: 100, minHeight: 50)
                        .background(selectedArea == nil ? Color.gray : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
                .disabled(selectedArea == nil)
                .background(
                    NavigationLink(
                        destination: SearchDetailView(option: selectedArea ?? "エリア", restaurants: searchAreaModel.areaShops),
                        isActive: $navigateToDetail,
                        label: { EmptyView() }
                    )
                )
            }
            .navigationTitle("エリアを選ぶ")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "chevron.backward")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                }
            }
        }
            .onDisappear {
                        selectedArea = nil // Reset genre when view is dismissed
                    }
            
    }
}
