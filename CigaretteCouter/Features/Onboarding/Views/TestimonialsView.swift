//
//  TestimonialsView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

struct TestimonialsView: View {
    var viewModel: OnboardingViewModel
    
    // MARK: - State
    var body: some View {
        VStack (spacing: 24){
       
            
            VStack(spacing: 0) {
                
                
                
                // MARK: Scrollable Content
                

                    VStack(spacing: 0) {
                        
                        // MARK: Hero
                        
                        Text("Made for real life.")
                            .font(
                                .system(
                                    size: 50,
                                    weight: .bold,
                                    design: .default
                                )
                            )
                            .tracking(-2.88)
                            .foregroundStyle(AppColors.primaryColor)
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
            Spacer()
            PrimaryButton(title: "CONTINUE",iconName: "arrow.right") {
                viewModel.nextStep()
            }

        }
        .padding(AppTheme.standardPadding)
    }
}




extension TestimonialsView {
    
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
            Divider()
                .overlay(AppColors.tertiaryColor)
            
        }
    }
    
    private func testimonial(
        text: String,
        author: String
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 16) {
            
            
            Divider()
                .overlay(AppColors.tertiaryColor)
            
            Text(text)
                .font(
                    .system(
                        size: 20,
                        weight: .semibold
                    )
                )
                .tracking(-0.56)
                .lineSpacing(4)
                .foregroundStyle(AppColors.primaryColor)
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
                .foregroundStyle(AppColors.tertiaryColor)
            
        }
        .padding(.top, 16)
        .padding(.bottom, 32)
    }
}
// MARK: - Continue Button

extension TestimonialsView {
    
    private var continueButton: some View {
        
        PrimaryButton(title: "Contineu",iconName: "arrow.right") {
            viewModel.nextStep()
        }
    }
}



