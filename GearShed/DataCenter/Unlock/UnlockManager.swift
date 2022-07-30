//
//  UnlockManager.swift
//  GearShed
//
//  Created by Luke Forrest Gannon
//  Copyright © 2022 All rights reserved.
//
import Foundation
import Combine
import StoreKit

class UnlockManager: NSObject, ObservableObject, SKPaymentTransactionObserver, SKProductsRequestDelegate {
    enum RequestState {
        case loading
        case loaded(SKProduct)
        case failed(Error?)
        case purchased
        case deferred
    }
    private enum StoreError: Error {
        case invalidIdentifiers, missingProduct
    }
    @Published var requestState = RequestState.loading
    private let persistentStore: PersistentStore
    private let request: SKProductsRequest!
    private var loadedProducts = [SKProduct]()
    var canMakePayments: Bool { SKPaymentQueue.canMakePayments() }
    
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?
    var totalRestoredPurchases = 0

    init(persistentStore: PersistentStore) {
        self.persistentStore = persistentStore
        // Put the IAP product IDs HERE
        let productIDs = Set(["app.gearshed.GearShed.Unlimited.01"])
        //let productIDs = Set(["app.gearshed.GearShed.GearShed_Unlimited_V1_IAP"])
        request = SKProductsRequest(productIdentifiers: productIDs)
        super.init()
        SKPaymentQueue.default().add(self)
        guard persistentStore.fullVersionUnlocked == false else { return }
        request.delegate = self
        request.start()
    }
    deinit {
        SKPaymentQueue.default().remove(self)
    }
    
    /// Function to fetch and validate IAP product IDs
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        DispatchQueue.main.async {
            self.loadedProducts = response.products
            guard let unlock = self.loadedProducts.first else {
                print("ALERT: Missing IAP Product")
                self.requestState = .failed(StoreError.missingProduct)
                return
            }
            if response.invalidProductIdentifiers.isEmpty == false {
                print("ALERT: Received invalid product identifiers: \(response.invalidProductIdentifiers)")
                self.requestState = .failed(StoreError.invalidIdentifiers)
                return
            }
            self.requestState = .loaded(unlock)
        }
    }
    
    // MARK: - SKPaymentTransactionObserver
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        DispatchQueue.main.async { [self] in
            for transaction in transactions {
                switch transaction.transactionState {
                case .purchased:
                    self.persistentStore.fullVersionUnlocked = true
                    self.requestState = .purchased
                    queue.finishTransaction(transaction)
                case .restored:
                    totalRestoredPurchases += 1
                    queue.finishTransaction(transaction)
                case .failed:
                    if let product = loadedProducts.first {
                        self.requestState = .loaded(product)
                    } else {
                        self.requestState = .failed(transaction.error)
                    }
                    queue.finishTransaction(transaction)
                case .deferred:
                    self.requestState = .deferred
                default:
                    break
                }
            }
        }
    }
    
    //    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    //        DispatchQueue.main.async { [self] in
    //            for transaction in transactions {
    //                switch transaction.transactionState {
    //                case .purchased, .restored:
    //                    self.persistentStore.fullVersionUnlocked = true
    //                    self.requestState = .purchased
    //                    queue.finishTransaction(transaction)
    //                case .failed:
    //                    if let product = loadedProducts.first {
    //                        self.requestState = .loaded(product)
    //                    } else {
    //                        self.requestState = .failed(transaction.error)
    //                    }
    //                    queue.finishTransaction(transaction)
    //                case .deferred:
    //                    self.requestState = .deferred
    //                default:
    //                    break
    //                }
    //            }
    //        }
    //    }
    
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases != 0 {
            onBuyProductHandler?(.success(true))
        } else {
            print("IAP: No purchases to restore!")
            onBuyProductHandler?(.success(false))
        }
    }
    
    func buy(product: SKProduct) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }
    
    func restore() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func restorePurchases(withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        onBuyProductHandler = handler
        totalRestoredPurchases = 0
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
}
