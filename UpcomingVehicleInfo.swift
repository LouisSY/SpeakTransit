//
//  UpcomingVehicleInfo.swift
//  SpeakTransit
//
//  Created by Shuai Yuan on 09/03/2025.
//

import Foundation

struct UpcomingVehicleInfo: Identifiable {
    let id = UUID()
    var destination: String
    var waitingTime: String
}

func parseUpcomingVehicleInfo(from textArray: [String]) -> [UpcomingVehicleInfo] {
    var upcomingVehicleInfos: [UpcomingVehicleInfo] = []
    
    for text in textArray {
        if text.lowercased().contains("stratford") {
            // Look for destination information
            upcomingVehicleInfos.append(UpcomingVehicleInfo(destination: text, waitingTime: ""))
        } else if text.lowercased().contains("min") {
            // Look for waiting time information
            if let index = upcomingVehicleInfos.firstIndex(where: { $0.waitingTime.isEmpty }) {
                upcomingVehicleInfos[index].waitingTime = text
            }
        }
    }
    
    return upcomingVehicleInfos
}
