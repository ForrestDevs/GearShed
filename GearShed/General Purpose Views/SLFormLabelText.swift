//
//  MyFormLabelText.swift
//  GearShed
//
//  Created by Luke Forrest Gannon on 18/10/21
//  Copyright © 2021 All rights reserved.
//

import SwiftUI

// a simple view i use so that all labels on a form come out styled
// the same way.

struct SLFormLabelText: View {
	var labelText: String
	var body: some View {
		Text(labelText)
			.font(.headline)
	}
}

