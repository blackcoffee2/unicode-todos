# Unicode Todos App

A todo application for unicode flutter developer interview.

## Getting Started

This project uses MVC pattern to implement separation of concerns.

Here is a brief description of folder structure

1. controllers - app logic i.e. adding or modifying data.
2. models - data classes that app will use.
3. screens - widgets that represent full screens.
4. utils - functions that are handy while doing small operations.
5. widgets - widgets that represent a portion of UI in a screen.

## Setup Requirements

Install the latest version of flutter. This project has been built and tested using latest version of flutter
of its time which is 3.24.3.

## Run App

Clone and run

`flutter run`

## Run Tests

In order to run integration test run this command

`flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart`

## Testing Firebase Syncing

Firebase syncing has been implemented which will sync todos after 6 hours. However, in order to test it you must create a new firebase project and follow installation instructions for Android/iOS. If firebase project has not been added then the app will simply skip firebase syncing.
