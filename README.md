# Polestar_Code_Challenge_Vaibhav

All the requirements apart from the bonuses have been implemented. I could not get to the bonuses as time ran short.


A few notes about the code:
- The app is built using UIKit
- The app is using MVVM - C pattern to break responsibilities and increase testability
    - The app is using coordinators to break dependencies between view controllers and make them independent. The coordinator is
      responsible for initialising a viewController with all its dependencies and starting its flow
    - ViewController's responsibility is to just layout the views according to the state
    - ViewModel is responsible for fetching data using a network layer and informing the view about the results
- There is a generic network layer which is fully testable and capable of fetching data from any generic endpoint, it can be broken down as follows
    - NetworkEndpointProtocol - Encapsulates all the data an API endpoint might need. All endpoints conform to this protocol
    - APIManagerProtocol - Used to make the actual API calls to fetch data using the NetworkEndpointProtocol, this can be easily
      mocked to fetch data from a local file for unit testing networking calls
    - RequestManager - Uses an object conforming to APIManagerProtocol and decodes the fetches Data into Data models.
- Loading and error views are plugged in as childViewControllers to extract some logic out of the viewControllers
- The app handles varying lengths of text pretty well, on the search tableview cells can expand to display a long title and author name.
- To further demonstrate code reusability I have used a generic tableview datasource for the content list. It can be reused for any tableview and also extract the data source code out of the viewControllers.
- Unit tests are added covering the network layer and the viewModel including various user input validation tests!

A few notes regarding the functionality:
- App is using OpenLibrary's search API: https://openlibrary.org/dev/docs/api/search, with a basic query search
- A couple of user input validations are added if too less or too many characters are entered.
- The app handles different errors well and displays a useful message to the user
- Although it was asked to add a okay button to search, I have gone ahead with the default iOS search button on the keyboard as I felt that is more accessible to the user when typing and closely resembles the native iOS behaviour!
NOTE: If testing on a simulator, please make sure to enable the keyboard or just hit enter to search! Also note that app doesn't do a typeahead search, we need to hit the keyboard search button to search!
- The app displays the title, year and author name for the top 10 results of the search!
- The UI is kept very basic, but it still works great on both light and dark modes!

