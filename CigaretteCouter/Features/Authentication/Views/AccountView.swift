
import SwiftUI

struct AccountView: View {
    
    @Environment(\.dismiss)
    private var dismiss
    
    @Environment(AppViewModel.self)
    private var appViewModel
    
    @State private var emailAuthMode: EmailAuthView.Mode?
    @State private var viewModel =
    AccountViewModel()
    
    var body: some View {
        
        NavigationStack {
            
            Group {
                
                if appViewModel.isAuthenticated {
                    loggedInView
                } else {
                    guestView
                }
            }
            .mainBackgroundColor()
            
            .navigationDestination(
                item: $emailAuthMode
            ) { mode in
                
                EmailAuthView(
                    mode: mode
                )
            }
        }
        .preferredColorScheme(.dark)
    }
    
    // MARK: - Guest View
    
    private var guestView: some View {
        
        ScrollView(
            showsIndicators: false
        ) {
            
            VStack(spacing: 28) {
                
                // MARK: Header
                
                VStack(spacing: 12) {
                    
                    accountIcon
                    
                    //                    Text("Create your account")
                    Text("account.create_title")
                        .font(
                            .system(
                                size: 28,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)
                    
                    Text(
                        "Sync your cigarette history and settings across your devices."
                    )
                    .font(.system(size: 15))
                    .foregroundStyle(
                        AppColors.tertiaryColor
                    )
                    .multilineTextAlignment(.center)
                    .lineSpacing(3)
                }
                
                // MARK: Account Options
                
                VStack(spacing: 12) {
                    
                    AccountButton(
                        title: "Continue with Apple",
                        style: .apple
                    ) {
                        signInWithApple()
                    }
                    
                    AccountButton(
                        title: "Continue with Google",
                        style: .google
                    ) {
                        signInWithGoogle()
                    }
                    
                    AccountButton(
                        title: "Continue with Email",
                        style: .email
                    ) {
                        
                        emailAuthMode = .signUp
                    }
                }
                
                // MARK: Privacy
                
                Text(
                    "By continuing, you agree to our Terms of Service and Privacy Policy."
                )
                .font(.system(size: 12))
                .foregroundStyle(
                    AppColors.tertiaryColor
                )
                .multilineTextAlignment(.center)
                .lineSpacing(3)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Logged In View
    
    private var loggedInView: some View {
        
        ScrollView(
            showsIndicators: false
        ) {
            
            VStack(spacing: 24) {
                
                // MARK: Profile Header
                
                VStack(spacing: 12) {
                    
                    accountIcon
                    
                    Text(
                        appViewModel.currentUserName ?? "User"
                    )
                    .font(
                        .system(
                            size: 26,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(.white)
                    
                    if let email =
                        appViewModel.currentUserEmail {
                        
                        Text(email)
                            .font(.system(size: 14))
                            .foregroundStyle(
                                AppColors.neutralColor
                            )
                    }
                }
                
                // MARK: Sync Status
                
                VStack(spacing: 0) {
                    
                    HStack(spacing: 14) {
                        
                        Image(
                            systemName: "icloud.fill"
                        )
                        .font(.system(size: 20))
                        .foregroundStyle(
                            AppColors.primaryColor
                        )
                        
                        VStack(
                            alignment: .leading,
                            spacing: 4
                        ) {
                            
                            Text("Data synced")
                                .font(
                                    .system(
                                        size: 16,
                                        weight: .semibold
                                    )
                                )
                                .foregroundStyle(.white)
                            
                            Text(
                                "Your cigarette history is synced."
                            )
                            .font(.system(size: 13))
                            .foregroundStyle(
                                AppColors.neutralColor
                            )
                        }
                        
                        Spacer()
                        
                        Image(
                            systemName:
                                "checkmark.circle.fill"
                        )
                        .foregroundStyle(
                            AppColors.primaryColor
                        )
                    }
                    .padding(16)
                }
                .background(
                    Color.white.opacity(0.05)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
                
                // MARK: Account Actions
                
                VStack(spacing: 0) {
                    
                    //                    accountRow(
                    //                        icon: "person",
                    //                        title: "Account Settings"
                    //                    ) {
                    //
                    //                        print("Account Settings")
                    //
                    //
                    //                    }
                    accountNavigationRow( icon: "person", title: "Account Settings" ) { SettingsView() }
                    
                    Divider()
                        .overlay(
                            Color.white.opacity(0.08)
                        )
                    
                    accountRow(
                        icon: "arrow.clockwise",
                        title: "Sync Data"
                    ) {
                        
                        print("Sync Data")
                    }
                    
                    Divider()
                        .overlay(
                            Color.white.opacity(0.08)
                        )
                    
                    accountRow(
                        icon:
                            "rectangle.portrait.and.arrow.right",
                        title: "Log Out",
                        isDestructive: true
                    ) {
                        
                        logOut()
                    }
                }
                .background(
                    Color.white.opacity(0.05)
                )
                .clipShape(
                    RoundedRectangle(
                        cornerRadius: 16
                    )
                )
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
            .padding(.bottom, 40)
        }
    }
    
    // MARK: - Account Icon
    
    private var accountIcon: some View {
        
        ZStack {
            
            Circle()
                .fill(
                    AppColors.primaryColor
                        .opacity(0.12)
                )
                .frame(
                    width: 72,
                    height: 72
                )
            
            Image(
                systemName: "person.fill"
            )
            .font(
                .system(
                    size: 28,
                    weight: .medium
                )
            )
            .foregroundStyle(
                AppColors.primaryColor
            )
        }
    }
    
    // MARK: - Account Row
    
    private func accountRow(
        icon: String,
        title: String,
        isDestructive: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        
        Button(
            action: action
        ) {
            
            HStack(spacing: 14) {
                
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(
                        isDestructive
                        ? .red
                        : AppColors.primaryColor
                    )
                    .frame(width: 24)
                
                Text(title)
                    .font(
                        .system(
                            size: 15,
                            weight: .medium
                        )
                    )
                    .foregroundStyle(
                        isDestructive
                        ? .red
                        : .white
                    )
                
                Spacer()
                
                if !isDestructive {
                    
                    Image(
                        systemName: "chevron.right"
                    )
                    .font(.system(size: 12))
                    .foregroundStyle(
                        AppColors.neutralColor
                    )
                }
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
    
    // MARK: - Close Button
    
    private var closeButton: some View {
        
        Button {
            
            dismiss()
            
        } label: {
            
            Image(
                systemName: "xmark"
            )
            .font(
                .system(
                    size: 14,
                    weight: .semibold
                )
            )
            .foregroundStyle(
                AppColors.neutralColor
            )
            .frame(
                width: 32,
                height: 32
            )
            .background(
                Color.white.opacity(0.06)
            )
            .clipShape(Circle())
        }
    }
    
    // MARK: - Actions
    
//    private func signInWithApple() {
//        
//        print("Apple login")
//    }
    private func signInWithApple() {
        Task {
            guard let user = await viewModel.signInWithApple()
            else {
                return
            }

            appViewModel.setAuthenticatedUser(user)
        }
    }
    
    //    private func signInWithGoogle() {
    //
    ////        print("Google login")
    //        Task {
    //             await viewModel.signInWithGoogle()
    //         }
    //    }
    private func signInWithGoogle() {
        
        Task {
            
            guard let user =
                    await viewModel.signInWithGoogle()
            else {
                return
            }
            
            appViewModel.setAuthenticatedUser(user)
        }
    }
    
    private func logOut() {
        Task {
            await appViewModel.signOut()
        }
    }
    private func accountNavigationRow<Destination: View>(
        icon: String,
        title: String,
        @ViewBuilder destination: () -> Destination
    ) -> some View {
        NavigationLink {
            destination()
        } label: {
            HStack(spacing: 14){
                Image(systemName: icon)
                    .font(.system(size: 18))
                    .foregroundStyle(AppColors.primaryColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(
                        .system( size: 15,
                                 weight: .medium
                               )
                    )
                    .foregroundStyle(.white)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.system(size: 12))
                    .foregroundStyle(AppColors.neutralColor)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
    
}
