//
//  ChatbotService.swift
//  DeSuperChat
//
//  Created by Rachna on 26/12/23.
//

import Foundation
import Alamofire


class PokemonService: NSObject {
    static let shared = PokemonService()
    var session: URLSession!
    
    private override init() {
    }
    
    func sendMessage(urlString: String? = "https://www.colourlovers.com/api/colors/new?format=json") async throws -> [ColorFul] {
        let (data,_) = try await session.data(from: URL(string: urlString!)!)
        let decoderresutData = try? JSONDecoder().decode(ColorResult.self, from: data)
        return decoderresutData?.results ?? []
    }

    func getMessage(urlString: String? = "https://dog.ceo/api/breeds/image/random") async throws -> Dog {
        let (data,_) = try await URLSession.init(configuration: .ephemeral, delegate: self, delegateQueue: nil).data(from: URL(string: urlString!)!)
        let decoderresutData = try JSONDecoder().decode(Dog.self, from: data)
        return decoderresutData
    }
}


extension PokemonService: URLSessionDelegate {
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        //MARK: 1. SSL server trust certificate
        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            print("certificate not found")
            return (.cancelAuthenticationChallenge, nil)
        }
        
        //MARK: 2. SSL server trust Policy Domain
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        
        //MARK: 3. Evaluate the certificate
        let isServerTrsusted = SecTrustEvaluateWithError(serverTrust, nil)
        
        //MARK: 4.Remote Certificate NSData
        let remoteCertificate: NSData = SecCertificateCopyData(certificate)
        
        //MARK: 5.Local PathCertificate
        let pathCertificate = Bundle.main.path(forResource: "dog.ceo", ofType: "cer")
        let localCertificateData: NSData = NSData.init(contentsOfFile: pathCertificate!)!
        
        //MARK: 7.Compare Local and Remote pathCertificate
        
        if (isServerTrsusted && remoteCertificate.isEqual(to: localCertificateData as Data))  {
            let credentials: URLCredential = URLCredential(trust: serverTrust)
            print("Pinning success")
            return (.useCredential, credentials)
        } else {
            print("Hacker try to get information")
            return (.cancelAuthenticationChallenge, nil)
        }
    }
    
  //MARK: Public Key Pinning
    func urlSession2(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge) async -> (URLSession.AuthChallengeDisposition, URLCredential?) {
        
        //MARK: 1. SSL server trust certificate
        guard let serverTrust = challenge.protectionSpace.serverTrust, let certificate = SecTrustGetCertificateAtIndex(serverTrust, 0) else {
            print("certificate not found")
            return (.cancelAuthenticationChallenge, nil)
        }
        
        //MARK: 2. SSL server trust Policy Domain
        let policy = NSMutableArray()
        policy.add(SecPolicyCreateSSL(true, challenge.protectionSpace.host as CFString))
        
        //MARK: 3. Evaluate the certificate
        let isServerTrsusted = SecTrustEvaluateWithError(serverTrust, nil)
        
        //MARK: 4.Remote Certificate NSData
        let remoteCertificate: NSData = SecCertificateCopyData(certificate)
        
        //MARK: 5.Local PathCertificate
        let pathCertificate = Bundle.main.path(forResource: "dog.ceo", ofType: "cer")
        let localCertificateData: NSData = NSData.init(contentsOfFile: pathCertificate!)!
        
        //MARK: 7.Compare Local and Remote pathCertificate
        
        if (isServerTrsusted && remoteCertificate.isEqual(to: localCertificateData as Data))  {
            let credentials: URLCredential = URLCredential(trust: serverTrust)
            print("Pinning success")
            return (.useCredential, credentials)
        } else {
            print("Hacker try to get information")
            return (.cancelAuthenticationChallenge, nil)
        }
    }
}
