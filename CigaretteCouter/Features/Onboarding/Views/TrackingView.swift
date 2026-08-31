//
//  TrackingView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

@MainActor
struct TrackingView: View {
    var viewModel: OnboardingViewModel
    // MARK: - State
    
    @State private var counter = 5
    @State private var isAnimatingNumber = false
    @State private var showRipple = false
    
    var body: some View {
        VStack(spacing: 24) {
            
            
            VStack(spacing: 0) {
                
                // MARK: Main Content
                
                
                VStack(spacing: 0) {
                    
                    // Text
                    textContent
                    
                    // App Preview
                    appPreview
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                
                // MARK: Bottom Actions
                
                
            }
            Spacer()
            PrimaryButton(title: "CONTINUE",iconName: "arrow.right") {
                viewModel.nextStep()
            }
        }
        .padding(AppTheme.standardPadding)
        .onAppear {
            startCounterAnimation()
        }
    }
}

// MARK: - Text Content

extension TrackingView {
    
    private var textContent: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("One tap. One cigarette.")
                .font(
                    .system(
                        size: 28,
                        weight: .semibold
                    )
                )
                .tracking(-0.56)
                .foregroundStyle(AppColors.primaryColor)
            
            Text(
                "Whenever you smoke, simply open the app and log it. Your daily count updates instantly."
            )
            .font(
                .system(
                    size: 16,
                    weight: .regular
                )
            )
            .lineSpacing(2)
            .foregroundStyle(AppColors.tertiaryColor)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.bottom, 40)
    }
}

// MARK: - App Preview

extension TrackingView {
    
    private var appPreview: some View {
        GeometryReader { geometry in
            
            ZStack {
                
                
                AppColors.neutralColor
                
                // Border
                Rectangle()
                    .stroke(
                        AppColors.tertiaryColor,
                        lineWidth: 1
                    )
                
                // Header
                previewHeader
                
                // Counter
                counterView
                
                // Add button
                addButton
            }
        }
        .frame(
            width: 280,
            height: 498
        )
        .frame(maxWidth: .infinity)
        .padding(.bottom, 32)
    }
    
    private var previewHeader: some View {
        VStack {
            HStack {
                
                Text("TODAY")
                    .font(
                        .system(
                            size: 12,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .tracking(1.2)
                    .foregroundStyle(AppColors.primaryColor)
                
                Spacer()
            }
            .padding(16)
            
            Rectangle()
                .fill(AppColors.primaryColor)
                .frame(height: 1)
        }
        .frame(
            maxWidth: .infinity,
            alignment: .top
        )
        .frame(
            maxHeight: .infinity,
            alignment: .top
        )
    }
}

// MARK: - Counter

extension TrackingView {
    
    private var counterView: some View {
        VStack {
            Spacer()
            
            ZStack {
                if isAnimatingNumber {
                    Text("\(counter)")
                        .font(
                            .system(
                                size: 72,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(AppColors.primaryColor)
                        .offset(y: -30)
                        .opacity(0)
                } else {
                    Text("\(counter)")
                        .font(
                            .system(
                                size: 72,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(AppColors.primaryColor)
                        .transition(
                            .asymmetric(
                                insertion: .move(edge: .bottom)
                                    .combined(with: .opacity),
                                removal: .move(edge: .top)
                                    .combined(with: .opacity)
                            )
                        )
                }
            }
            
            Spacer()
        }
        .padding(.top, 48)
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Add Button

extension TrackingView {
    
    private var addButton: some View {
        ZStack {
            
            
            Circle()
                .fill(AppColors.secondaryColor)
                .overlay {
                    Circle()
                        .stroke(
                            AppColors.secondaryColor,
                            lineWidth: 1
                        )
                }
                .frame(width: 64, height: 64)
            
            Image(systemName: "plus")
                .font(
                    .system(
                        size: 24,
                        weight: .light
                    )
                )
                .foregroundStyle(AppColors.primaryColor)
        }
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .bottom
        )
        .padding(.bottom, 32)
    }
}



// MARK: - Animation

extension TrackingView {
    
    private func startCounterAnimation() {
        
        Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: true
        ) { _ in
            
            // Ripple animation
            showRipple = true
            
            withAnimation(
                .easeOut(duration: 0.4)
            ) {
                showRipple = false
            }
            
            // Number exits
            withAnimation(
                .easeIn(duration: 0.4)
            ) {
                isAnimatingNumber = true
            }
            
            // Change number
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 0.4
            ) {
                
                counter = counter == 5 ? 6 : 5
                
                withAnimation(
                    .easeOut(duration: 0.4)
                ) {
                    isAnimatingNumber = false
                }
            }
        }
    }
}





