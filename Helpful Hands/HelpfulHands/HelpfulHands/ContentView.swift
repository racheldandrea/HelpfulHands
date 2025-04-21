//
//  ContentView.swift
//  HelpfulHands
//
//  Created by Rachel D'Andrea on 4/17/25.
//

import SwiftUI



  

struct HelpfulHands: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}






struct StudentDashboardView: View {
    @State private var students: [Student] = [
        Student(name: "John Doe", birthday: "01/15/2015", parentContact: "555-123-4567"),
        Student(name: "Jane Smith", birthday: "02/20/2014", parentContact: "555-234-5678"),
        Student(name: "Alice Johnson", birthday: "03/30/2013", parentContact: "555-345-6789"),
        Student(name: "Bob Brown", birthday: "04/12/2012", parentContact: "555-456-7890"),
        Student(name: "Charlie Green", birthday: "05/18/2011", parentContact: "555-567-8901"),
        Student(name: "Daisy Blue", birthday: "06/25/2015", parentContact: "555-678-9012"),
        Student(name: "Evan White", birthday: "07/08/2014", parentContact: "555-789-0123"),
        Student(name: "Fiona Black", birthday: "08/14/2013", parentContact: "555-890-1234"),
        Student(name: "George Yellow", birthday: "09/22/2012", parentContact: "555-901-2345"),
        Student(name: "Hannah Pink", birthday: "10/05/2011", parentContact: "555-012-3456"),
        Student(name: "Ian Gray", birthday: "11/11/2015", parentContact: "555-123-4567"),
        Student(name: "Julia Red", birthday: "12/24/2014", parentContact: "555-234-5678"),
        Student(name: "Kevin Violet", birthday: "01/01/2013", parentContact: "555-345-6789"),
        Student(name: "Laura Orange", birthday: "02/14/2012", parentContact: "555-456-7890"),
        Student(name: "Mike Teal", birthday: "03/17/2011", parentContact: "555-567-8901")
    ]
    @State private var showEditModal = false
    @State private var selectedStudent: Student?

