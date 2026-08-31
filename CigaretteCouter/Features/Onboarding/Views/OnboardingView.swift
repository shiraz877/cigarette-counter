//
//  OnboardingView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

@MainActor
struct OnboardingView: View {
    private var viewModel = OnboardingViewModel()
    @Environment(AppViewModel.self)
        private var appViewModel
    var body: some View {
        VStack(spacing: 0){
            
            //header progress bar
            if viewModel.currentStep != .welcome{
                HStack(spacing: 12){

                    
                    GeometryReader { geo in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(AppColors.secondaryColor)
                                .frame(height: 6)
                            
                            Capsule()
                                .fill(AppColors.primaryColor)
                                .frame(width: geo.size.width * viewModel.currentStep.progress, height: 6)
                        }
                    }
                    .frame(height: 6)
                }
                .padding(.horizontal, AppTheme.standardPadding)
                .padding(.top, 12)
            }
            
            Group{
                switch viewModel.currentStep {
                case .welcome:
                    WelcomeView(viewModel: viewModel)
                case .tracking:
                    TrackingView(viewModel: viewModel)
                case .patterns:
                    PatternsView(viewModel: viewModel)
                case .testimonials:
                    TestimonialsView(viewModel: viewModel)
                case .spending:
                    SpendingView(viewModel: viewModel)
                case .privacy:
                    PrivacyView(viewModel: viewModel)
                case .ready:
                    ReadyView(viewModel: viewModel){
                        appViewModel.completeOnboarding()
                    }
                }
            }
            .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .move(edge: .leading)))
        }
        .mainBackgroundColor()
        
    }
}
