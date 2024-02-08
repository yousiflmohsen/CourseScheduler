import SwiftUI
struct ContentView: View {
    @StateObject private var viewModel = EnrollmentViewModel()
    @State private var selectedCourseIndices: Set<Int> = Set()
    
    var body: some View {
        NavigationView {
            /* UI Code */
            VStack(alignment: .leading, spacing: 16) {
                /* Text showing number of units planned */
                Text("Total Units: \(viewModel.selectedUnits)")
                    .font(.headline)
                    .padding()

                ScrollView {
                    VStack(alignment: .leading, spacing: 8) {
                        /* Display all available courses */
                        ForEach(0..<viewModel.availableCourses.count) { index in
                            let course = viewModel.availableCourses[index]
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(course.name)
                                        .font(.headline)
                                    Text("Time: \(course.time)")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("Seats: \(course.seats)")
                                        .font(.caption)
                                        .foregroundColor(course.seats > 0 ? .green : .red)  // Highlight available seats in green
                                }
                                Spacer()
                                /* Adding courses to plan logic */
                                Image(systemName: selectedCourseIndices.contains(index) ? "checkmark.square.fill" : "square")
                                
                                    /* Tapping checkmark */
                                    .onTapGesture {
                                        let course = viewModel.availableCourses[index]
                                        /* User cannot add course as exceeds unit limit */
                                        if !selectedCourseIndices.contains(index) && viewModel.selectedUnits + course.units > 20 {
                                            print("Adding \(course.name) will exceed 20 units.")
                                        /* No available seats */
                                        } else if course.seats == 0 {
                                            print("\(course.name) has no available seats.")
                                            
                                        /* Handles removing of course (it was already added, they are unchecking */
                                        } else {
                                            if selectedCourseIndices.contains(index) {
                                                selectedCourseIndices.remove(index)
                                                viewModel.selectedUnits -= course.units
                                                /* Remove the course from selectedCourses when deselected */
                                                  if let selectedIndex = viewModel.selectedCourses.firstIndex(where: { $0.id == course.id }) {
                                                      viewModel.selectedCourses.remove(at: selectedIndex)
                                                  }
                                            /* Add course as selected, and update class components */
                                            } else {
                                                selectedCourseIndices.insert(index)
                                                viewModel.selectedUnits += course.units
                                                /* Check for overlapping class times */
                                                if viewModel.isOverlap(course: course) ||
                                                    (selectedCourseIndices.contains(index) &&
                                                    viewModel.selectedCourses.contains(where: { viewModel.isOverlap(course: $0) || $0.id == course.id })) {
                                                    print("Overlapping class times detected. Proceed with caution")
                                                }
                                                viewModel.selectedCourses.append(course)

                                            }
                                        }
                                    }
                            }
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .background(Color.secondary.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding()
                }
                .background(Color.gray.opacity(0.1))
                .cornerRadius(12)
                .listStyle(InsetGroupedListStyle())

                /* Enroll button */
                Button(action: {
                    viewModel.enrollSelectedCourses()
                }) {
                    Text("Enroll Selected Courses")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()
                /* Cannot enroll if a class you want has insufficent seats*/
                .disabled( viewModel.hasInsufficientSeats()) // can also had if overlap :)

                List {
                    /* Course removal list logic */
                    ForEach(viewModel.selectedCourses.indices, id: \.self) { index in
                        let course = viewModel.selectedCourses[index]
                        HStack {
                            Text(course.name)
                                .foregroundColor(.primary)
                            Spacer()
                            /* Removes course from all variables tracking it, and decriments units planned */
                            Button(action: {
                                let course = viewModel.selectedCourses[index]
                                viewModel.selectedUnits -= course.units
                                viewModel.selectedCourses.remove(at: index)
                                /* Safely removes course from planned courses */
                                if let selectedIndex = viewModel.availableCourses.firstIndex(where: { $0.id == course.id }) {
                                    selectedCourseIndices.remove(selectedIndex)
                                }
                            }) {
                                Text("Remove")
                                    .foregroundColor(.red)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                }
                .listStyle(InsetGroupedListStyle())
            }
            .padding()
            .navigationTitle("Course Enrollment")
        }
    }
}

