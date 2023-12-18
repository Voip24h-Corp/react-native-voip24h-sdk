//
//  RegisterSipState.swift
//  Voip24hSdk
//
//  Created by Phát Nguyễn on 02/11/2022.
//  Copyright © 2022 Facebook. All rights reserved.
//

import Foundation

public enum RegisterSipState : String, CaseIterable {
    /// Initial state for registrations.
    case None = "None"
    /// Registration is in progress.
    case Progress = "Progress"
    /// Registration is successful.
    case Ok = "Ok"
    /// Unregistration succeeded.
    case Cleared = "Cleared"
    /// Registration failed.
    case Failed = "Failed"
}
