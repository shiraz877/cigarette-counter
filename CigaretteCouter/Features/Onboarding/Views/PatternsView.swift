//
//  Patterns.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct PatternsView: View {
    var viewModel: OnboardingViewModel
    
    
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
        VStack(spacing: 24) {
            
            
            VStack(spacing: 0) {
                
                // MARK: Top Section
                header
                
                // MARK: Chart
                chart
                
                // MARK: Bottom Section
               
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
            .frame(maxWidth: 448)
            .frame(maxWidth: .infinity)
            
            Spacer()
            PrimaryButton(title: "CONTINUE", iconName: "arrow.right") {
                viewModel.nextStep()
            }
        }
        .padding(AppTheme.standardPadding)
        
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
                                Divider()
                                    .overlay(AppColors.tertiaryColor)
                                Text(days[index])
                                    .foregroundStyle(AppColors.primaryColor)
                                Divider()
                                    .overlay(AppColors.tertiaryColor)
                            }
                            .frame(maxWidth: .infinity)
                        }
                    }
                    
     
                    
                }
            }
            .frame(height: 192)
            

        }
        .frame(maxHeight: .infinity)
        .padding(.vertical, 64)
    }
    
    private func isHighlighted(_ index: Int) -> Bool {
        index == 2 || index == 5
    }
}






