//
//  OnboardingViewModel.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI
import Observation

@Observable
final class OnboardingViewModel{
    enum OnboardingSteps:Int, CaseIterable{
        case welcome = 0
        case tracking = 1
        case patterns = 2
        case testimonials = 3
        case spending = 4
        case privacy = 5
        case ready = 6
        
        var progress: Double {
            Double(rawValue + 1) / Double(OnboardingSteps.allCases.count)
        }
    }
    
    var currentStep: OnboardingSteps = .welcome
    
    func nextStep(){
        if let next = OnboardingSteps(rawValue: currentStep.rawValue + 1){
        
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = next
                
            }
        }
    }
    
    func previousStep() {
        if let prev = OnboardingSteps(rawValue: currentStep.rawValue - 1) {
            
            withAnimation(.easeInOut(duration: 0.3)) {
                currentStep = prev
                print("next step",currentStep)
            }
        }
    }
    
    
}
