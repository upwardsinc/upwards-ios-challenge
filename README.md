# upwards-ios-challenge

A client has an idea for an application but all that's been provided is the following description and mockup:

```
I want an app where you can see the best music albums from iTunes. It 
should have a modern design. They should also be able to sort the albums.
I tried to make the app myself but I am too busy. Recently released albums 
should also be noted. Thanks.

For reference here is the api we are using: https://rss.itunes.apple.com/en-us
```
![](./docs/mockup.jpeg)

Your task is to checkout the provided code and provide a submission that accomplishes the features the client is requesting. Beyond the functional requirements, we will also be considering the following areas (among others) of code quality:

- Architectures & Frameworks
- SOLID Principles
- File Structure
- Naming Conventions
- Bugfixes & Improvements
- Testing

If you have any questions, don't hesitate to email them to your contact at Upwards. Treat this task as an opportunity to showcase your iOS, engineering, and design strengths. If you want to incorporate a design pattern or multi-module project, go for it! Similarly, if you see a compelling case for more functionality or a more refined design, go ahead and make those improvements. At the same time, we understand you're busy and expect no more than few hours spent on this submission.

## Solution
The app was created with the UI requested. Here are some details on the implementation:
- A main storyboard was added, and the views were created there. Storyboard was used since the app is small and manageable, and due to constraints for implementing the app is a limited amount of time
- Swinject/Swinjectstoryboard was used for dependency injection. Services, View Controllers, View Models, and Utilities were instantiated within the SwinjectStoryboardSetup file
- The project structure consists of Services, Models, Views, View Models, and Utilities
- TopAlbumsViewController contains general view logic, but uses TopAlbumsViewModel for application logic and managing data (albums). Once the albums are retrieved, a Data object is set for each album after retrieving the image from the URL provided in the first albums response
- UI is built using a collection view
- Filter button is another view controller that is presented as a popover. It contains two buttons to sort by Album or Artist. Delegate pattern is used to communicate between TopAlbumsViewController and the FilterAlbumsViewController. FilterAlbumsViewController defines a funtion called filterType that passes in an enum of the filter the user selects. The TopAlbumsViewController will set itself as the filter delegate, and will sort the albums array based on the filter the user selected, then reload the collection view
- New badge is displayed if the album release date was within the past 30 days. There is logic in the TopAlbumsViewModel to determine that
- Unit tests are written for TopAlbumsViewModel, it is fully covered. Time constraints prevented me from writing additional unit tests. To test Network service, you can subclass URLProtocol. URLProtocol performs the underlying work of opening a network connection. We can subclass this class to override real network connections and return mock responses.  

## To run:
- run `pod install` in root directory
- Open xcworkspace file and run on simulator
- To test: Product > Test