    var body: some View {
        NavigationView {
            VStack {
                // List of Students
                List {
                    ForEach($students) { $student in
                        HStack {
                            VStack(alignment: .leading) {
                                Text(student.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Text("Birthday: \(student.birthday)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                                Text("Parent: \(student.parentContact)")
                                    .font(.subheadline)
                                    .foregroundColor(.white)
                            }
                            Spacer()
                            // Attendance Picker
                            Picker("Attendance", selection: $student.attendance) {
                                Text("Present").foregroundColor(.green).tag(Attendance.present)
                                Text("Late").foregroundColor(.yellow).tag(Attendance.late)
                                Text("Absent").foregroundColor(.red).tag(Attendance.absent)
                            }
                            .pickerStyle(MenuPickerStyle())
                            .padding(5)
                            .background(Color.white)
                            .cornerRadius(5)
                            
                            // Edit Button
                            Button(action: {
                                selectedStudent = student
                                showEditModal = true
                            }) {
                                Image(systemName: "pencil")
                                    .foregroundColor(.white)
                            }
                        }
                        .padding()
                        .background(Color(hex: "#9B59B6"))
                        .cornerRadius(10)
                    }
                    .onDelete(perform: removeStudent)
                }
                .listStyle(PlainListStyle()) // Ensure proper scrolling
                
                // Add Student Button
                Button(action: addStudent) {
                    Text("Add Student")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.black)
                        .background(Color(hex: "#F9E79F"))
                        .cornerRadius(10)
                }
                .padding()
            }
            .navigationTitle("Student Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .background(Color(hex: "#D7BDE2").ignoresSafeArea())
            .sheet(isPresented: $showEditModal) {
                if let student = selectedStudent {
                    EditStudentView(student: $students[students.firstIndex(where: { $0.id == student.id })!])
                }
            }
        }
    }
    
    func addStudent() {
        students.append(Student(name: "New Student", birthday: "MM/DD/YYYY", parentContact: "555-000-0000"))
    }

    func removeStudent(at offsets: IndexSet) {
        students.remove(atOffsets: offsets)
    }
}



// MARK: - Edit Student Modal
struct EditStudentView: View {
    @Binding var student: Student
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            Form {
                TextField("Name", text: $student.name)
                TextField("Birthday", text: $student.birthday)
                TextField("Parent Contact", text: $student.parentContact)
            }
            .navigationTitle("Edit Student")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Student Model
struct Student: Identifiable {
    let id = UUID()
    var name: String
    var birthday: String
    var parentContact: String
    var attendance: Attendance = .present
}

enum Attendance: String, CaseIterable, Identifiable {
    case present, late, absent
    var id: String { self.rawValue }
}

// MARK: - Hex Color Extension
extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1 // Skip the "#"
        var rgb: UInt64 = 0
        scanner.scanHexInt64(&rgb)
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        self.init(red: red, green: green, blue: blue)
    }
}


struct ActivityPageView: View {
    private let activities: [String: [String]] = [
        "Kindergarten": [
            "Create a finger-painting mural as a group",
            "Practice counting with colorful beads",
            "Sing and dance to a nursery rhyme",
            "Play a game of Simon Says to develop listening skills",
            "Sort objects by color or shape",
            "Create a classroom weather chart each morning",
            "Read a picture book and act out the story"
        ],
        "Grades 1-2": [
            "Build a mini paper town to learn about community roles",
            "Practice addition and subtraction with a classroom store",
            "Create a simple science experiment with magnets",
            "Write and illustrate a short story",
            "Learn about plants by growing seeds in small pots",
            "Play a math bingo game to reinforce basic math skills",
            "Use building blocks to solve simple engineering challenges"
        ],
        "Grades 3-5": [
            "Design and test paper airplanes for distance and accuracy",
            "Create a volcano model and simulate an eruption",
            "Write a letter to a historical figure as a class activity",
            "Solve a classroom scavenger hunt using math clues",
            "Learn basic coding with a simple drag-and-drop program",
            "Build a bridge with popsicle sticks and test its strength",
            "Draw a map of your local community and label key landmarks"
        ],
        "Grades 6-8": [
            "Create a timeline of major historical events in groups",
            "Build a wind-powered car with simple materials",
            "Write and perform a short play about a science topic",
            "Work in teams to solve a STEM-based escape room challenge",
            "Design a poster about environmental conservation",
            "Use a microscope to explore and label different cell types",
            "Create a model of the solar system with scaling for planets"
        ],
        "Grades 9-12": [
            "Debate a current event topic in small groups",
            "Design and execute a simple physics experiment",
            "Create and present a business idea in a Shark Tank-style format",
            "Write and perform a spoken word poem or short skit",
            "Design a website or app prototype for a community need",
            "Build a working model of a sustainable house",
            "Create a multimedia presentation about a historical event"
        ],
        "Rainy Day": [
            "Create a collaborative classroom art project",
            "Write and share short poems about the rain",
            "Play indoor charades with vocabulary words",
            "Design a paper kite and discuss aerodynamics",
            "Explore a virtual museum tour on the classroom computer",
            "Have a storytelling circle using prompts from a jar",
            "Practice yoga or mindfulness exercises to stay active indoors"
        ],
        "Outdoor Games": [
            "Play a cooperative relay race with educational challenges",
            "Organize a nature scavenger hunt on school grounds",
            "Create a hopscotch game using math problems",
            "Play a team-based trivia game outdoors",
            "Set up an obstacle course with physical and mental challenges",
            "Use chalk to draw and solve large math problems",
            "Have a group discussion or class debate in an outdoor circle"
        ],
        "STEM Activities": [
            "Build a model roller coaster to discuss potential and kinetic energy",
            "Create a simple circuit with batteries and light bulbs",
            "Program a robot or use a coding app as a group",
            "Learn about buoyancy by designing a boat that floats",
            "Measure and graph the height of classroom paper rockets",
            "Simulate an earthquake and test building designs for stability",
            "Explore chemical reactions by making a classroom lava lamp"
        ]
    ]

