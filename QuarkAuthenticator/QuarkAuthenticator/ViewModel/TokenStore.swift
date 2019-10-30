//
//  TokenStore.swift
//  QuarkAuthenticator
//
//  Created by quark on 2019/7/12.
//  Copyright © 2019 lsw. All rights reserved.
//

import UIKit
import OneTimePassword
import RxCocoa
import RxSwift
import Base32

let keychain = Keychain.sharedInstance

var lastRefreshTime: Date?
var nextRefreshTime: Date?
var progress: Double?

var refreshTimer: DispatchSourceTimer?

class TokenStore: NSObject {
    var tokenList: Array<Token>? = Array()
//    var tokenList = BehaviorRelay<[Token]>(value: [])
    var persistentTokens: [PersistentToken] = Array.init()
    
    override init() {
        super.init()
        refreshTimer = DispatchSource.makeTimerSource(flags: [], queue: DispatchQueue.global())
        refreshTimer?.schedule(deadline: .now(), repeating: DispatchTimeInterval.seconds(1), leeway: DispatchTimeInterval.seconds(0))
        refreshTimer?.setEventHandler(handler: {
            self.postRefreshDateNotification()
        })
        refreshTimer?.resume()
    }

    func tokenVerify(urlString: String) -> Bool {
        guard let url = URL(string: urlString),
            let token = Token(url: url) else {
                return false
        }
//        tokenList.accept(tokenList.value + [token])
        tokenList?.append(token)
        let newPersisterntToken = try! keychain.add(token)
        persistentTokens.append(newPersisterntToken)
        
        saveTokenOrder()
        
        self.updateRefreshTime()
        return true
    }
    
    func tokenVerify(issure: String, account: String, secret: String) -> Bool{
        guard let secretData = MF_Base32Codec.data(fromBase32String: secret),
            !secretData.isEmpty else {
                print("The secret key is invalid")
                return false
        }
        let algorithm = Generator.Algorithm.sha1
        let factor = Generator.Factor.timer(period: 30)
        let digitCount = 6
        
        guard let generator = Generator(factor: factor,secret: secretData,algorithm: algorithm,digits: digitCount) else {
            print("Invalid Token")
            return false
        }
        
        let token = Token(name: account, issuer: issure, generator: generator)
        tokenList?.append(token)
        let newPersisterntToken = try! keychain.add(token)
        persistentTokens.append(newPersisterntToken)
        saveTokenOrder()
        self.updateRefreshTime()
        return true
    }

    func updateRefreshTime() {
        lastRefreshTime = persistentTokens.reduce(.distantPast) { (lastRefreshTime, persistentToken) in
            max(lastRefreshTime, persistentToken.lastRefreshTime(before: DisplayTime.init(date: Date.init())))
        }
        nextRefreshTime = persistentTokens.reduce(.distantFuture) { (nextRefreshTime, persistentToken) in
            min(nextRefreshTime, persistentToken.nextRefreshTime(after: DisplayTime.init(date: Date.init())))
        } as Date
        progress = Date().timeIntervalSince1970 - lastRefreshTime!.timeIntervalSince1970
//        progress = nextRefreshTime?.timeIntervalSinceNow
        
    }
    
    func postRefreshDateNotification() {
        if Date().descriptionTimeModel() == nextRefreshTime?.descriptionTimeModel() {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "HaveNewDateNeedToUpdate"), object: nil)
            updateRefreshTime()
        }
    }

    
    //save
    func saveTokenOrder() {
        let persistentIdentifiers = persistentTokens.map { $0.identifier }
        UserDefaults.standard.set(persistentIdentifiers, forKey: "OTPKeychainEntries")
    }
    
    //load
    func loadToken(callBack:@escaping (_ successful: Bool) -> Void) {
        do {
            let persistentTokenSet = try keychain.allPersistentTokens()
            let sortedIdentifiers = UserDefaults.standard.array(forKey: "OTPKeychainEntries") as? [Data] ?? []
            
            persistentTokens = persistentTokenSet.sorted(by: {
                let indexOfA = sortedIdentifiers.firstIndex(of: $0.identifier)
                let indexOfB = sortedIdentifiers.firstIndex(of: $1.identifier)
                
                switch (indexOfA, indexOfB) {
                case let (.some(iA), .some(iB)) where iA < iB:
                    return true
                default:
                    return false
                }
            })
            for persistentToken in persistentTokens {
                tokenList?.append(persistentToken.token)
            }
            self.updateRefreshTime()
            
            callBack(true)
            
        } catch {
            callBack(false)
        }
    }
    
    //delete
    func deleteToken(index: Int,callBack:@escaping (_ successful: Bool) -> Void) {
        do {
            let persistentoken = persistentTokens[index]
            try keychain.delete(persistentoken)
            persistentTokens.remove(at: index)
            tokenList?.remove(at: index)
            
            self.saveTokenOrder()
            callBack(true)
        } catch  {
            callBack(false)
        }
    }
    
    //move
    func moveToke(sourceIndex: Int,destination: Int,callBack:@escaping (_ successful: Bool) -> Void) {
        let persistentoken = persistentTokens[sourceIndex]
        persistentTokens.remove(at: sourceIndex)
        persistentTokens.insert(persistentoken, at: destination)
        saveTokenOrder()
        callBack(true)
    }
    
}

extension PersistentToken {
    func lastRefreshTime(before displayTime: DisplayTime) -> Date {
        switch token.generator.factor {
        case .counter:
            return .distantPast
        case .timer(let period):
            let epoch = displayTime.timeIntervalSince1970
            return Date(timeIntervalSince1970: epoch - epoch.truncatingRemainder(dividingBy: period))
        }
    }
    
    func nextRefreshTime(after displayTime: DisplayTime) -> Date {
        switch token.generator.factor {
        case .counter:
            return .distantFuture
        case .timer(let period):
            let epoch = displayTime.timeIntervalSince1970
            return Date(timeIntervalSince1970: epoch + (period - epoch.truncatingRemainder(dividingBy: period)))
        }
    }
    
    func remainderTime(after displayTime: DisplayTime) -> Double {
        switch token.generator.factor {
        case .counter:
            return 0
        case .timer(let period):
            let epoch = displayTime.timeIntervalSince1970
            let refreshDate = Date(timeIntervalSince1970: epoch + (period - epoch.truncatingRemainder(dividingBy: period)))
            let timeNow = Date.init().timeIntervalSince1970
            let refreshTime = refreshDate.timeIntervalSince1970
            return (refreshTime - timeNow)
        }
    }
}
