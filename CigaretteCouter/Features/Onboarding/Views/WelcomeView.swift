//
//  WelcomeView.swift
//  CigaretteCouter
//
//  Created by Shiraz on 17/08/26.
//

import SwiftUI

@MainActor
struct WelcomeView: View {
    var body: some View {
        ZStack {
           
            Color.black.ignoresSafeArea()
            
          
            VStack(alignment: .leading, spacing: 0) {
                
              
                Text("3")
                    .font(.system(size: 104, weight: .medium))
                    .foregroundStyle(AppColors.primaryColor)
                
                Spacer()
                
      
                Text("Know how much you smoke.")
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(AppColors.primaryColor)
                    .lineSpacing(2)
           
                Text("A simple way to track every cigarette and nunderstand your smoking habits.")
                    .font(.system(size: 23, weight: .regular))
                    .foregroundStyle(AppColors.tertiaryColor)
                    .lineSpacing(8)
                    .padding(.top, 24)
                
                Spacer()
                
               
                Button {
               
                } label: {
                    HStack(spacing: 18) {
                        Text("Get Started")
                            .font(.system(size: 19, weight: .semibold))
                            .tracking(1.2)
                        
                        Image(systemName: "arrow.right")
                            .font(.system(size: 28, weight: .regular))
                    }
                    .foregroundStyle(AppColors.secondaryColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 75)
                    .background(Color.white)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 36)
            .padding(.top, 42)
            .padding(.bottom, 96)
            .frame(maxWidth: .infinity)
            .frame(height: 815)

        }
    }
}

#Preview {
    WelcomeView()
       
}
