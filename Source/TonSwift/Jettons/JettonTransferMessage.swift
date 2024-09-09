//
//  JettonTransferMessage.swift
//  
//
//  Created by Grigory on 11.7.23..
//

import Foundation
import BigInt

public struct JettonTransferMessage {
    public static func internalMessage(jettonAddress: Address,
                                       amount: BigInt,
                                       bounce: Bool,
                                       to: Address,
                                       from: Address,
                                       comment: String? = nil) throws -> MessageRelaxed {
        let forwardAmount = BigUInt(stringLiteral: "1")
        let jettonTransferAmount = BigUInt(stringLiteral: "640000000")
        let queryId = UInt64(Date().timeIntervalSince1970)
      
        var commentCell: Cell?
        if let comment = comment {
            commentCell = try Builder().store(int: 0, bits: 32).writeSnakeData(Data(comment.utf8)).endCell()
        }
        
        let jettonTransferData = JettonTransferData(queryId: queryId,
                                                    amount: amount.magnitude,
                                                    toAddress: to,
                                                    responseAddress: from,
                                                    forwardAmount: forwardAmount,
                                                    forwardPayload: commentCell)
        
        return MessageRelaxed.internal(
            to: jettonAddress,
            value: jettonTransferAmount,
            bounce: bounce,
            body: try Builder().store(jettonTransferData).endCell()
        )
    }
}
