# Device-Agnostic Design Course Project II: Recipe App

A simple cross-platform and responsive recipe app built with Flutter and Firebase.
View the app [here](https://evelynbirnzain.github.io/recipe-app/).

## Description

"Recipe App" is a responsive Flutter application that allows users to browse recipes. Recipes can be searched by name
and filtered by category. Users can also log in to the app, so that they can save their favorite recipes and create and
manage their own recipes.

The application uses Flutter to create a responsive UI that works on both mobile and desktop devices. The application
uses Firebase/Firestore for authentication and for storing recipe data.


## Challenges

* Infinite scroll: It took me quite a while to implement infinite scrolling. I think the infinite_scroll_pagination
  package seems relatively straightforward, but I wasn't sure how to best integrate pagination with the recipe provider
  that I already had and how to keep data consistent. I think the main problem here was that I was using a pretty
  generic solution for the recipe list and provider, which I used for both search results, recipes by category, and
  favorited recipes, which meant a lot of refreshing, navigating back and forth between pages, and opened up many
  possibilities for data inconsistency.
* State management: Overall, I flip-flopped back and forth between different state management approaches quite a bit
  and, like in the first project, ended up with a bit of an odd mix that doesn't seem very clean. But I think it works
  for now.
* Responsive design: Even though my solution isn't super responsive anyway it took a lot of time to think about and
  implement all the small changes between mobile and desktop layout that may or may not have been necessary. But surely
  it would be a lot more time consuming to develop separate applications for desktop and mobile still; at least here the
  logic stays the same.

## Learning moments

* State management: I think I overall started to understand better how state management works in Flutter and surely what
  doesn't work well.
* Firebase: It was fun setting up the Firebase project and using that sort of backend. My previous experience was
  strictly with home brewed full-stack applications, so it was interesting to see in what cases it may be unnecessary to
  build everything from scratch.
* Refactoring and deciding when it's enough: I spent a bunch of time trying to refactor my code into a cleaner approach
  that ended up not working out along the way anyway. So I think one learning would be that it's not always worth it
  spending time reworking the same thing, when what you have already works anyway.

## Database 
There are two collections in the database: categories and recipes.

### Categories
* id (auto-generated)
* name: String

### Recipes
* id (auto-generated)
* name: String
* category: Reference to a category
* ingredients: List of Strings
* steps: List of Strings
* author: String, i.e. uid
* favorites: List of Strings, i.e. uids of the users who have favorited the recipe

## Dependencies

```yaml
name: dad_2
description: A new Flutter project.
publish_to: 'none'
version: 1.0.0+1

environment:
  sdk: '>=3.1.2 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.2
  firebase_core: ^2.17.0
  cloud_firestore: ^4.9.3
  go_router: ^11.1.2
  flutter_riverpod: ^2.4.3
  firebase_auth: ^4.11.1
  multiselect: ^0.1.0
  infinite_scroll_pagination: ^4.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0

flutter:
  uses-material-design: true
```