    @State private var randomActivity: String? = nil
    @State private var selectedCategory: String? = nil

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                // Page Header
                Text("Activity Ideas")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black) // Set to black
                    .padding(.top)
                
                // Random Activity Display
                if let randomActivity = randomActivity {
                    VStack {
                        Text("Here's an idea!")
                            .font(.headline)
                            .foregroundColor(.black)
                        
                        Text(randomActivity)
                            .font(.title2)
                            .padding()
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity, minHeight: 150)
                            .background(Color.white)
                            .cornerRadius(12)
                            .shadow(radius: 5)
                            .padding(.horizontal)
                            .transition(.scale.combined(with: .opacity)) // Dynamic transition
                        
                        // Generate New Idea Button
                        if let category = selectedCategory {
                            Button(action: {
                                generateRandomActivity(from: category)
                            }) {
                                Text("Generate New Idea")
                                    .font(.headline)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color(hex: "#8E44AD")) // Darker purple
                                    .foregroundColor(.white)
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                            .padding(.horizontal)
                            .padding(.top, 10)
                        }
                        
                        // Restart Button
                        Button(action: {
                            restart()
                        }) {
                            Text("Restart")
                                .font(.headline)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color(hex: "#8E44AD")) // Darker purple
                                .foregroundColor(.white)
                                .cornerRadius(12)
                                .shadow(radius: 5)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                    }
                } else {
                    Text("Tap a category to get an idea!")
                        .font(.headline)
                        .foregroundColor(.gray)
                        .padding(.top)
                }
                
                // Add space between the generator and the grid
                Spacer().frame(height: 30)
                
                // Grid Layout for Categories
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(activities.keys.sorted(), id: \.self) { category in
                            Button(action: {
                                selectedCategory = category
                                generateRandomActivity(from: category)
                            }) {
                                Text(category)
                                    .font(.headline)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(Color.white)
                                    .foregroundColor(Color(hex: "#D7BDE2"))
                                    .cornerRadius(12)
                                    .shadow(radius: 5)
                            }
                        }
                    }
                    .padding()
                }
            }
            .padding()
            .background(Color(hex: "#D7BDE2").ignoresSafeArea()) // Full-screen purple background
            .navigationTitle("")
            .navigationBarHidden(true)
        }
    }
    
    private func generateRandomActivity(from category: String) {
        if let activitiesForCategory = activities[category] {
            withAnimation {
                randomActivity = activitiesForCategory.randomElement()
            }
        }
    }
    
    private func restart() {
        withAnimation {
            randomActivity = nil
            selectedCategory = nil
        }
    }
}




// MARK: - ContentView with Tab Navigation



struct ContentView: View {
    @State private var showWelcomeMessage = true // State to control the custom pop-up

    var body: some View {
        ZStack {
            // Main content
            VStack {
                // Header with Logo and Title
                HStack {
                    Image("app logo") // Use your app logo from assets
                        .resizable()
                        .scaledToFit() // Maintain aspect ratio
                        .frame(width: 80, height: 80) // Adjust size as needed
                        .padding(.leading, 10) // Add padding to push it more to the left

                    Spacer() // Push the text to the center

                    Text("Helpful Hands")
                        .font(.custom("Barriecito", size: 40)) // Use Barriecito font
                        .foregroundColor(Color(hex: "#5D3A8A")) // Dark purple
                        .frame(maxWidth: .infinity, alignment: .center) // Center the text

                    Spacer() // Balance spacing on the right side
                }
                .padding()

                // TabView
                TabView {
                    StudentDashboardView()
                        .tabItem {
                            Label("Dashboard", systemImage: "house")
                        }

                    TeacherScheduleView()
                        .tabItem {
                            Label("Schedule", systemImage: "calendar")
                        }

                    TimerPageView()
                        .tabItem {
                            Label("Timer", systemImage: "timer")
                        }

                    ActivityPageView()
                        .tabItem {
                            Label("Activities", systemImage: "lightbulb")
                        }
                }
            }
            .background(Color(hex: "#F9E79F").ignoresSafeArea()) // Yellow background

            // Custom Welcome Pop-Up
            if showWelcomeMessage {
                WelcomePopup(showWelcomeMessage: $showWelcomeMessage)
            }
        }
    }
}
struct WelcomePopup: View {
    @Binding var showWelcomeMessage: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to Helpful Hands!")
                .font(.custom("Barriecito", size: 30))
                .foregroundColor(.white)

