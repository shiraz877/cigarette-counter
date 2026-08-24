////
////  UnderlineTextField.swift
////  CigaretteCouter
////
////  Created by Shiraz on 21/08/26.
////
//
//import SwiftUI
//
//struct UnderlineTextField: View {
//
//    let title: String
//    let placeholder: String
//
//    @Binding var text: String
//
//    var keyboardType: UIKeyboardType = .default
//
//    var body: some View {
//        VStack(alignment: .leading, spacing: 8) {
//
//            Text(title)
//                .font(
//                    .system(
//                        size: 12,
//                        weight: .semibold
//                    )
//                )
//                .tracking(1.2)
//                .foregroundStyle(
//                    AppColors.neutralColor
//                )
//
//            TextField(
//                placeholder,
//                text: $text
//            )
//            .font(.system(size: 16))
//            .foregroundStyle(.white)
//            .keyboardType(keyboardType)
//            .textInputAutocapitalization(
//                keyboardType == .emailAddress
//                ? .never
//                : .words
//            )
//            .autocorrectionDisabled()
//            .padding(.vertical, 8)
//            .overlay(alignment: .bottom) {
//                Rectangle()
//                    .fill(
//                        AppColors.neutralColor
//                            .opacity(0.5)
//                    )
//                    .frame(height: 1)
//            }
//        }
//    }
//}
import SwiftUI

struct UnderlineTextField: View {

    let title: String
    let placeholder: String

    @Binding var text: String

    var keyboardType: UIKeyboardType = .default

    var body: some View {

        VStack(alignment: .leading, spacing: 7) {

            Text(title)
                .font(
                    .system(
                        size: 11,
                        weight: .semibold
                    )
                )
                .tracking(1.1)
                .foregroundStyle(
                    AppColors.neutralColor
                )

            TextField(
                placeholder,
                text: $text
            )
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .keyboardType(keyboardType)
            .textInputAutocapitalization(
                keyboardType == .emailAddress
                ? .never
                : .words
            )
            .autocorrectionDisabled()
            .padding(.vertical, 7)

            Rectangle()
                .fill(
                    AppColors.neutralColor
                        .opacity(0.45)
                )
                .frame(height: 1)
        }
    }
}
