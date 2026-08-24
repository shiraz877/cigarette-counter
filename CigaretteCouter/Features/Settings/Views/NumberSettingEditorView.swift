//
//  NumberSheetView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 21/08/26.
//

import SwiftUI

struct NumberSettingEditor: View {
    
    let title: String
    let initialValue: Int
    let onSave: (Int) async -> Void
    
    @Environment(\.dismiss)
    private var dismiss
    
    @State private var value: Int
    @State private var isSaving = false
    
    init(
        title: String,
        initialValue: Int,
        onSave: @escaping (Int) async -> Void
    ) {
        self.title = title
        self.initialValue = initialValue
        self.onSave = onSave
        
        _value = State(
            initialValue: initialValue
        )
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            Spacer()
            
            // MARK: - Value
            
            VStack(spacing: 12) {
                
                Text("DAILY LIMIT")
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold
                        )
                    )
                    .tracking(2)
                    .foregroundStyle(
                        Color.secondaryText
                    )
                
                Text("\(value)")
                    .font(
                        .system(
                            size: 64,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    .contentTransition(
                        .numericText()
                    )
                
                Text("cigarettes per day")
                    .font(.system(size: 15))
                    .foregroundStyle(
                        Color.secondaryText
                    )
            }
            
            Spacer()
            
            // MARK: - Stepper
            
            HStack(spacing: 0) {
                
                Button {
                    if value > 1 {
                        value -= 1
                    }
                } label: {
                    Image(systemName: "minus")
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: 56,
                            height: 56
                        )
                }
                
                Spacer()
                
                Text("\(value)")
                    .font(
                        .system(
                            size: 22,
                            weight: .semibold
                        )
                    )
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button {
                    if value < 100 {
                        value += 1
                    }
                } label: {
                    Image(systemName: "plus")
                        .font(
                            .system(
                                size: 18,
                                weight: .semibold
                            )
                        )
                        .foregroundStyle(.white)
                        .frame(
                            width: 56,
                            height: 56
                        )
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 72)
            .background(
                Color.white.opacity(0.06)
            )
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
            )
            .overlay {
                RoundedRectangle(
                    cornerRadius: 20,
                    style: .continuous
                )
                .stroke(
                    Color.white.opacity(0.08),
                    lineWidth: 1
                )
            }
            
            Spacer()
            
            // MARK: - Save
            
            PrimaryButton(
                title: isSaving ? "SAVING..." : "SAVE"
            ) {
                Task {
                    isSaving = true
                    
                    await onSave(value)
                    
                    isSaving = false
                    dismiss()
                }
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
        .navigationTitle(title)
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
    }
}
