//
//  UserAnnotation.swift
//  JalanPlus
//
//  Created by Tyler Kiong on 20/3/25.
//


import MapKit

class UserAnnotation: NSObject, MKAnnotation {
    let id: String
    let title: String?
    let coordinate: CLLocationCoordinate2D
    let userPoints: Int  // User's points to display
    
    init(id: String, title: String, coordinate: CLLocationCoordinate2D, userPoints: Int) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
        self.userPoints = userPoints
    }
}
