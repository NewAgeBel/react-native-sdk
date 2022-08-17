//
//  Response.swift
//  OnfidoSdk
//
//  Created by Santana, Luis on 3/5/20.
//  Copyright © 2020 Onfido. All rights reserved.
//

import Foundation
import Onfido

func createResponse(_ results: [OnfidoResult], faceVariant: String?) -> [String: [String: Any]] {
    var RNResponse = [String: [String: Any]]()
    
    let document: OnfidoResult? = results.filter({ result in
        if case OnfidoResult.document = result { return true }
        return false
    }).first
    
    let face: OnfidoResult? = results.filter({ result in
        if case OnfidoResult.face = result { return true }
        return false
    }).first
    
    let nfcMediaId: OnfidoResult? = results.filter({ result in
        if case OnfidoResult.nfcMediaId = result { return true }
        return false
    }).first

    RNResponse["nfcMediaId"] = nfcMediaId

    if let documentUnwrapped = document, case OnfidoResult.document(let documentResponse) = documentUnwrapped {
        RNResponse["document"] = ["front": ["id": documentResponse.front.id]]
        if (documentResponse.back?.id != documentResponse.front.id) {
            RNResponse["document"]?["back"] = ["id": documentResponse.back?.id]
        }
    }
    
    if let faceUnwrapped = face, case OnfidoResult.face(let faceResponse) = faceUnwrapped {
        var faceResponse = ["id": faceResponse.id]
        
        if let faceVariant = faceVariant {
            faceResponse["variant"] = faceVariant
        }
        
        RNResponse["face"] = faceResponse
    }
    
    return RNResponse
}
