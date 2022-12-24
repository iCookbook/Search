# "Search" module

Module that is shown after the start of the application.

## To set up

There is no need for special set up for this module.

This module is opened at the 2nd. tab of the application and created in  [AppCoordinator](https://github.com/iCookbook/Cookbook/blob/master/Cookbook/Application/AppCoordinator.swift) 

## Dependencies

This module has 4 dependencies:

- `Common` to inherit logic from `BaseRecipes` from [Common](https://github.com/iCookbook/Common) module
- `CommonUI` for some reasons:
    * Image loader in `UIImageView`
    * Cells identifiers
    * `TitleHeaderTableView` class
- `Models` to use data models
- `Networking` to fetch recipes from the server
- `Resources` for access to resources of the application

## Screenshots

| <img src="https://user-images.githubusercontent.com/60363270/202233121-0b844ddb-f370-4703-86a6-4dcf8088c085.png" width=200> | <img src="https://user-images.githubusercontent.com/60363270/202233054-203bcf82-8bb3-4417-bf4a-79ba8ca7f961.png" width=200> | <img src="https://user-images.githubusercontent.com/60363270/202232994-b4a2aa4c-b6f9-4975-9314-5ee6fa93a561.png" width=200> |
|---|---|---|


## Data Sources

We have implemented 2 classes responsible for data source for the reason that we have 2 table views on the `SearchViewController`:

- `SearchCategoriesTableViewDataSource`
- `SearchRequestsTableViewDataSource`

They implement the delegate methods and use the view reference to pass the delegate methods from the table:

- `SearchCategoriesTableViewDataSourceDelegate`
- `SearchRequestsTableViewDataSourceDelegate`