            Text("""
                Welcome to Helpful Hands — the all-in-one app designed to simplify your day with easy access to student info, scheduling, timers, and activity ideas. Whether you're in the classroom or on the go, Helpful Hands is here to support you every step of the way!
                """)
                .font(.body)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button(action: {
                // Dismiss the pop-up
                showWelcomeMessage = false
            }) {
                Text("Got it!")
                    .font(.headline)
                    .foregroundColor(Color(hex: "#F9E79F")) // Yellow color
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Capsule().fill(Color(hex: "#5D3A8A"))) // Purple background
            }
        }
        .padding()
        .frame(width: 300, height: 500) // Adjust the size of the pop-up
        .background(Color(hex: "#5D3A8A")) // Purple background
        .cornerRadius(20)
        .shadow(radius: 10)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(hex: "#F9E79F"), lineWidth: 2) // Yellow border
        )
        .padding()
    }
}

// Extend Color to allow hex values

// MARK: - Models

struct ScheduleTimeSlot: Identifiable {
    let id = UUID()
    let time: String
    var task: ScheduleTaskItem?
}

struct ScheduleTaskItem: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let color: Color
}

// MARK: - Schedule Builder View

struct TeacherScheduleView: View {
    @State private var currentDay: String = "M" // The currently selected day (M-F)
    @State private var schedules: [String: [ScheduleTimeSlot]] = [:] // Separate schedules for each day
    @State private var availableItems: [ScheduleTaskItem] = [
        ScheduleTaskItem(name: "Meeting", color: .blue),
        ScheduleTaskItem(name: "Lesson Prep", color: .green),
        ScheduleTaskItem(name: "Parent Conference", color: .orange),
        ScheduleTaskItem(name: "Grading", color: .purple),
        ScheduleTaskItem(name: "Break", color: .gray)
    ]
    @State private var showCustomTaskModal: Bool = false // Modal for creating custom tasks

    let dayNames = ["M": "Monday", "T": "Tuesday", "W": "Wednesday", "TH": "Thursday", "F": "Friday"]

    init() {
        // Initialize schedules for all days (Monday through Friday)
        _schedules = State(initialValue: ["M", "T", "W", "TH", "F"].reduce(into: [String: [ScheduleTimeSlot]]()) { result, day in
            result[day] = Self.generateTimeSlots()
        })
    }

