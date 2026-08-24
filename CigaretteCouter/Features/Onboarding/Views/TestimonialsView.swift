//
//  TestimonialsView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct OnboardingRealLifeView: View {
    
    // MARK: - Colors
    
    private let background = Color(
        red: 19 / 255,
        green: 19 / 255,
        blue: 19 / 255
    )
    
    private let surfaceVariant = Color(
        red: 53 / 255,
        green: 53 / 255,
        blue: 53 / 255
    )
    
    private let primary = Color.white
    
    private let secondary = Color(
        red: 200 / 255,
        green: 198 / 255,
        blue: 197 / 255
    )
    
    // MARK: - State
    
//    var body: some View {
//        ZStack {
//            AppColors.neutralColor
//                .ignoresSafeArea()
//            
//            VStack(spacing: 0) {
//                
//                // MARK: Progress
//                
////                progressIndicator
//                
//                // MARK: Hero
//                
//                Text("Made for real life.")
//                    .font(
//                        .system(
//                            size: 72,
//                            weight: .bold,
//                            design: .default
//                        )
//                    )
//                    .tracking(-2.88)
//                    .foregroundStyle(primary)
//                    .frame(
//                        maxWidth: .infinity,
//                        alignment: .leading
//                    )
//                    .fixedSize(horizontal: false, vertical: true)
//                    .padding(.top, 64)
//                    .padding(.bottom, 64)
//                
//                // MARK: Testimonials
//                
//                testimonials
//                
//                Spacer(minLength: 0)
//                
//                // MARK: Continue
//                
//                continueButton
//                    .padding(.top, 64)
//            }
//            .padding(.horizontal, 24)
//            .padding(.top, 32)
//            .padding(.bottom, 64)
//            .frame(maxWidth: 672)
//            .frame(maxWidth: .infinity)
//        }
//        .preferredColorScheme(.dark)
//    }
    var body: some View {
        ZStack {
            AppColors.neutralColor
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                
                // MARK: Progress
                
                 progressIndicator
                
                // MARK: Scrollable Content
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        
                        // MARK: Hero
                        
                        Text("Made for real life.")
                            .font(
                                .system(
                                    size: 72,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                            .tracking(-2.88)
                            .foregroundStyle(primary)
                            .frame(
                                maxWidth: .infinity,
                                alignment: .leading
                            )
                            .fixedSize(
                                horizontal: false,
                                vertical: true
                            )
                            .padding(.top, 64)
                            .padding(.bottom, 64)
                        
                        // MARK: Testimonials
                        
                        testimonials
                    }
                    .padding(.horizontal, 24)
                }
                
                // MARK: Continue
                
                continueButton
                    .padding(.horizontal, 24)
                    .padding(.top, 24)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: 672)
            .frame(maxWidth: .infinity)
        }
        .preferredColorScheme(.dark)
    }
}

// MARK: - Progress Indicator

extension OnboardingRealLifeView {
    
    private var progressIndicator: some View {
        HStack(spacing: 4) {
            
            ForEach(0..<7, id: \.self) { index in
                
                Rectangle()
                    .fill(
                        index < 5
                        ? primary
                        : surfaceVariant
                    )
                    .frame(height: 2)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.top, 16)
        .padding(.bottom, 64)
    }
}

// MARK: - Testimonials

//extension OnboardingRealLifeView {
//    
//    private var testimonials: some View {
//        VStack(spacing: 0) {
//            
//            testimonial(
//                text: """
//                "I started tracking just to see how much I actually smoked. After a few weeks, I noticed patterns I never paid attention to."
//                """,
//                author: "— ALEX, 24"
//            )
//            
//            testimonial(
//                text: """
//                "The simple counter made me realize how often I was smoking during work."
//                """,
//                author: "— SAM, 29"
//            )
//            
//            // Closing border
//            Rectangle()
//                .fill(surfaceVariant)
//                .frame(height: 1)
//        }
//    }
//    
//    private func testimonial(
//        text: String,
//        author: String
//    ) -> some View {
//        
//        VStack(alignment: .leading, spacing: 16) {
//            
//            // Top border
//            Rectangle()
//                .fill(surfaceVariant)
//                .frame(height: 1)
//            
//            Text(text)
//                .font(
//                    .system(
//                        size: 28,
//                        weight: .semibold,
//                        design: .default
//                    )
//                )
//                .tracking(-0.56)
//                .lineSpacing(4)
//                .foregroundStyle(primary)
//                .frame(
//                    maxWidth: .infinity,
//                    alignment: .leading
//                )
//            
//            Text(author)
//                .font(
//                    .system(
//                        size: 12,
//                        weight: .semibold,
//                        design: .monospaced
//                    )
//                )
//                .tracking(1.2)
//                .foregroundStyle(secondary)
//                .textCase(.uppercase)
//            
//        }
//        .padding(.top, 16)
//        .padding(.bottom, 32)
//    }
//}
extension OnboardingRealLifeView {
    
    private var testimonials: some View {
        VStack(spacing: 0) {
            
            testimonial(
                text: "\"I started tracking just to see how much I actually smoked. After a few weeks, I noticed patterns I never paid attention to.\"",
                author: "— ALEX, 24"
            )
            
            testimonial(
                text: "\"The simple counter made me realize how often I was smoking during work.\"",
                author: "— SAM, 29"
            )
            
            Rectangle()
                .fill(surfaceVariant)
                .frame(height: 1)
        }
    }
    
    private func testimonial(
        text: String,
        author: String
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            Rectangle()
                .fill(surfaceVariant)
                .frame(height: 1)
            
            Text(text)
                .font(
                    .system(
                        size: 28,
                        weight: .semibold
                    )
                )
                .tracking(-0.56)
                .lineSpacing(4)
                .foregroundStyle(primary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
            
            Text(author)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .tracking(1.2)
                .foregroundStyle(secondary)
            
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}
// MARK: - Continue Button

extension OnboardingRealLifeView {
    
    private var continueButton: some View {
        
        Button {
            // Go to next onboarding page
        } label: {
            
            HStack {
                
                Text("CONTINUE")
                    .font(
                        .system(
                            size: 12,
                            weight: .bold,
                            design: .monospaced
                        )
                    )
                    .tracking(1.2)
                
                Spacer()
                
                Image(systemName: "arrow.forward")
                    .font(
                        .system(
                            size: 20,
                            weight: .light
                        )
                    )
            }
            .foregroundStyle(background)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .frame(height: 48)
            .background(primary)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    OnboardingRealLifeView()
}
