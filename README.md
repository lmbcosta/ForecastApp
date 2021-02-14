# ForecastApp
This project aims to create a weather app that consumes data from [Open Weather API](https://openweathermap.org/api)

## Requirements
* iOS 14.2

## Structure
For ForecastApp it was used a MVVM architecture in combination with functional react programming approach

Layers  | Main Responsability
----------- | -------------------
AppCoordinator | Instantiates all dependencies needed on the project dependencies
View Controller | Builds and controls different UI components for main screen
Data Source | Handles with UICollectionView interaction
ViewModels | Prepares content, and manages business logic
Service | Manages network calls to Open Weather API
Views | Renders UI content 

## External Dependencies
ForecastApp has **3** external dependencies:</p>
**[RxSwift](https://github.com/ReactiveX/RxSwift)**: Rx is a generic abstraction of computation expressed through Observable<Element> interface, which lets you broadcast and subscribe to values and other events from an Observable stream.</p>
**[SnapKit](https://github.com/SnapKit/SnapKit)**: SnapKit is a DSL to make Auto Layout easy on both iOS and OS X.</p>
**[Charts](https://github.com/danielgindi/Charts)**: Framework that allows to create beatifull charts on a easy way to iOS</p>

## Dependency Manager
For dependency management it was used Swift Package Manager (SPM).

## Considerations

- Open Weather API hourly forecast data is paid, so it wasn't used on this project. It was decided to use 5 Day / 3 Hour Forecast solution instead. So, for graph's collection data it was expected data related to the current day. The API response will only send data related with the time of the request. This means if a request is made at 9pm it will respond with only bullet point temperature for the current day. </p>

Due to a lack of time, there are some things that should be improved:
- Creation of Unit Tests
- A bit more of clarity on ForecastViewModel layer
- Adopt new UICollectionViewDiffableSource
- Improve UI

## Author
Luís Costa - lmbcosta@hotmail.com
