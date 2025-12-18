# ezBudget

A simple, manual budgeting app for Android built with Flutter.

## Description

ezBudget is a mobile application designed for users who want a straightforward and manual approach to budget management. Unlike many budgeting apps that integrate with financial institutions, ezBudget focuses on simplicity. It allows users to create budgets for different categories or time periods and manually record expenses as they happen. This provides a real-time, clear overview of spending without the complexity and delays of automated transaction syncing.

The main interface presents a list of all created budgets, prominently displaying the total remaining balance across all of them. Each budget entry shows its name, the total and remaining amounts, and is planned to show the reset period. Tapping on a budget reveals a detailed view with a history of all transactions and a simple form to quickly add new expenses.

## Technology Stack

*   **Framework:** Flutter
*   **Language:** Dart

## Key Features

*   **Budget Creation:** Easily create and manage multiple budgets.
*   **Manual Expense Tracking:** Add expenses manually to any budget with a simple form.
*   **Dashboard View:** At-a-glance view of all budgets and the total remaining funds.
*   **Transaction History:** View a detailed list of deductions for each budget.
*   **Local Storage:** Budget data is persisted locally on the device using a `budgets.json` file.
*   **Responsive Layout:** Includes a basic grid layout that adapts to screen width.

## Code Structure Highlights

*   `lib/main.dart`: The entry point of the application.
*   `lib/budget.dart`: Defines the core `Budget` data model, including properties like `label`, `total`, `remaining`, and the `ResetInterval` enum.
*   `lib/budget_storage.dart`: Contains the logic for reading and writing budget data to the device's local storage.
*   `lib/main_view.dart`: The main screen of the app, displaying the list of budgets.
*   `lib/spend_view.dart`: The screen used to view a budget's transaction history and to deduct new expenses.
*   `lib/create_budget_dialog.dart`: A dialog for creating new budgets.

## Future Enhancements

*   **Budget Reset Automation:** Implement the feature for budgets to automatically reset based on their defined interval (e.g., weekly, monthly). A countdown or "time remaining" display will also be added.
*   **Cloud Sync:** Integrate with Google Accounts to synchronize budget data across devices, enabling a web-based version of the app.
*   **iOS Support:** Ensure the application is fully functional and optimized for iOS.
*   **Improved Responsive UI:** Enhance the adaptive layout for a better experience on a wider range of screen sizes and orientations.
