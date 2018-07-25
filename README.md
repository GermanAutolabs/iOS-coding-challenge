# German Autolabs iOS coding challenge

## Overview
The whole original challenge readme is incorporated as reference below.

I created a nice application with simplicity and usability in mind. The interface uses parallax effect, so if you can, please try it on a device to experience it in full glory.

The application listens when it displays "Ask the current weather...".

You can ask for the local weather like "What's the weather here", or weather in a city like "What's the weather like in London".

Have fun!

## Usage

**! IMPORTANT !**

To run the application, you must create Config.plist (or any other property list) file in the project, with your OpenWeatherMap API key as value for key "apiKey". ConfigExample.plist is provided as reference.
If you want to name you property list file differently, you can do that by initiating Config() with your file name.
Not having a proper property list file leads to a juicy preconditionFailure, with description of the problem and how to solve it. Config.plist is git ignored.

## Shortcomings, future plans
The speech engine stops after one minute, this shortcoming is NOT handled yet.

The application supports different weather based displays, but the images for different weather situations are not included yet.



# Original readme


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
It should take you between 4 to 8 hours to finish this task. If it takes you longer, it's okay to leave TODOs in the code, just provide an explanation what you would still finish there.

After sending the challenge we'll wait 2 weeks to hear back from you. Feel free to ask us for any clarification if you need it.

## Process
When you're ready, please fork this repository and start writing code in your fork. You'll get extra points for committing often in small chunks, so we'll see the process of how you created the application.

# Process
When you're ready, please fork this repository and start writing code in your fork. You'll get extra points for committing often in small chunks, so we'll see the process of how you created the application.