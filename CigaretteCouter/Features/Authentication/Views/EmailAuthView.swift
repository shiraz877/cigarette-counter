
import SwiftUI

struct EmailAuthView: View {

    enum Mode: Hashable {
        case signUp
        case signIn
    }

    @Environment(\.dismiss)
    private var dismiss

    @Environment(AppViewModel.self)
    private var appViewModel
    @State private var viewModel = EmailAuthViewModel()
    @State private var mode: Mode

    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""

    @State private var showForgotPassword = false


    init(mode: Mode) {
        _mode = State(initialValue: mode)
    }

    private var isSignUp: Bool {
        mode == .signUp
    }

    var body: some View {

        ScrollView(showsIndicators: false) {

            VStack(alignment: .leading, spacing: 0) {

                // MARK: - Brand

                Text("PUFF COUNTER")
                    .font(
                        .system(
                            size: 26,
                            weight: .black
                        )
                    )
                    .tracking(-0.8)
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 44)

                // MARK: - Header

                Text(
                    isSignUp
                    ? "Create your account."
                    : "Welcome back."
                )
                .font(
                    .system(
                        size: 28,
                        weight: .semibold
                    )
                )
                .tracking(-0.5)
                .foregroundStyle(AppColors.primaryColor)

                Text(
                    isSignUp
                    ? "Save your cigarette history and sync it across devices."
                    : "Sign in to continue tracking your progress."
                )
                .font(.system(size: 14))
                .foregroundStyle(AppColors.tertiaryColor)
                .lineSpacing(2)
                .padding(.top, 8)
                .padding(.bottom, 36)

                // MARK: - Form

                VStack(spacing: 24) {

                    if isSignUp {

                        UnderlineTextField(
                            title: "FULL NAME",
                            placeholder: "Enter your full name",
                            text: $fullName
                        )

                        UnderlineTextField(
                            title: "EMAIL",
                            placeholder: "Enter your email",
                            text: $email,
                            keyboardType: .emailAddress
                        )

                    } else {

                        UnderlineTextField(
                            title: "EMAIL",
                            placeholder: "Enter your email",
                            text: $email,
                            keyboardType: .emailAddress
                        )
                    }

                    UnderlineSecureField(
                        title: "PASSWORD",
                        placeholder: "Enter your password",
                        text: $password
                    )

                    if isSignUp {

                        UnderlineSecureField(
                            title: "CONFIRM PASSWORD",
                            placeholder: "Re-enter your password",
                            text: $confirmPassword
                        )
                    }
                }

                // MARK: - Error

                if let errorMessage = viewModel.errorMessage {

                    Text(errorMessage)
                        .font(.system(size: 13))
                        .foregroundStyle(.red)
                        .padding(.top, 12)
                }

                // MARK: - Forgot Password

                if !isSignUp {

                    HStack {

                        Spacer()

                        Button {
                            showForgotPassword = true
                        } label: {

                            Text("FORGOT PASSWORD?")
                                .font(
                                    .system(
                                        size: 11,
                                        weight: .semibold
                                    )
                                )
                                .tracking(1.1)
                                .foregroundStyle(
                                    AppColors.primaryColor
                                )
                        }
                        .buttonStyle(.plain)
                    }
                    .padding(.top, 14)
                }

                // MARK: - Primary Button

                Button {
                    submit()
                } label: {

                    HStack(spacing: 8) {

                        if viewModel.isLoading {

                            ProgressView()
                                .tint(.black)

                        } else {

                            Text(
                                isSignUp
                                ? "CREATE ACCOUNT"
                                : "SIGN IN"
                            )

                            Image(systemName: "arrow.right")
                                .font(
                                    .system(
                                        size: 14,
                                        weight: .bold
                                    )
                                )
                        }
                    }
                    .font(
                        .system(
                            size: 16,
                            weight: .bold
                        )
                    )
                    .foregroundStyle(AppColors.neutralColor)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(AppColors.primaryColor)
                    .clipShape(Capsule())
                    .disabled(viewModel.isLoading)
                    .opacity(viewModel.isLoading ? 0.6 : 1)
                }
                .buttonStyle(.plain)
                .padding(.top, isSignUp ? 32 : 28)

                // MARK: - Switch Mode

                HStack(spacing: 5) {

                    Text(
                        isSignUp
                        ? "Already have an account?"
                        : "Don't have an account?"
                    )

                    Button {

                        withAnimation(.easeInOut(duration: 0.2)) {

                            mode = isSignUp
                                ? .signIn
                                : .signUp


                            viewModel.clearError()
                            password = ""
                            confirmPassword = ""
                        }

                    } label: {

                        Text(
                            isSignUp
                            ? "Sign In"
                            : "Sign Up"
                        )
                        .foregroundStyle(.white)
                        .underline()
                    }
                    .buttonStyle(.plain)
                }
                .font(.system(size: 14))
                .frame(maxWidth: .infinity)
                .padding(.top, 22)

                // MARK: - Privacy

                Text(
                    isSignUp
                    ? "By creating an account, you agree to our Privacy Policy. Your data belongs to you."
                    : "Your account data is securely synced across your devices."
                )
                .font(.system(size: 11))
                .foregroundStyle(
                    AppColors.neutralColor.opacity(0.7)
                )
                .multilineTextAlignment(.center)
                .lineSpacing(2)
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
                .padding(.top, 28)
            }
            .padding(.horizontal, 24)
            .padding(.top, 28)
            .padding(.bottom, 40)
        }
        .scrollDismissesKeyboard(.interactively)
        .mainBackgroundColor()
        .preferredColorScheme(.dark)
        .alert(
            "Forgot Password",
            isPresented: $showForgotPassword
        ) {

            TextField(
                "Email",
                text: $email
            )
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()

            Button("Send Reset Link") {
                sendPasswordReset()
            }

            Button(
                "Cancel",
                role: .cancel
            ) {}

        } message: {

            Text(
                "Enter your email address and we'll send you a password reset link."
            )
        }
    }

    // MARK: - Submit


    private func submit() {

        viewModel.clearError()

        let cleanEmail = email
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .lowercased()

        let cleanName = fullName
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )

        guard !cleanEmail.isEmpty else {

            viewModel.errorMessage =
                "Please enter your email."

            return
        }

        guard !password.isEmpty else {

            viewModel.errorMessage =
                "Please enter your password."

            return
        }

        if isSignUp {

            guard !cleanName.isEmpty else {

                viewModel.errorMessage =
                    "Please enter your full name."

                return
            }

            guard password.count >= 6 else {

                viewModel.errorMessage =
                    "Password must contain at least 6 characters."

                return
            }

            guard password == confirmPassword else {

                viewModel.errorMessage =
                    "Passwords do not match."

                return
            }
        }

        Task {

            let user: UserModel?

            if isSignUp {

                user = await viewModel.signUp(
                    fullName: cleanName,
                    email: cleanEmail,
                    password: password
                )

            } else {

                user = await viewModel.signIn(
                    email: cleanEmail,
                    password: password
                )
            }

            guard let user else {
                return
            }

            appViewModel.setAuthenticatedUser(user)

            dismiss()
        }
    }

    // MARK: - Forgot Password
//
//    private func sendPasswordReset() {
//
//        print(
//            "Password reset requested for:",
//            email
//        )
//    }
    
    private func sendPasswordReset() {

        let cleanEmail = email
            .trimmingCharacters(
                in: .whitespacesAndNewlines
            )
            .lowercased()

        guard !cleanEmail.isEmpty else {

            viewModel.errorMessage =
                "Please enter your email."

            return
        }

        Task {

            let success = await viewModel.sendPasswordReset(
                email: cleanEmail
            )

            if success {
                showForgotPassword = false
            }
        }
    }
}
