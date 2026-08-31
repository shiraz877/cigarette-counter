//import AuthenticationServices
//import CryptoKit
//import Foundation
//import UIKit
//import Security
import AuthenticationServices
import CryptoKit
import Foundation
import Security
import UIKit

struct AppleSignInResult: Sendable {

    let idToken: String
    let rawNonce: String
    let fullName: PersonNameComponents?
}
protocol AppleSignInServiceProtocol: Sendable {

    @MainActor
    func signIn() async throws -> AppleSignInResult
}

//@MainActor
final class AppleSignInService: NSObject,
    AppleSignInServiceProtocol {

    private var continuation:
        CheckedContinuation<
            ASAuthorizationAppleIDCredential,
            Error
        >?

    private var currentNonce: String?

    func signIn() async throws -> AppleSignInResult {

        let nonce = try randomNonceString()

        currentNonce = nonce

        let request =
            ASAuthorizationAppleIDProvider()
                .createRequest()

        request.requestedScopes = [
            .fullName,
            .email
        ]

        request.nonce = sha256(nonce)

        let credential =
            try await performAuthorization(request)

        guard let identityToken =
            credential.identityToken
        else {
            throw AppleSignInError.missingIdentityToken
        }

        guard let idToken =
            String(
                data: identityToken,
                encoding: .utf8
            )
        else {
            throw AppleSignInError.invalidIdentityToken
        }

        guard let rawNonce = currentNonce else {
            throw AppleSignInError.missingNonce
        }

        currentNonce = nil

        return AppleSignInResult(
            idToken: idToken,
            rawNonce: rawNonce,
            fullName: credential.fullName
        )
    }
}
@MainActor
private extension AppleSignInService {

    func performAuthorization(
        _ request: ASAuthorizationAppleIDRequest
    ) async throws
        -> ASAuthorizationAppleIDCredential {

        try await withCheckedThrowingContinuation {
            continuation in

            self.continuation = continuation

            let controller =
                ASAuthorizationController(
                    authorizationRequests: [request]
                )

            controller.delegate = self
            controller.presentationContextProvider = self

            controller.performRequests()
        }
    }
}
extension AppleSignInService:
    ASAuthorizationControllerDelegate {

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithAuthorization authorization: ASAuthorization
    ) {

        guard let credential =
            authorization.credential
                as? ASAuthorizationAppleIDCredential
        else {

            continuation?.resume(
                throwing: AppleSignInError.invalidCredential
            )

            continuation = nil

            return
        }

        continuation?.resume(
            returning: credential
        )

        continuation = nil
    }

    func authorizationController(
        controller: ASAuthorizationController,
        didCompleteWithError error: Error
    ) {

        continuation?.resume(
            throwing: error
        )

        continuation = nil
    }
}
extension AppleSignInService:
    ASAuthorizationControllerPresentationContextProviding {

    func presentationAnchor(
        for controller: ASAuthorizationController
    ) -> ASPresentationAnchor {

        guard let windowScene =
            UIApplication.shared.connectedScenes
                .compactMap({
                    $0 as? UIWindowScene
                })
                .first(where: {
                    $0.activationState == .foregroundActive
                })
        else {
            return ASPresentationAnchor()
        }

        return windowScene.windows.first {
            $0.isKeyWindow
        } ?? ASPresentationAnchor()
    }
}
private extension AppleSignInService {

    func randomNonceString(
        length: Int = 32
    ) throws -> String {

        let charset = Array(
            "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"
        )

        var result = ""
        var remainingLength = length

        while remainingLength > 0 {

            var randomBytes = [UInt8](
                repeating: 0,
                count: 16
            )

            let status = SecRandomCopyBytes(
                kSecRandomDefault,
                randomBytes.count,
                &randomBytes
            )

            guard status == errSecSuccess else {
                throw AppleSignInError.unableToGenerateNonce
            }

            for randomByte in randomBytes {

                if remainingLength == 0 {
                    break
                }

                if randomByte < charset.count {

                    result.append(
                        charset[Int(randomByte)]
                    )

                    remainingLength -= 1
                }
            }
        }

        return result
    }

    func sha256(
        _ input: String
    ) -> String {

        let inputData = Data(input.utf8)

        let hashedData =
            SHA256.hash(data: inputData)

        return hashedData
            .map {
                String(format: "%02x", $0)
            }
            .joined()
    }
}
enum AppleSignInError: LocalizedError {

    case invalidCredential
    case missingIdentityToken
    case invalidIdentityToken
    case missingNonce
    case unableToGenerateNonce

    var errorDescription: String? {

        switch self {

        case .invalidCredential:
            return "Unable to read Apple credentials."

        case .missingIdentityToken:
            return "Apple did not return an identity token."

        case .invalidIdentityToken:
            return "Unable to process the Apple identity token."

        case .missingNonce:
            return "Authentication request is invalid."

        case .unableToGenerateNonce:
            return "Unable to start Apple Sign-In."
        }
    }
}