    var body: some View {
        NavigationView {
            VStack {
                // Header with full day name
                Text("\(dayNames[currentDay] ?? "") Schedule")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                // Day Selector Tabs (M-F)
                HStack(spacing: 10) {
                    ForEach(["M", "T", "W", "TH", "F"], id: \.self) { day in
                        Button(action: {
                            currentDay = day
                        }) {
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(currentDay == day ? Color.yellow : Color.white)
                                .foregroundColor(.black)
                                .cornerRadius(8)
                        }
                    }
                }
                .padding(.horizontal)

                Divider()

                // Scrollable Schedule View (7AM–4PM)
                ScrollView {
                    VStack(spacing: 10) {
                        if let daySlots = schedules[currentDay] {
                            ForEach(daySlots) { slot in
                                HStack {
                                    // Time
                                    Text(slot.time)
                                        .frame(width: 80, alignment: .leading)
                                        .padding(.leading)
                                    Spacer()
                                    // Task or Dropdown for Empty Slot
                                    if let task = slot.task {
                                        // Menu for Task to Remove or Replace
                                        Menu {
                                            Button("Remove Task") {
                                                removeTask(from: slot)
                                            }
                                            ForEach(availableItems) { newTask in
                                                Button("Replace with \(newTask.name)") {
                                                    replaceTask(newTask, in: slot)
                                                }
                                            }
                                        } label: {
                                            Text(task.name)
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(task.color)
                                                .cornerRadius(8)
                                                .foregroundColor(.white)
                                        }
                                    } else {
                                        // Dropdown Menu for Empty Slot
                                        Menu {
                                            ForEach(availableItems) { task in
                                                Button(action: {
                                                    assignTask(task, to: slot)
                                                }) {
                                                    HStack {
                                                        Text(task.name)
                                                        Spacer()
                                                        Circle()
                                                            .fill(task.color)
                                                            .frame(width: 12, height: 12)
                                                    }
                                                }
                                            }
                                            Divider()
                                            Button(action: {
                                                showCustomTaskModal = true
                                            }) {
                                                Text("Add Custom Task")
                                            }
                                        } label: {
                                            Text("Tap to Add")
                                                .frame(maxWidth: .infinity)
                                                .padding()
                                                .background(Color.gray.opacity(0.2))
                                                .cornerRadius(8)
                                        }
                                    }
                                }
                                .frame(height: 50)
                            }
                        } else {
                            Text("No schedule available for \(currentDay)")
                                .foregroundColor(.red)
                        }
                    }
                    .padding()
                }

                Divider()

                // Available Tasks Section
                Text("Available Tasks")
                    .font(.headline)
                    .padding(.top)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(availableItems) { task in
                            Text(task.name)
                                .frame(width: 120, height: 40)
                                .background(task.color)
                                .cornerRadius(8)
                                .foregroundColor(.white)
                        }
                        Button(action: {
                            showCustomTaskModal = true
                        }) {
                            Text("+ Custom")
                                .frame(width: 120, height: 40)
                                .background(Color.gray.opacity(0.2))
                                .cornerRadius(8)
                        }
                    }
                    .padding()
                }
            }
            .background(Color(hex: "#D7BDE2").ignoresSafeArea())
            .navigationTitle("")
            .navigationBarHidden(true)
            .sheet(isPresented: $showCustomTaskModal) {
                CreateCustomTaskView(availableItems: $availableItems)
            }
        }
    }

    private static func generateTimeSlots() -> [ScheduleTimeSlot] {
        (7...16).map { hour in
            ScheduleTimeSlot(time: "\(hour > 12 ? hour - 12 : hour):00 \(hour >= 12 ? "PM" : "AM")", task: nil)
        }
    }

    private func assignTask(_ task: ScheduleTaskItem, to slot: ScheduleTimeSlot) {
        // Find the index of the time slot in the schedule for the current day
        if let index = schedules[currentDay]?.firstIndex(where: { $0.id == slot.id }) {
            // Update the task for the selected time slot
            schedules[currentDay]?[index].task = task
        }
    }

    private func removeTask(from slot: ScheduleTimeSlot) {
        // Find the index of the time slot in the schedule for the current day
        if let index = schedules[currentDay]?.firstIndex(where: { $0.id == slot.id }) {
            // Remove the task for the selected time slot
            schedules[currentDay]?[index].task = nil
        }
    }

    private func replaceTask(_ newTask: ScheduleTaskItem, in slot: ScheduleTimeSlot) {
        // Find the index of the time slot in the schedule for the current day
        if let index = schedules[currentDay]?.firstIndex(where: { $0.id == slot.id }) {
            // Replace the task for the selected time slot
            schedules[currentDay]?[index].task = newTask
        }
    }
}

// MARK: - Custom Task Creation Modal

struct CreateCustomTaskView: View {
    @Binding var availableItems: [ScheduleTaskItem]
    @Environment(\.dismiss) var dismiss
    @State private var customName: String = ""
    @State private var customColor: Color = .blue

