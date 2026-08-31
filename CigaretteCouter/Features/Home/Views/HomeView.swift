import SwiftUI

@MainActor
struct HomeView: View {
    
    @State private var viewModel = HomeViewModel()
    @State private var showAllCigarettes = false
    
    var body: some View {
        
        VStack(spacing: 0) {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    
                    Text("TODAY")
                        .font(.system(size: 12, weight: .bold))
                        .tracking(2.0)
                        .foregroundColor(AppColors.tertiaryColor)
                        .padding(.top, 24)
                    
                    cigaretteCount
                    
                    Divider().background(AppColors.tertiaryColor)
                    
                    cigaretteSummary
                   
                    Divider().background(AppColors.tertiaryColor)
                  
                    PrimaryButton(title: viewModel.isRecording
                        ? "Recording..."
                        : "Count Cigarette",
                        iconName: "plus"
                    ) {
                        
                        Task {
                            await viewModel.recordCigarette()
                        }
                    }
                    .disabled(
                        viewModel.isRecording
                    )
                    
                    timeLine
                }
                .padding(
                    AppTheme.standardPadding
                )
            }
        }
        .mainBackgroundColor()
        .task {
            
            await viewModel.loadCigarettes()
        }
        .alert(
            "Something went wrong",
            isPresented: Binding(
                get: {
                    viewModel.errorMessage != nil
                },
                set: { isPresented in
                    
                    if !isPresented {
                        viewModel.clearError()
                    }
                }
            )
        ) {
            
            Button("OK") {
                viewModel.clearError()
            }
            
        } message: {
            
            Text(
                viewModel.errorMessage ?? ""
            )
        }
    }
    

    private var lastCigaretteValue: String {
        guard let latestCigarette = viewModel.latestCigarette else {
            return "--"
        }

        let interval = Date().timeIntervalSince(
            latestCigarette.smokedAt
        )

        return viewModel.formatDuration(interval)
    }
    
    // MARK: - Today Spending
    private var todaySpending: Int {
        
        guard let settings = viewModel.settings else {
            return 0
        }
        

        let cigarettePrice = Double(settings.cigarettePricePaise)/100.0
        

        return Int(
            Double(viewModel.cigaretteCount)
            * cigarettePrice
        )
    }
    
    // MARK: - Stat Item
    private func statItem(
        title: LocalizedStringKey,
        value: String
    ) -> some View {
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            
            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.0)
                .foregroundColor(
                    AppColors.tertiaryColor
                )
            
            Text(value)
                .font(
                    .system(
                        size: 40,
                        weight: .light
                    )
                )
                .foregroundColor(
                    AppColors.primaryColor
                )
        }
    }
    
    // MARK: - Stat With Unit
    private func statItemWithUnit(
        title: LocalizedStringKey,
        value: String,
        unit: String
    ) -> some View {
        
        VStack(
            alignment: .leading,
            spacing: 4
        ) {
            
            Text(title)
                .font(
                    .system(
                        size: 12,
                        weight: .semibold
                    )
                )
                .tracking(1.0)
                .foregroundColor(
                    AppColors.tertiaryColor
                )
            
            HStack(
                alignment: .firstTextBaseline,
                spacing: 2
            ) {
                
                Text(value)
                    .font(
                        .system(
                            size: 40,
                            weight: .light
                        )
                    )
                    .foregroundColor(
                        AppColors.primaryColor
                    )
                
                Text(unit)
                    .font(
                        .system(size: 20)
                    )
                    .foregroundColor(
                        AppColors.tertiaryColor
                    )
            }
        }
    }
    
    // MARK: - Timeline Row
    private func timelineRow(
        cigarette: CigaretteModel
    ) -> some View {
        
        HStack {
            
            Text(
                cigarette.smokedAt.formatted(
                    .dateTime
                        .hour()
                        .minute()
                        .locale(Locale.current)
                )
            )
            .font(
                .system(size: 16)
            )
            .foregroundColor(
                AppColors.tertiaryColor
            )
            .frame(
                width: 85,
                alignment: .leading
            )
            
            VStack(
                alignment: .leading,
                spacing: 3
            ) {
                
                Text("Cigarette")
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundColor(
                        AppColors.primaryColor
                    )
                
                if let trigger =
                    cigarette.trigger {
                    
                    Text(trigger.title)
                        .font(
                            .system(
                                size: 12,
                                weight: .medium
                            )
                        )
                        .foregroundColor(
                            AppColors.tertiaryColor
                        )
                }
            }
            
            Spacer()
            
            Button {
                
                Task {
                    await viewModel.deleteCigarette(
                        cigarette
                    )
                }
                
            } label: {
                
                Image(
                    systemName: "trash.fill"
                )
                .foregroundColor(
                    Color(hex: "#FFB4AB")
                )
            }
        }
        .padding(.vertical, 12)
    }
}
extension HomeView {
    private var cigaretteCount: some View {
        VStack(alignment: .leading, spacing: 4) {
            
            Text(
                "\(viewModel.cigaretteCount)"
            )
            .font(
                .system(
                    size: 72,
                    weight: .bold
                )
            )
            .foregroundColor(
                AppColors.primaryColor
            )
            
            Text(
                viewModel.cigaretteCount == 1
                ? "CIGARETTE"
                : "CIGARETTES"
            )
            .font(
                .system(
                    size: 28,
                    weight: .bold
                )
            )
            .tracking(-0.5)
            .foregroundColor(
                AppColors.primaryColor
            )
        }
    }
}
extension HomeView {
    private var cigaretteSummary: some View {
        VStack(
            alignment: .leading,
            spacing: 20
        ) {
            
            statItem(
                title: "TODAY",
                value: "\(viewModel.cigaretteCount)"
            )
            
            statItemWithUnit(
                title: "LAST CIGARETTE",
                value: lastCigaretteValue,
                unit: ""
            )
            
            statItem(
                title: "SPENDING",
                value: "₹\(todaySpending)"
            )
        }
    }
}
extension HomeView {
//    private var timeLine: some View {
//        VStack(
//            alignment: .leading,
//            spacing: 16
//        ) {
//            
//            Text("TIMELINE")
//                .font(
//                    .system(
//                        size: 12,
//                        weight: .bold
//                    )
//                )
//                .tracking(1.5)
//                .foregroundColor(
//                    AppColors.tertiaryColor
//                )
//            
//            if viewModel.cigarettes.isEmpty {
//                
//                Text(
//                    "No cigarettes logged today"
//                )
//                .font(
//                    .system(size: 15)
//                )
//                .foregroundColor(
//                    AppColors.tertiaryColor
//                )
//                .padding(.vertical, 12)
//                
//            } else {
//                
//                ForEach(
//                    viewModel.cigarettes
//                ) { cigarette in
//                    
//                    timelineRow(
//                        cigarette: cigarette
//                    )
//                    
//                    Divider()
//                        .overlay(
//                            AppColors.tertiaryColor
//                        )
//                }
//            }
//        }
//    }
    private var timeLine: some View {
        VStack(
            alignment: .leading,
            spacing: 16
        ) {
            Text("TIMELINE")
                .font(
                    .system(
                        size: 12,
                        weight: .bold
                    )
                )
                .tracking(1.5)
                .foregroundColor(
                    AppColors.tertiaryColor
                )

            if viewModel.cigarettes.isEmpty {

                Text("No cigarettes logged today")
                    .font(.system(size: 15))
                    .foregroundColor(
                        AppColors.tertiaryColor
                    )
                    .padding(.vertical, 12)

            } else {

                // Show only first 5
//                ForEach(
//                    viewModel.cigarettes.prefix(5)
//                ) { cigarette in
//
//                    timelineRow(
//                        cigarette: cigarette
//                    )
//
//                    Divider()
//                        .overlay(
//                            AppColors.tertiaryColor
//                        )
//                }
                ForEach(
                    showAllCigarettes
                        ? viewModel.cigarettes
                        : Array(viewModel.cigarettes.prefix(5))
                ) { cigarette in

                    timelineRow(
                        cigarette: cigarette
                    )

                    Divider()
                        .overlay(
                            AppColors.tertiaryColor
                        )
                }

                // Show More
//                if viewModel.cigarettes.count > 5 {
//
//                    Button {
//                        // Handle show more
//                    } label: {
//                        HStack {
//                            Spacer()
//
//                            Text(
//                                "Show More"
//                            )
//                            .font(
//                                .system(
//                                    size: 15,
//                                    weight: .semibold
//                                )
//                            )
//                            .foregroundColor(
//                                AppColors.primaryColor
//                            )
//
//                            Image(
//                                systemName: "chevron.down"
//                            )
//                            .font(
//                                .system(
//                                    size: 12,
//                                    weight: .semibold
//                                )
//                            )
//                            .foregroundColor(
//                                AppColors.tertiaryColor
//                            )
//
//                            Spacer()
//                        }
//                        .padding(.vertical, 14)
//                    }
//                    .buttonStyle(.plain)
//                }
                if viewModel.cigarettes.count > 5 {

                    Button {
                        withAnimation(.easeInOut(duration: 0.25)) {
                            showAllCigarettes.toggle()
                        }
                    } label: {

                        HStack {
                            Spacer()

                            Text(
                                showAllCigarettes
                                    ? "Show Less"
                                    : "Show More"
                            )
                            .font(
                                .system(
                                    size: 15,
                                    weight: .semibold
                                )
                            )
                            .foregroundColor(
                                AppColors.primaryColor
                            )

                            Image(
                                systemName: showAllCigarettes
                                    ? "chevron.up"
                                    : "chevron.down"
                            )
                            .font(
                                .system(
                                    size: 12,
                                    weight: .semibold
                                )
                            )
                            .foregroundColor(
                                AppColors.tertiaryColor
                            )

                            Spacer()
                        }
                        .padding(.vertical, 14)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}
