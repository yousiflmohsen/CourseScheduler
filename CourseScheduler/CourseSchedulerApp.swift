import SwiftUI


/* Define the course struct */
struct Course: Identifiable {
    var id = UUID()
    var name: String
    var units: Int
    var time: String
    var seats: Int
    var enrollmentLock: NSLock
}

/* Class responsible for all enrollment functionalities */
class EnrollmentViewModel: ObservableObject {
    
    @Published var selectedCourses: [Course] = []   // Tracks courses added to plan (before enrollment)
    @Published var selectedUnits: Int = 0           // Tracks number of units added (before enrollment)
   
    var hasOverlappingCourses: Bool {               // Boolean updated to check if any courses overlap
           return selectedCourses.contains { course in
               isOverlap(course: course)
           }
       }

    /* Create mock-up of available courses to enroll in */
    let availableCourses: [Course] = [
        Course(name: "English 90", units: 4, time: "MWF 10:00 AM - 11:00 AM", seats: 10, enrollmentLock: NSLock()),
        Course(name: "CEE 63", units: 3, time: "TTH 1:00 PM - 2:30 PM",seats: 10, enrollmentLock: NSLock()),
        Course(name: "ENGR 108", units: 5, time: "MWF 1:00 PM - 2:30 PM", seats: 10, enrollmentLock: NSLock()),
        Course(name: "CS106A", units: 5, time: "TTH 1:00 PM - 2:30 PM", seats: 10, enrollmentLock: NSLock()),
        Course(name: "CS106B", units: 5, time: "MWF 2:30 PM - 3:30 PM", seats: 10, enrollmentLock: NSLock()),
        Course(name: "CS107", units: 5, time: "MWF 6:00 PM - 7:30 PM", seats: 10, enrollmentLock: NSLock()),
        Course(name: "CS161", units: 5, time: "TTH 8:00 PM - 8:30 PM", seats: 5, enrollmentLock: NSLock()),
        Course(name: "CS112", units: 4, time: "TTH 1:00 PM - 2:30 PM", seats: 0, enrollmentLock: NSLock()),
        Course(name: "BIO 53", units: 3, time: "TTH 1:00 PM - 2:30 PM", seats: 5, enrollmentLock: NSLock()),
        Course(name: "CHEM 31M", units: 4, time: "MWF 10:00 AM - 11:00 AM", seats: 10, enrollmentLock: NSLock())
        
    ]

    /* Assesses whether a class has enough seats for enrollment */
    func hasInsufficientSeats() -> Bool {
        return selectedCourses.contains { $0.seats <= 0 }
    }
    
    /* Checks whether or not any classes overlap in time */
    func isOverlap(course: Course) -> Bool {

        /* Iterate through all selected courses */
        for selectedCourse in selectedCourses {
            
            /* Check if times overlap -- exact comparison */
            if (course.time == selectedCourse.time && course.name != selectedCourse.name) {
                print(course.name, " overlaps with: ", selectedCourse.name)
                return true
            }
        }
        return false
    }


    
    func enrollSelectedCourses() {
        
        var locks: [NSLock] = []

       /* Acquire all locks for courses we want to register */
       for course in selectedCourses {
           locks.append(course.enrollmentLock)
           course.enrollmentLock.lock()
       }

        /* Check for valid number of units */
        if selectedUnits >= 12 && selectedUnits <= 20 {
            // Check for overlapping class times before enrollment
                // Check for available seats
                if !hasInsufficientSeats()
                
                 {
                    /* Create a mutable copy of selectedCourses to adjust seat count */
                    var updatedSelectedCourses = selectedCourses

                    /* Decrease the number of seats for each course in the mutable copy */
                    updatedSelectedCourses.indices.forEach { index in
                        updatedSelectedCourses[index].seats -= 1
                    }

                    /* Update selectedCourses with the modified copy */
                    selectedCourses = updatedSelectedCourses

                    print("Enrolled in courses with \(selectedUnits) units.")
                } else {
                    // Handle insufficient seats
                    print("Insufficient seats for enrollment.")
                }
            
            }
        else {
            /* Handle unit limit exceeded or insufficient units */
            if (selectedUnits < 12) {
                print("Insufficient units to enroll.")
            } else {
                print("Exceeded enrollment cap")
            }
        }
    /* Release acquired locks */
       for lock in locks {
           lock.unlock()
       }
    }
}



@main
struct CourseSchedulerApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
