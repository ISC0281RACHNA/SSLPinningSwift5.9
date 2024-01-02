//
//  PublicSSLPinning.swift
//  DeSuperChat
//
//  Created by Rachna on 28/12/23.
//

import Foundation
import Security
import CommonCrypto

class URLSessionPinningDelegate: NSObject, URLSessionDelegate {
//    let pinnedCertificateHash = "KjLxfxajzmBH0fTH1/oujb6R5fqBiLxl0zrl2xyFT2E="
//    let pinnedPublicKeyHash = "4xVxzbEegwDBoyoGoJlKcwGM7hyquoFg4l+9um5oPOI="
    static let shared = URLSessionPinningDelegate()
    var session: URLSession!
    
    private override init() {
       
    }
    //"EV4EkZSvLYx4A5Fg6ALhlgzOcqkp7fWGQyIHtcf68hg="
    let localPublicKey = "47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=" //MARK: from terminal get public key with command for googlwe

    let rsa2048Asn1Header:[UInt8] = [
        0x30, 0x82, 0x01, 0x22, 0x30, 0x0d, 0x06, 0x09, 0x2a, 0x86, 0x48, 0x86,
        0xf7, 0x0d, 0x01, 0x01, 0x01, 0x05, 0x00, 0x03, 0x82, 0x01, 0x0f, 0x00
    ]
    
    private func sha256(data : Data) -> String {
        var keyWithHeader = Data(rsa2048Asn1Header)
        keyWithHeader.append(data)
        var hash = [UInt8](repeating: 0,  count: Int(CC_SHA256_DIGEST_LENGTH))
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
    
    func call() {
        if let url = NSURL(string: "https://www.google.com/") {
            let session = URLSession(
                configuration: URLSessionConfiguration.ephemeral,
                delegate: URLSessionPinningDelegate(),
                delegateQueue: nil)
            let task = session.dataTask(with: url as URL, completionHandler: { (data, response, error) -> Void in
                if error != nil {
                    print("error: \(error!.localizedDescription))")
                } else if data != nil {
                    if let str = NSString(data: data!, encoding: String.Encoding.utf8.rawValue) {
                        print("Received data:\n\(str)")
                    }
                    else {
                        print("Unable to convert data to text")
                    }
                }
            })
            
            task.resume()
        }
        else {
            print("Unable to create NSURL")
        }
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Swift.Void) {
      
        //1. MARK: Pinning Success
        if (challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust) {
            
            if let serverTrust = challenge.protectionSpace.serverTrust {
                
                var secresult = SecTrustResultType.invalid
                let isServerTrsusted = SecTrustEvaluateWithError(serverTrust, nil)
          
                //MARK: 3. Evaluate the certificate
             
           //     if(errSecSuccess == isServerTrsusted) {
                    if(isServerTrsusted) {
//                        print(SecTrustGetCertificateCount(serverTrust))
                        
                        if let serverCertificate = SecTrustCopyCertificateChain(serverTrust) {
                            // Public key pinning
                            let serverPublicKey = SecCertificateCopyKey(serverCertificate as! SecCertificate) //MARK: GET SERVER PUBLIC KEY from CERTIFICATE
                            let serverPublicKeyData:NSData = SecKeyCopyExternalRepresentation(serverPublicKey!, nil )!// MARK: KEy to DATA
                            
                            let keyHash = sha256(data: serverPublicKeyData as Data) // //MARK: GET HASH OF SERVER KEY
                            
                            if (keyHash == localPublicKey) {   //MARK: compare SERVER HASH with LOCAL HASH
                                // Success! This is our server
                                print("Received data:\n Success")
                                
                                completionHandler(.useCredential, URLCredential(trust:serverTrust))
                                return
                            }
                        }
                        
   ///                 }
                    
                }
            }
    }
        //1. MARK: Pinning Success end

        //2. MARK: Pinning failed
        print("Received data:\n key not found")

        completionHandler(.cancelAuthenticationChallenge, nil)
    }
}
