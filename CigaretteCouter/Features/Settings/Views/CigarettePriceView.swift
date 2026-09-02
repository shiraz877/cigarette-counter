//
//  PackPriceEditorView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 21/08/26.
//

import SwiftUI

struct CigarettePriceView: View {

    let initialPricePaise: Int
    let onSave: (Int) async -> Void

    @Environment(\.dismiss)
    private var dismiss

    @State private var price: Double
    @State private var isSaving = false

    init(
        initialPricePaise: Int,
        onSave: @escaping (Int) async -> Void
    ) {
        self.initialPricePaise = initialPricePaise
        self.onSave = onSave

        _price = State(
            initialValue: Double(initialPricePaise) / 100.0
        )
    }

    var body: some View {
        VStack(spacing: 0) {

            Spacer()

            
            // MARK: - Header

            VStack(spacing: 12) {



                Text("₹\(price, specifier: "%.0f")")
                    .font(
                        .system(
                            size: 56,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

            }

            Spacer()

           
            // MARK: - Price Slider

            VStack(spacing: 20) {

                HStack {
                    Text("₹1")

                    Spacer()

                    Text("₹100")
                }
                .font(
                    .system(
                        size: 13,
                        weight: .medium
                    )
                )
                .foregroundStyle(
                    AppColors.tertiaryColor
                )

                Slider(
                    value: $price,
                    in: 1...100,
                    step: 1
                )
                .tint(AppColors.primaryColor)


            }

            Spacer()

            // MARK: - Save

            PrimaryButton(
                title: isSaving ? "SAVING..." : "SAVE"
            ) {
                save()
            }
            .disabled(isSaving)
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 24)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity
        )
        
        .background(Color.black)
        .navigationTitle("Cigarette price")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(
            Color.black,
            for: .navigationBar
        )
        .toolbarBackground(
            .visible,
            for: .navigationBar
        )
        .preferredColorScheme(.dark)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 32, height: 32)
//                            .background(
//                                Circle()
//                                    .fill(.white)
//                            )
//                            .shadow(
//                                color: .black.opacity(0.2),
//                                radius: 4,
//                                y: 2
//                            )
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Close")
            }
        }
        .toolbarColorScheme(.dark, for: .navigationBar)
    }

    // MARK: - Save

    private func save() {
        let paise = Int(
            (price * 100).rounded()
        )

        Task {
            isSaving = true

            await onSave(paise)

            isSaving = false
            dismiss()
        }
    }
}