    var body: some View {
        NavigationView {
            Form {
                TextField("Task Name", text: $customName)
                ColorPicker("Pick a Color", selection: $customColor)
            }
            .navigationTitle("Custom Task")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if !customName.isEmpty {
                            let newTask = ScheduleTaskItem(name: customName, color: customColor)
                            availableItems.append(newTask)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}







// MARK: - Timer Page




struct TimerPageView: View {
    @State private var hours: String = "" // Text entry for hours
    @State private var minutes: String = "" // Text entry for minutes
    @State private var seconds: String = "" // Text entry for seconds
    @State private var isTimerRunning: Bool = false // To track if the timer is running
    @State private var isTimerPaused: Bool = false // To track if the timer is paused
    @State private var timeRemaining: Int = 0 // Total time in seconds
    @State private var timer: Timer? // Timer instance
    @State private var showConfetti: Bool = false // To display confetti animation when timer ends
    @State private var showDetailView: Bool = false // To display the detail view while the timer is running or completed

    var body: some View {
        ZStack {
            VStack {
                // Page Title
                Text("Set Timer")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top)

                Spacer()

                // Text Input for Hours, Minutes, and Seconds
                VStack(spacing: 20) {
                    HStack {
                        VStack {
                            Text("Hours")
                                .font(.headline)
                            TextField("0", text: $hours)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack {
                            Text("Minutes")
                                .font(.headline)
                            TextField("0", text: $minutes)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                        }
                        VStack {
                            Text("Seconds")
                                .font(.headline)
                            TextField("0", text: $seconds)
                                .keyboardType(.numberPad)
                                .multilineTextAlignment(.center)
                                .frame(width: 60)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                }
                .padding()

                // Start Button
                Button(action: {
                    if isTimerRunning {
                        isTimerPaused = !isTimerPaused
                        if isTimerPaused {
                            stopTimer() // Pause the timer
                        } else {
                            startTimer() // Resume the timer
                        }
                    } else {
                        startTimer()
                        showDetailView = true // Transition to detail view when timer starts
                    }
                }) {
                    Text(isTimerRunning ? (isTimerPaused ? "Resume Timer" : "Pause Timer") : "Start Timer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isTimerRunning ? (isTimerPaused ? Color.green : Color.orange) : Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()

                Spacer()
            }
            .padding()
            .background(Color.fromHex("#D7BDE2").ignoresSafeArea())
            .onDisappear {
                stopTimer() // Stop the timer when the view disappears
            }

            // Confetti Animation
            if showConfetti {
                ConfettiView()
                    .edgesIgnoringSafeArea(.all)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            showConfetti = false // Hide confetti after 3 seconds
                        }
                    }
            }

            // Detail View for Timer Running or Completion
            if showDetailView {
                TimerDetailView(
                    timeRemaining: $timeRemaining,
                    isTimerPaused: $isTimerPaused,
                    isTimerRunning: $isTimerRunning,
                    stopTimer: stopTimer,
                    resetTimer: resetTimer,
                    startTimer: startTimer,
                    showConfetti: $showConfetti,
                    showDetailView: $showDetailView
                )
            }
        }
    }

    // MARK: - Timer Functions

    private func startTimer() {
        if isTimerPaused {
            // Resume timer
            isTimerPaused = false
        } else {
            // Calculate total time in seconds for the first start
            let totalHours = Int(hours) ?? 0
            let totalMinutes = Int(minutes) ?? 0
            let totalSeconds = Int(seconds) ?? 0
            timeRemaining = (totalHours * 3600) + (totalMinutes * 60) + totalSeconds
        }

        // Ensure there is time to start
        guard timeRemaining > 0 else { return }

        isTimerRunning = true

        // Start the timer
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                stopTimer()
                showConfetti = true // Show confetti when timer runs out
            }
        }
    }

    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    private func resetTimer() {
        stopTimer()
        timeRemaining = 0
        hours = ""
        minutes = ""
        seconds = ""
        isTimerRunning = false
        isTimerPaused = false
        showDetailView = false
    }
}

struct TimerDetailView: View {
    @Binding var timeRemaining: Int
    @Binding var isTimerPaused: Bool
    @Binding var isTimerRunning: Bool
    let stopTimer: () -> Void
    let resetTimer: () -> Void
    let startTimer: () -> Void
    @Binding var showConfetti: Bool
    @Binding var showDetailView: Bool

    var body: some View {
        VStack {
            Spacer()

            // Large Timer Display
            Text(formatTime(seconds: timeRemaining))
                .font(.system(size: 80))
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .padding()

            Spacer()

            // Pause/Resume and Reset Buttons
            HStack(spacing: 20) {
                Button(action: {
                    isTimerPaused.toggle()
                    if isTimerPaused {
                        stopTimer()
                    } else {
                        startTimer()
                    }
                }) {
                    Text(isTimerPaused ? "Resume Timer" : "Pause Timer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(isTimerPaused ? Color.green : Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }

                Button(action: {
                    resetTimer()
                }) {
                    Text("Reset Timer")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
            }
            .padding()

            if timeRemaining == 0 {
                Button(action: {
                    showDetailView = false // Go back to the start view
                }) {
                    Text("Back")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                .padding()
            }
        }
        .background(Color.fromHex("#D7BDE2").ignoresSafeArea())
    }

    private func formatTime(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds % 3600) / 60
        let seconds = seconds % 60
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}

// MARK: - Confetti View


struct ConfettiView: View {
    @State private var confettiItems: [ConfettiItem] = [] // Array to hold confetti data

    var body: some View {
        ZStack {
            ForEach(confettiItems) { item in
                ConfettiShape()
                    .foregroundColor(item.color)
                    .frame(width: 10, height: 10)
                    .position(x: item.startX, y: item.startY)
                    .offset(x: item.offset.width, y: item.offset.height)
            }
        }
        .onAppear {
            startConfettiAnimation()
        }
    }

    private func startConfettiAnimation() {
        // Generate 100 confetti items
        confettiItems = (0..<100).map { _ in
            ConfettiItem(
                id: UUID(),
                startX: CGFloat.random(in: 0...UIScreen.main.bounds.width),
                startY: -50, // Start above the screen
                offset: CGSize.zero, // Initial offset
                color: [Color.red, Color.green, Color.blue, Color.yellow, Color.orange, Color.purple].randomElement()!
            )
        }

        // Start falling animation
        for index in confettiItems.indices {
            let delay = Double(index) * 0.02 // Slight delay for staggered animation
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 3)) {
                    confettiItems[index].offset = CGSize(
                        width: CGFloat.random(in: -50...50), // Random horizontal drift
                        height: UIScreen.main.bounds.height + CGFloat.random(in: 100...200) // Fall below the screen
                    )
                }
            }
        }

        // Remove confetti after 3 seconds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            withAnimation {
                confettiItems.removeAll()
            }
        }
    }
}

struct ConfettiItem: Identifiable {
    let id: UUID
    let startX: CGFloat
    let startY: CGFloat
    var offset: CGSize
    let color: Color
}

struct ConfettiShape: View {
    var body: some View {
        Circle() // Simple circle as confetti shape
    }
}

// MARK: - Color Extension

extension Color {
    static func fromHex(_ hex: String) -> Color {
        let cleanedHex = hex.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: "#", with: "")
        var rgb: UInt64 = 0
        Scanner(string: cleanedHex).scanHexInt64(&rgb)
        
        let red = Double((rgb >> 16) & 0xFF) / 255.0
        let green = Double((rgb >> 8) & 0xFF) / 255.0
        let blue = Double(rgb & 0xFF) / 255.0
        
        return Color(red: red, green: green, blue: blue)
    }
    
    #Preview {
        ContentView()
    }
}

