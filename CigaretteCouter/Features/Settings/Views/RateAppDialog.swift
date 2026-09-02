
import SwiftUI

struct RateAppDialog: View {

    @Binding var isPresented: Bool

    @State private var rating = 0
    @State private var feedback = ""

    var body: some View {

        ZStack {

            // MARK: - Background Dimming

            Color.black
                .opacity(0.65)
                .ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }

            // MARK: - Dialog

            VStack(spacing: 24) {

                // MARK: Header

                VStack(spacing: 8) {

                    Text("Rate Us")
                        .font(
                            .system(
                                size: 24,
                                weight: .bold
                            )
                        )
                        .foregroundStyle(.white)

                    Text("Enjoying Cigarette Counter?")
                        .font(.subheadline)
                        .foregroundStyle(
                            AppColors.primaryColor
                        )
                }

                // MARK: Rating

                HStack(spacing: 12) {

                    ForEach(1...5, id: \.self) { star in

                        Button {

                            rating = star

                        } label: {

                            Image(
                                systemName:
                                    star <= rating
                                    ? "star.fill"
                                    : "star"
                            )
                            .font(
                                .system(
                                    size: 30,
                                    weight: .medium
                                )
                            )
                            .foregroundStyle(
                                star <= rating
                                ? .yellow
                                : AppColors.tertiaryColor
                            )
                        }
                        .buttonStyle(.plain)
                    }
                }

                // MARK: Feedback

                TextField(
                    "Tell us what you think (optional)",
                    text: $feedback,
                    prompt: Text( "Tell us what you think (optional)")
                        .foregroundStyle(AppColors.tertiaryColor),
                    axis: .vertical
                )
                .lineLimit(4...6)
                .padding(14)
                .background(
                    AppColors.neutralColor
                )
                .foregroundStyle(.white)
                .tint(.white)

                // MARK: Buttons

                HStack(spacing: 12) {

                    Button {

                        isPresented = false

                    } label: {

                        Text("Cancel")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                AppColors.secondaryColor
                            )
                            .foregroundStyle(.white)
                    }
                    .buttonStyle(.plain)

                    Button {

                        submitRating()

                    } label: {

                        Text("Submit")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 13)
                            .background(
                                rating > 0
                                ? AppColors.primaryColor
                                : AppColors.tertiaryColor
                            )
                            .foregroundStyle(.black)
                    }
                    .buttonStyle(.plain)
                    .disabled(rating == 0)
                }
            }
            .padding(24)
            .frame(maxWidth: 420)
            .background(
                AppColors.secondaryColor
            )
//            .clipShape(
//                RoundedRectangle(
//                    cornerRadius: 24,
//                    style: .continuous
//                )
//            )
            .padding(.horizontal, 24)
        }
        .transition(
            .opacity.combined(
                with: .scale(scale: 0.95)
            )
        )
        .animation(
            .easeInOut(duration: 0.2),
            value: isPresented
        )
    }

    private func submitRating() {

        print("Rating: \(rating)")
        print("Feedback: \(feedback)")

        isPresented = false
    }
}
