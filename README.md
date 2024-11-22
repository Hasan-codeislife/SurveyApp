# Survey Application

An interactive, dynamic survey application built with **SwiftUI** and powered by **The Composable Architecture (TCA)**, demonstrating robust state management, API handling, and test-driven development.

---

## 📚 Table of Contents

- [🖥 Overview](#-overview)
- [✨ Key Features](#-key-features)
- [🔧 Technical Highlights](#-technical-highlights)
- [🧪 Testing](#-testing)
- [🚀 How to Run](#-how-to-run)
- [🖼 Screenshots](#-screenshots)
- [🛠️ Technologies Used](#️-technologies-used)
- [🤔 Challenges & Solutions](#-challenges--solutions)
- [📈 Improvements](#-improvements)
- [🏁 Conclusion](#-conclusion)

## 🖥 Overview

This project was developed to showcase my skills in building modern, scalable, and testable iOS applications. The app consists of two screens:

1. **Initial Screen**  
   A simple entry point with a "Start Survey" button to begin the survey.
   
2. **Questions Screen**  
   A horizontal pager displaying survey questions. Users can navigate through questions, submit answers, and view dynamic updates like submission counts. The UI is equipped with banners for submission success or failure, along with retry functionality.

---

## ✨ Key Features

- **Dynamic Navigation**  
  Seamless transition between screens with state-driven UI updates using TCA.
  
- **State Management with TCA**  
  Ensures predictable state handling and clean separation of concerns.

- **Banner Notifications**  
  Success and failure notifications with automatic dismissal or retry capability.

- **API Integration**  
  Includes robust handling of RESTful API calls for fetching and submitting survey data.

- **Test Automation**  
  Comprehensive unit tests validate the reducer logic, API interactions, and UI state transitions.

- **Customizable Design**  
  Use of reusable padding and spacing constants to maintain consistency and allow easy tweaks.

---

## 🔧 Technical Highlights

### The Composable Architecture (TCA)

The app leverages TCA for:
- **Reducer-driven state changes**: Encapsulates all business logic.
- **Side effects management**: Ensures clear isolation of API calls.
- **Observable State**: SwiftUI views update reactively to state changes.

### SwiftUI
- Fully declarative UI components.
- Navigation is handled programmatically via state-driven conditions.

### Banner Timer Management
Implemented using a cancellable `Task` for ensuring only the latest retry or dismiss action is executed.

## 🧪 Testing

Wrote tests to ensure the reliability of the app's logic and flow:

-   **State Transition Validation**  
    Tests for actions like navigating questions, submitting answers, and dismissing banners.
    
-   **API Handling**  
    Mocked services simulate API success and failure scenarios.
    
-   **Edge Cases**  
    Validates behaviors like retrying submissions and handling API delays.

Example:
``` swift
@Test func submitAnswerSuccess() async {
        
        let store = TestStore(initialState: QuestionsScreenReducer.State(questions: MockData.mockQuestions), reducer: {
            QuestionsScreenReducer(service: service)
        })
        store.exhaustivity = .off
        service.shouldSucceed = true
        
        await store.send(.submitAnswer(0, "Answer 1")) {
            $0.isLoading = true
            $0.questions[0].answer = "Answer 1"
        }
        
        await store.receive({ action in
            guard case .submissionResponse(.success(0)) = action else { return false }
            return true
        }) { state in
            state.isLoading = false
            state.showBanner = true
            state.bannerType = .success
            state.questions[0].isSubmitted = true
            #expect(state.submittedCount == 1, "Submit question count should increase from 0 to one")
            let isCancelled = state.dismissTask?.isCancelled ?? false
            #expect(!isCancelled, "Dismiss task should execute at response")
        }
    }
```
## 🚀 How to Run

1.  Clone the repository:

```bash
`git clone https://github.com/Hasan-codeislife/SurveyApp`
```
2.  Open the project in Xcode:

 ``` bash
cd survey-app
open SurveyApp.xcodeproj
```
3.  Run the project on a simulator or a device.

## 🖼 Screenshots

**Initial Screen**

<img width="193" alt="Screenshot 2024-11-22 at 22 06 47" src="https://github.com/user-attachments/assets/db68a6ed-94b8-45b4-817d-aa82031f8eeb">

**Questions Screen with Failed Banners**

<img width="203" alt="Screenshot 2024-11-22 at 22 06 11" src="https://github.com/user-attachments/assets/1b25eab2-27a9-495c-a03f-627a852ccb7f">


## 🛠️ Technologies Used

-   **SwiftUI**
-   **The Composable Architecture (TCA)**
-   **Swift Testing for Unit Testing**
-   **Swift Package Manager (SPM)**  for dependency management

## 🤔 Challenges & Solutions

### Retry Button Handling

The retry button needed a mechanism to cancel previous dismiss timers to ensure only the latest action was valid. This was solved by:

-   Using a cancellable  `Task`  stored in state.
-   Ensuring any new task cancels the previous one.

## 📈 Improvements

There are a couple of improvements or enhancements that come to mind. I also added the Todos in the code itself.

- Break down the app into smaller, feature-based modules for scalability.
- Add integration tests to complement the existing unit tests.
- There can be empty views that say something like "Oops, couldn't fetch data." to make the project more UX friendly.
- Add UI tests.

### Retry Button Handling

The retry button needed a mechanism to cancel previous dismiss timers to ensure only the latest action was valid. This was solved by:

-   Using a cancellable  `Task`  stored in state.
-   Ensuring any new task cancels the previous one.


## 🏁 Conclusion

This project demonstrates my proficiency in:

-   **Modern iOS development practices**  using SwiftUI and TCA.
-   **Clean code architecture**  for maintainable and scalable apps.
-   **Test automation**  for reliable and robust app behavior.

Feel free to reach out if you'd like to collaborate or discuss this project further :)
