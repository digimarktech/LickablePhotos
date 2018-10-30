# Lickable Photos

This is a basic app that consumes photo data from the jsonplaceholder API and displays it in a collection view.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

### Prerequisites

What things you need to install the software and how to install them


* [Cocoapods](https://cocoapods.org) - Dependency Management
* [Xcode](https://developer.apple.com/xcode/) - IDE to build and run project

### Pods Used In This Project

* [SDWebImage](https://github.com/SDWebImage/SDWebImage) - Asynchronous image downloader with cache support as a UIImageView category
* [Lottie](https://github.com/airbnb/lottie-ios) - An iOS library to natively render After Effects vector animations 


### Installing

To run the project, navigate to the project directory where project is stored and install the pods associated with this project

Type in following command at command line

```
pod install
```


Once this is complete be sure to use project file ending in xcworkspace

## Running the tests

Use the following command in the terminal to execute the Unit Tests

```
cmd + u
```

## Project Structure

The project has 2 major view controllers. `PhotoVC` is the first screen users land on after launching the app. This contains a collection of all of the photos download from the JSONPlacehoder endpoint.

`PhotoDetailVC` is the screen that users land on after selecting one of the photos from the first screen.

This project uses the [MVC-N](https://academy.realm.io/posts/slug-marcus-zarra-exploring-mvcn-swift/) design pattern. 

The network layer uses a class called `APIRequestLoader` to make requests to the JSONPlacholder API to get data. 

To create a new request, conform to the `APIRequest` protocol

```
protocol APIRequest {
	associatedtype ResponseDataType
	
	func makeRequest() throws -> URLRequest
	func parseResponse(data: Data) throws -> ResponseDataType
}
```
Use the `makeRequest` method to build your url via [URLComponents](https://developer.apple.com/documentation/foundation/urlcomponents). From here you use the `parseResponse(data:Data)` method to parse the response coming back. See the example below of the `PhotoRequest` that we use to downloads the photos used in this project

```
struct PhotoRequest: APIRequest {
	
	func makeRequest() throws -> URLRequest {
		let components = URLComponents(string: "http://jsonplaceholder.typicode.com/photos/")!
		return URLRequest(url: components.url!)
	}
	
	func parseResponse(data: Data) throws -> [Photo] {
		return try JSONDecoder().decode([Photo].self, from: data)
	}
}
```

## Authors

* **Marc Aupont** - *Initial work* - [digimarktech](https://github.com/digimarktech)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details


