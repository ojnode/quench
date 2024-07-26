#  QUENCH

Migraine Level: TBD

Quench

Framework: swiftUI
Database: FireBaseFireStore(noSQL) (Online), SQlite (Offline)


Overview:

The Quench app is designed to assist users in moderating their intake of some of the most addictive substances. Currently, the app supports Alcohol, Caffeine, and Nicotine. Users can suggest additional substances to be included in future updates, with the most popular suggestions being selected for implementation 

Features:

Item
Users can select between three items and choose the percentage reduction gaol.

Social:
Users can add, message and share badges with friends.

Body Mass Index:
Using user Weight and height, BMI would be calculated and displayed to each user.

Health
Based on BMI, the user’s category is returned graphically using th ebar chart.

Progress
Results displaying increase or decrease in substance intake would be displayed
Alcohol units in drink gotten using measurements from https://www.nhs.uk/live-well/alcohol-advice/calculating-alcohol-units/
caffeine content per drink estimated using https://www.medicalnewstoday.com/articles/324986 and https://www.healthline.com/nutrition/coffee-caffeine-iron-absorption#TOC_TITLE_HDR_3


Map(future Implementation)
Based on selected items, the map would show places of high risk to the user

Rooms for Improvement
Better User Interface.
Current BMI is calculated for ages above 20 years, BMI results for ages below 20 years will be determined by specific age and gender.
Development of the same app using UIkIt.
automatic update of calculated values using onSnapShot() call realtime updates.
full offline support.

Challenges:
Swift UI: The documentation for this framework is relatively sparse because it is still in its early stages of development.
Due to its declarative programming approach, the framework imposes certain restrictions. However, this improves security and reduces breakdown.
Determining ways to reduce the loading time of the app mostly due to improper API networking. 
Calculations: researching the right formulas for accurate calculation of individual substance intake

Known Mistakes Made:
Exposing Google API key. (should know better!)
Improper committing and pushing to GitHub. 








