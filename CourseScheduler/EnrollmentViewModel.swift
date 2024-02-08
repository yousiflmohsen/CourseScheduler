import SwiftUI

class EnrollmentViewModel: ObservableObject {
    @Published var selectedCourses: [Course] = []
    @Published var selectedUnits: Int = 0

    let availableCourses: [Course] = [
        Course(name: "English 90", units: 3),
        Course(name: "CEE 63", units: 3),
        Course(name: "CS106A", units: 5),
        Course(name: "CS106B", units: 5),
        Course(name: "CS107", units: 5),
        Course(name: "CS161", units: 5),
        Course(name: "ENGR108", units: 4),
        Course(name: "Math 51", units: 4),
        Course(name: "CME 100", units: 0),
        Course(name: "CME 101", units: 0)
    ]

    func enrollSelectedCourses() {
        // Your enrollment logic goes here
    }

    func canCheckmarkCourse(at index: Int) -> Bool {
        let course = availableCourses[index]
        return !selectedCourses.contains(course) && selectedUnits + course.units <= 20
    }
}
