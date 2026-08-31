import SwiftUI

struct SpendingView: View {
    
    var viewModel: OnboardingViewModel
    
    
    var body: some View {
        VStack(spacing: 24) {
            
            
            
            VStack(spacing: 0) {
                
                // MARK: Main Content
                
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    // MARK: Hero
                    Spacer()
                    header
                    
                    Spacer()
                    // MARK: Spending Cards
                    
                    spendingCards
                    
                    
                }
                
                
                
                
            }
            Spacer()
            PrimaryButton(title: "CONTINUE",iconName: "arrow.right") {
                viewModel.nextStep()
            }
            
        }
        .padding(AppTheme.standardPadding)
    }
}



// MARK: - Header

extension SpendingView {
    
    private var header: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            Text("Small habits add up.")
                .font(
                    .system(
                        size: 42,
                        weight: .bold,
                        design: .default
                    )
                )
                .tracking(-1.92)
                .lineSpacing(-5)
                .foregroundStyle(AppColors.primaryColor)
                .fixedSize(
                    horizontal: false,
                    vertical: true
                )
            
            Text(
                "See how much you spend on cigarettes every day, week, and month."
            )
            .font(
                .system(
                    size: 15,
                    weight: .regular,
                    design: .default
                )
            )
            .lineSpacing(2)
            .foregroundStyle(AppColors.tertiaryColor)
            .fixedSize(
                horizontal: false,
                vertical: true
            )
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .padding(.bottom)
        
    }
}

// MARK: - Spending Cards

extension SpendingView {
    
    private var spendingCards: some View {
        VStack(spacing: 1) {
            
            spendingCard(
                title: "TODAY",
                amount: "120"
            )
            
            spendingCard(
                title: "THIS WEEK",
                amount: "840"
            )
            
            monthlyCard
        }
        .background(
            AppColors.secondaryColor.opacity(0.35)
        )
    }
}

// MARK: - Normal Card

extension SpendingView {
    
    private func spendingCard(
        title: String,
        amount: String
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 6
        ) {
            
            Text(title)
                .font(
                    .system(
                        size: 11,
                        weight: .semibold,
                        design: .monospaced
                    )
                )
                .tracking(0.8)
                .foregroundStyle(AppColors.primaryColor)
            
            HStack(
                alignment: .firstTextBaseline,
                spacing: 2
            ) {
                
                Text("₹")
                    .font(
                        .system(
                            size: 42,
                            weight: .regular
                        )
                    )
                    .foregroundStyle(AppColors.primaryColor)
                
                Text(amount)
                    .font(
                        .system(
                            size: 44,
                            weight: .regular
                        )
                    )
                    .tracking(-1.5)
                    .foregroundStyle(AppColors.primaryColor)
            }
        }
        .frame(
            maxWidth: .infinity,
            alignment: .leading
        )
        .frame(height: 146)
        .padding(.horizontal, 22)
        .background(AppColors.secondaryColor)
    }
}

// MARK: - Monthly Card

extension SpendingView {
    
    private var monthlyCard: some View {
        ZStack {
            
            AppColors.secondaryColor
            
            // MARK: Abstract Graph
            
            monthlyGraph
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .bottomTrailing
                )
            
            // MARK: Content
            
            VStack(
                alignment: .leading,
                spacing: 6
            ) {
                
                Text("THIS MONTH")
                    .font(
                        .system(
                            size: 11,
                            weight: .semibold,
                            design: .monospaced
                        )
                    )
                    .tracking(0.8)
                    .foregroundStyle(AppColors.primaryColor)
                
                HStack(
                    alignment: .firstTextBaseline,
                    spacing: 2
                ) {
                    
                    Text("₹")
                        .font(
                            .system(
                                size: 42,
                                weight: .regular
                            )
                        )
                        .foregroundStyle(AppColors.primaryColor)
                    
                    Text("3,600")
                        .font(
                            .system(
                                size: 52,
                                weight: .bold
                            )
                        )
                        .tracking(-2)
                        .foregroundStyle(AppColors.primaryColor)
                }
            }
            .frame(
                maxWidth: .infinity,
                alignment: .leading
            )
            .padding(.horizontal, 22)
        }
        .frame(height: 182)
    }
}

// MARK: - Monthly Graph

extension SpendingView {
    
    private var monthlyGraph: some View {
        GeometryReader { proxy in
            
            ZStack(alignment: .bottomTrailing) {
                
                // Main rectangle
                Path { path in
                    
                    let width = proxy.size.width
                    let height = proxy.size.height
                    
                    path.move(
                        to: CGPoint(
                            x: width * 0.66,
                            y: height
                        )
                    )
                    
                    path.addLine(
                        to: CGPoint(
                            x: width * 0.66,
                            y: height * 0.18
                        )
                    )
                    
                    path.addLine(
                        to: CGPoint(
                            x: width,
                            y: height * 0.18
                        )
                    )
                }
                .stroke(
                    AppColors.primaryColor.opacity(0.06),
                    lineWidth: 1
                )
                
                // Small graph line 1
                
                Rectangle()
                    .fill(AppColors.primaryColor.opacity(0.07))
                    .frame(
                        width: 1,
                        height: proxy.size.height * 0.30
                    )
                    .offset(
                        x: -48
                    )
                
                // Small graph line 2
                
                Rectangle()
                    .fill(AppColors.primaryColor.opacity(0.07))
                    .frame(
                        width: 1,
                        height: proxy.size.height * 0.60
                    )
                    .offset(
                        x: -24
                    )
                
                // Small graph line 3
                
                Rectangle()
                    .fill(AppColors.primaryColor.opacity(0.07))
                    .frame(
                        width: 1,
                        height: proxy.size.height * 0.90
                    )
                    .offset(
                        x: 0
                    )
                
            }
        }
        .padding(.leading, 120)
        .allowsHitTesting(false)
    }
}

// MARK: - Continue Button

extension SpendingView {
    
    private var continueButton: some View {
        
        PrimaryButton(title: "Continue",iconName: "arrow.right") {
            viewModel.nextStep()
        }
        
    }
}


