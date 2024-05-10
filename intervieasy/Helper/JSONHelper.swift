//
//  JSONHelper.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//

import Foundation

class JSONHelper {
    static func loadInterviewQuestions(from filename: String) -> [String]? {
        guard let path = Bundle.main.path(forResource: filename, ofType: "json"),
              let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
              let jsonResult = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
              let questions = (jsonResult as? [String: Any])?["interview_questions"] as? [String] else {
            return nil
        }
        
        return questions
    }
    
    static func getRandomInterviewQuestion() -> String? {
        guard let questions = loadInterviewQuestions(from: "interview_questions") else {
            return nil
        }
        return questions.randomElement()
    }
}
