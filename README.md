# Computer Science Projects

These projects were created as part of [Codecademy's](https://www.codecademy.com) Computer Science Career Path course. (Latest projects are added to the top of the list.)

## Table of contents

- Math For Computer Science
- Computer Architecture
- Databases
- Trees And Graphs
- Algorithms
- Intro To DataStructures
- [Intro To Programming](#intro-to-programming)
  - [Scrabble](#scrabble)
  - [Thread Shed](#thread-shed)
  - [The Bored Tourist](#the-bored-tourist)
  - [Getting Ready For Physics Class](#getting-ready-for-physics-class)
  - [Carly's Clippers](#carlys-clippers)
  - [Len's Slice](#lens-slice)
  - [Gradebook](#gradebook)
  - [Sal's Shipping](#sals-shipping)
  - [Magic 8-Ball](#magic-8-ball)
- [Other](#other)
  - [Author](#author)

# Intro To Programming

## Scrabble

The aim of this project was to create a Python program that processes some data from a group of friends playing scrabble. Dictionaries are used to organise players, words and points.

- List comprehension used to create a dictionary from two provided lists of letters and their points.

  ```python
  letters_to_points = {key:value for key, value in zip(letters, points)}
  ```

- Functions defined to:

  - `play_word()` adds a new word played by a player.

    - Sets `word.upper()` as letters in letters_to_points dictionary are all uppercase.
    - Sets `player.title()` so that if names are entered differently with lowercase or uppercase letters they will still match when compared to `player_to_words` dictionary.
    - If player already exists, word is added to their played list in player_to_words dictionary.
    - If player doesn't exist, then the new player along with their word is added to player_to_words dictionary.
    - Calls `update_point_totals` function.

  - `update_point_totals()` updates the total points scored for the player.

    - Calls `score_word` function.
    - If player already exists, points are added to their total score in player_to_points dictionary.
    - If player doesn't exist, then the new player along with their score is added to player_to_points dictionary.

  - `score_word()` calculates and returns the points score of a word.

  - `play_round` initialises the program.

    - Gets player name and word from user.
    - Calls `play_word` function.
    - Calls `another_round` function.

  - `another_round()` asks user whether they wish to enter another player's word.

    - Gets Y/N input from user. Input changed to uppercase.
    - If response is `Y` or `YES`, then calls `play_round()`.
    - If response not `Y` or `YES`, then calls `show_results()`.

  - `show_results()` iterates through `player_to_points` dictionary to print out names and total scores of each player.

### Code & Potential Improvements

- Solution URL: [Scrabble](./intro_to_programming/scrabble.py)
  - Remove hardcoded player's data and ask for input of name and word from user - ADDED TO CODE.
  - Check whether more words to be added and scored - ADDED TO CODE.
  - Show results of players in formatted strings - ADDED TO CODE.

## Thread Shed

The aim of this project was to create a Python program that takes a list of sales information in a string format (customer name, price, colour(s) of thread purchased and date), and then use a variety of techniques to clean up the data into easier-to-access information.

- `string.replace()` used to help with clarifying appropriate sales transaction.
- `string.split()` used to help split up string into appropriate sections.
- `string.strip()` used to clear up and remove whitespace in transaction information.
- `for` loops used to iterate through lists of transactions.
- `list.append` to add information into smaller appropriate groups of lists e.g. customers, sales price and colour of thread purchased.
- Function defined to calculate the total numbers sold for each colour thread.
- `print` and `.format()` used to print out a formatted string of the number of each colour thread purchased.

### Code & Potential Improvements

- Solution URL: [Thread Shed](./intro_to_programming/thread_shed.py)

## The Bored Tourist

The aim of this project was to create a Python program that uses functions to create a recommendation program based on the traveler's location and their interests (e.g. museum, beach etc) for suggesting appropriate places for them to visit.

- Functions defined to:
  - Get index of destination from list of destinations.
  - Get traveler location.
  - Add attractions for each location.
  - Find all attractions for a particular destination.
  - Get attractions for traveler (based on their location and interests).
- Print out list of suitable attractions to visit for the traveler.
- Values to test the program are all hardcoded into the program.

### Code & Potential Improvements

- Solution URL: [The Bored Tourist](./intro_to_programming/the_bored_tourist.py)
  - Have the user enter their details - name, traveler location and interests.
  - Be able to update lists of locations and attractions interactively.

## Getting Ready For Physics Class

The aim of this project was to create a Python program that uses functions and `return` to help calculate some fundamental physics properties.

- Functions defined to calculate:
  - Fahrenheit to Celsius temperatures
  - Celsius to Fahrenheit temperatures
  - Force
  - Energy
  - Work
- Values to test the program are hardcoded into the program.

### Code & Potential Improvements

- Solution URL: [Getting Ready For Physics Class](./intro_to_programming/getting_ready_physics_class.py)
  - Have the user choose which physics property to calculate.
  - Have the user enter appropriate values for the physics property they have chosen to calculate.

## Carly's Clippers

The aim of this project was to create a Python program that calculates some metrics from lists of data.

- Lists of hairstyles, prices and last week's sales are hardcoded into the program.
- `for`, list comprehensions, `range()`, `len()` and `if` are used to calculate average prices, decreased prices, total revenue, average daily revenue and types of haircuts that cost less than £30.

### Code & Potential Improvements

- Solution URL: [Carly's Clippers](./intro_to_programming/carlys_clippers.py)

## Len's Slice

The aim of this project was to create a Python program that takes pizzas and their prices using lists and alters the lists to organise the data.

- 2D lists of pizzas and prices are hardcoded into the program.
- `list.count(item)` used to count how many pizzas are $2.
- `len(list)` used to count the number of different kinds of pizzas.
- `list.sort()` to sort the list in ascending order of price.
- `list.pop()` to remove the most expensive pizza.
- `list.insert(index, item)` to add a new pizza in appropriate position to keep price sorted in list.
- `list[:3]` to find the cheapest three pizzas.

### Code & Potential Improvements

- Solution URL: [Len's Slice](./intro_to_programming/lens_slice.py)

## Gradebook

The aim of this project was to create a Python program that takes student data and organizes subjects and grades using lists.

- 2D lists of subjects and grades are hardcoded into the program.
- `list.append(item)`, `list[index].remove(item)` are used to alter subjects and grades and `print()` out gradebook information to the user.

### Code & Potential Improvements

- Solution URL: [Gradebook](./intro_to_programming/gradebook.py)
  - Have the user input the initial subjects and grades.
  - Have the user be able to alter subjects and grades.

## Sal's Shipping

The aim of this project was to create a Python program that asks the user for the weight of their package and then tells them which method of shipping is cheapest and how much it will cost to ship their package using Sal’s Shippers.

- `weight` variable is hardcoded into the program.
- `if`, `elif` and `else` used to calculate cost shipping and `print()` out costs.

### Code & Potential Improvements

- Solution URL: [Sal's Shipping](./intro_to_programming/shipping.py)
  - Have the user input the packages weight.

## Magic 8-Ball

The aim of this project was to create a Python program that can answer any "Yes" or "No" question with a different fortune each time it executes.

- `name` and `question` variables are hardcoded into the program.
- `random` module with `randint()` used to generate a random number within a specified range.
- `if`, `elif` and `else` used to select answers and `print()` out appropriate response.

### Code & Potential Improvements

- Solution URL: [Magic 8-Ball](./intro_to_programming/magic-8.py)
  - Have the user input their name and question.

# Other

## Author

- V. Tickner
