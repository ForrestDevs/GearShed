//
//  ConfirmationAlertProtocol.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2022 All rights reserved.
//

import SwiftUI

protocol ConfirmationAlertProtocol: Identifiable {
	// must be Identifiable to work with .alert(item: ...)
	var id: UUID { get }
	// strings for title and message
	var title: String { get }
	var message: String { get }
	// data to support agreement to do something destructive
	var destructiveTitle: String { get }
	func destructiveAction()
	// data to support not agreeing to do the destructive thing
	var nonDestructiveTitle: String { get }
	func nonDestructiveAction()
	// completion handlers for after we do what we do. generally, these
	// will execute view-specific code (dismiss() or an animation?) and are
	// determined at the call site when creating the alert, and are
	// not code performed on model data such as deleting a Core Data object
	var destructiveCompletion: (() -> Void)? { get set }
	var nonDestructiveCompletion: (() -> Void)? { get set }
	// uses all the data above to produce an Alert in an .alert() modifier
	func alert() -> Alert
}

extension ConfirmationAlertProtocol {
	// default titles for buttons -- you may wish to override
	var destructiveTitle: String { "Yes" }
	var nonDestructiveTitle: String { "No" }
	// default actions -- normally, you should provide the destructive
	// action; it's unusual, but you may want to do something other than
	// nothing when the user declines to do the destructive action
	func nonDestructiveAction() { }
	// these are implementation hooks to do actions and then allow a separate
	// completion handler
	fileprivate func doDestructiveAction() {
		destructiveAction()
		destructiveCompletion?()
	}
	fileprivate func doNonDestructiveAction() {
		nonDestructiveAction()
		nonDestructiveCompletion?()
	}
	// produces the actual alert
	func alert() -> Alert {
		Alert(
            title: Text(title),
            message: Text(message),
            primaryButton: .cancel(Text(nonDestructiveTitle), action: doNonDestructiveAction),
            secondaryButton: .destructive(Text(destructiveTitle), action: doDestructiveAction)
        )
	}
}
