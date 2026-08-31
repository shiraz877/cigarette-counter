//
//  View+Extensions.swift
//  CigaretteCouter
//
//  Created by Shiraz on 18/08/26.
//

import SwiftUI

extension View {
    
    
    func mainBackgroundColor() -> some View {
        self
            .background(
                ZStack{
                    AppColors.neutralColor
                        .ignoresSafeArea()
                }
            )
    }
}
