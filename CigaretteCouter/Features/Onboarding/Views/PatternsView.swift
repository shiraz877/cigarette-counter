//
//  Patterns.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct PatternsView: View {
    
    // MARK: - Constants
    //
    //    private let backgroundColor = Color(red: 0.075, green: 0.075, blue: 0.075)
    //    private let surfaceVariant = Color(red: 0.208, green: 0.208, blue: 0.208)
    //    private let textColor = Color(red: 0.886, green: 0.886, blue: 0.886)
    //    private let secondaryText = Color(red: 0.769, green: 0.780, blue: 0.784)
    
    private let barHeights: [CGFloat] = [
        0.30,
        0.45,
        0.85,
        0.40,
        0.70,
        1.00,
        0.55
    ]
    
    private let days = ["M", "T", "W", "T", "F", "S", "S"]
    
    var body: some View {
        ZStack {
            AppColors.neutralColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: Top Section
                header
                
                // MARK: Chart
                chart
                
                // MARK: Bottom Section
                footer
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: 448)
            .frame(maxWidth: .infinity)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Header

extension PatternsView {
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Your habits have patterns.")
                .font(
                    .system(
                        size: 28,
                        weight: .semibold,
                        design: .rounded
                    )
                )
                .tracking(-0.56)
                .foregroundStyle(AppColors.primaryColor)
            
            Text("""
            See when you smoke the most, how often you smoke, and how your habits change over time.
            """)
            .font(
                .system(
                    size: 16,
                    weight: .regular,
                    design: .default
                )
            )
            .lineSpacing(2)
            .foregroundStyle(AppColors.tertiaryColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.top, 16)
    }
}

// MARK: - Chart

extension PatternsView {
    
    private var chart: some View {
        VStack(spacing: 8) {
            
            GeometryReader { geometry in
                ZStack {
                    
                    // Horizontal guide lines
                    VStack {
                        ForEach(0..<4, id: \.self) { _ in
                            Rectangle()
                                .fill(AppColors.secondaryColor.opacity(0.20))
                                .frame(height: 1)
                            
                            Spacer()
                        }
                    }
                    
                    // Bars
                    HStack(
                        alignment: .bottom,
                        spacing: 0
                    ) {
                        ForEach(0..<barHeights.count, id: \.self) { index in
                            
                            VStack {
                                Spacer()
                                
                                Rectangle()
                                    .fill(
                                        isHighlighted(index)
                                        ? AppColors.primaryColor
                                        : AppColors.secondaryColor
                                    )
                                    .frame(
                                        width: 32,
                                        height: geometry.size.height * barHeights[index]
                                    )
                                    .shadow(
                                        color: isHighlighted(index)
                                        ? AppColors.primaryColor.opacity(0.10)
                                        : .clear,
                                        radius: 15
                                    )
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
                    // Bottom axis
                    VStack {
                        Spacer()
                        
                        Rectangle()
                            .fill(AppColors.tertiaryColor.opacity(0.3))
                            .frame(height: 1)
                        Spacer()
                        Rectangle()
                            .fill(AppColors.tertiaryColor.opacity(0.3))
                            .frame(height: 1)
                        Spacer()
                        Rectangle()
                            .fill(AppColors.tertiaryColor.opacity(0.3))
                            .frame(height: 1)
                    }
                    
                }
            }
            .frame(height: 192)
            
            // Day labels
            HStack {
                ForEach(0..<days.count, id: \.self) { index in
                    
                    Text(days[index])
                        .font(
                            .system(
                                size: 12,
                                weight: .semibold,
                                design: .monospaced
                            )
                        )
                        .tracking(1.2)
                        .foregroundStyle(
                            isHighlighted(index)
                            ? AppColors.primaryColor
                            : AppColors.tertiaryColor
                        )
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 12)
        }
        .frame(maxHeight: .infinity)
        .padding(.vertical, 64)
    }
    
    private func isHighlighted(_ index: Int) -> Bool {
        index == 2 || index == 5
    }
}

// MARK: - Footer

extension PatternsView {
    
    private var footer: some View {
        VStack(spacing: 32) {
            
            
            
            continueButton
        }
        .padding(.bottom, 16)
    }
}


// MARK: - Continue Button

extension PatternsView {
    
    private var continueButton: some View {
        Button {
            // Move to next onboarding screen
        } label: {
            Text("CONTINUE")
                .font(
                    .system(
                        size: 12,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .tracking(1.5)
                .foregroundStyle(.black)
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .background(Color.white)
        }
        .buttonStyle(.plain)
    }
}


