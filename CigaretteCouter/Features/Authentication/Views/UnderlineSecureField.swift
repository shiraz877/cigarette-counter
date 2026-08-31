//
//  UnderlineSecureField.swift
//  CigaretteCouter
//
//  Created by Shiraz on 21/08/26.
//

import SwiftUI

struct UnderlineSecureField: View {

    let title: String
    let placeholder: String

    @Binding var text: String

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
                    AppColors.primaryColor
                )

            SecureField(
                placeholder,
                text: $text
            )
            .font(.system(size: 16))
            .foregroundStyle(.white)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding(.vertical, 7)

            Rectangle()
                .fill(
                    AppColors.tertiaryColor
                        .opacity(0.45)
                )
                .frame(height: 1)
        }
    }
}
