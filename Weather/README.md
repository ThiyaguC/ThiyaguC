#Thiyagu Chandran
API details - openweather.org(currentWeather data)
Pattern - MVVM (As API response is not compatible for mobile platform UI. I have used MVVM pattern to customise the response(Weather Model) to ViewModel. So that value can be easily populated in Mobile UI )
DataBase - CoreData(Persistent database) to store the favourite city and its temperature. The value can be viewed later
DashBoard - To search the weather for the requested city. There is favourite button to the city to the favourite city and its detail to the favourite list. Header view to display the tempeature and city details. TableView is used to display the rest of the weather details.
Favourite View - It display the favourite cities temperature in tableview
Favourite Button - Used to add/remove the favourite cities from the list


