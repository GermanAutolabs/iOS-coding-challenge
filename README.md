# Usage
To use the app to ask it for the weather you have to enter an **API-Key** from [api.openweathermap.org]() in the ConnectionManager.swift.
Then you can run the application on your phone. Hold down the microphone button as long as you speak. 

So you can ask for different locations:
- “What is the weather in Berlin”
- “What is the temperature in New York”


###  ! Update !
The updated version includes:
- Much clearer delegate methods
- The voice recognition now finishes even if the mic button is already lifted
- The `struct Weather` is now a `Codable` and will be decoded from the server response
- An error is shown if the user not accepted ‘using location’
- A complete test of a whole flow of fetching weather data

# Future
- Create UI tests. Currently, there are just Unittests
- Better error handling and notification for the user about errors
- Handling stuff like “tomorrow” or specific dates that the user asked for

# iOS Coding Challenge
We want to know how you write **code** - we don't care about coding challenges where you have to reimplement the HTTP protocol by using the bare basics, we want to know how you can use the existing libraries to solve the problems that we have to solve.

Your task is to create a very small iOS application (written in Swift) which will listen to a voice of the user and will tell them the current weather information when asked for. It's up to you to decide how exactly you want to approach this challenge - do you want to use the native iOS SDKs for voice recognition, use offline voice recognition for keywords (e.g. PocketSphinx) or another online service with conversational capabilities (e.g. api.ai, Microsoft LUIS, etc.). You can also choose whichever weather service you want.

## What we'll look at
- Structure of the code - how you use controllers, services, views. Keep it clean and reusable.
- Code formatting, included unit and UI tests.
- Using external APIs is cool, but you have to make sure the app will support errors if the API is down.
- Readme - we don't need documentation, but a small file explaining how to run the project will be useful.
- Overall user experience in the application.

## Time limit
It should take you between 4 to 8 hours to finish this task (a senior can probably do it in 2!). If it takes you longer, it's okay to leave TODOs in the code, just provide an explanation what you would still finish there.

After sending the challenge we'll wait 2 weeks to hear back from you. Feel free to ask us for any clarification if you need it.

## Process
When you're ready, please fork this repository and start writing code in your fork. You'll get extra points for committing often in small chunks, so we'll see the process of how you created the application.

