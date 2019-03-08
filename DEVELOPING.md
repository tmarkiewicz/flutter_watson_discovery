# Project Structure

Below is a general overview of the most important directories and files in the project.

```
├── android # All the native Android code for the project
├── ios # All the native iOS code for the project
├── lib # Folder for the custom source files
│   ├── main.dart # Loads main class and makes request to Watson Discovery API, returning the results as a Card widget
│   ├── insights.dart # Displays enriched text returned by Discovery and displays results as a ListTile widget
├── pubspec.yml # Config file containing dependencies and config
```
