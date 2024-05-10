//
//  Practice+CoreDataProperties.swift
//  intervieasy
//
//  Created by jevania on 08/05/24.
//
//

import Foundation
import CoreData


extension Practice {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Practice> {
        return NSFetchRequest<Practice>(entityName: "Practice")
    }

    @NSManaged public var articulation: Double
    @NSManaged public var wpm: Double
    @NSManaged public var videoUrl: String?
    @NSManaged public var title: String?
    @NSManaged public var smoothRate: Double
    @NSManaged public var score: Double
    @NSManaged public var fwHm: Int32
    @NSManaged public var fwHa: Int32
    @NSManaged public var fwEh: Int32
    @NSManaged public var timeStamp: String?

}

extension Practice : Identifiable {

}
