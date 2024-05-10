//
//  PracticeService.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import CoreData
import UIKit

class PracticeService {
    func savePractice(title: String,
                      wpm: Double,
                      articulation: Double,
                      smoothRate: Double,
                      videoUrl: String,
                      fwEh: Int32,
                      fwHa: Int32,
                      fwHm: Int32,
                      timeStamp: String,
                      score: Double){
        
        let practice = Practice(context: ContextService.context)
        
        practice.title = title
        practice.wpm = wpm
        practice.articulation = articulation
        practice.smoothRate = smoothRate
        practice.videoUrl = videoUrl
        practice.fwEh = fwEh
        practice.fwHa = fwHa
        practice.fwHm = fwHm
        practice.timeStamp = timeStamp
        practice.score = score
        
        ContextService.saveChanges()
    }
    
    func deletePractice(practice : Practice){
        ContextService.deletePractice(practice: practice)
    }

    func getAllPractice() -> [Practice] {
        let request : NSFetchRequest<Practice> = Practice.fetchRequest()
        
        return ContextService.fetchPractice(request: request)
    }
}


