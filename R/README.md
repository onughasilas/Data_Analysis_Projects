# Car Sales Data Analysis Report
## 1. Objective
The purpose of this analysis is to explore the car sales dataset, understand the distribution of sales, pricing patterns, and performance indicators, and provide actionable recommendations based on the insights derived from the data.

## 2. Dataset Overview
The dataset consists of 16 columns and 157 rows, with various attributes related to cars, including:
* Manufacturer
* Model
* Sales_in_thousands: The number of sales (in thousands).
* Price_in_thousands: The price of the car (in thousands).
* Vehicle_type: The type of vehicle (e.g., SUV, Sedan).
* Horsepower: The power of the car’s engine.
* Fuel_efficiency: The fuel consumption of the car.
## 3. Data Preparation
## Steps:
## Load the data:

I loaded the dataset into R using the read.csv() function.
## Data cleaning:
I checked the structure of the dataset to ensure that all data types were appropriate (e.g., numeric columns being correctly recognized as numbers).
I also checked for missing values using the sum(is.na()) function and confirmed that no missing values were found. If there had been missing data, I would have handled it either by removal or imputation.
## Exploratory Data Analysis (EDA):
I used basic R functions like summary() to get descriptive statistics (such as mean, median, and range) for key numeric variables like sales, price, and horsepower.
I counted the number of cars by vehicle type using table() to understand the distribution of vehicle categories in the dataset.
# 4. Findings from Data Exploration
## 4.1 Sales Distribution
* What I did: I used a histogram to visualize the distribution of car sales (Sales_in_thousands).
* Insight: Most car models sell in the lower range (below 50,000 units), with a few models having sales significantly higher than the average. This suggests a few "best-selling" cars drive a large portion of the overall sales, while the majority sell in smaller quantities.
* 
  ```r
hist(car_sales$Sales_in_thousands, main = "Distribution of Car Sales", 
     xlab = "Sales in Thousands", col = "lightblue", border = "black")```
  
## 4.2 Price vs Sales Relationship
* What I did: I created a scatterplot to explore how the price of a car impacts sales (Price_in_thousands vs. Sales_in_thousands).
* Insight: There seems to be an inverse relationship between price and sales—less expensive cars tend to have higher sales, while more expensive models sell less. This trend aligns with consumer affordability, where lower-priced vehicles attract more buyers.

plot(car_sales$Price_in_thousands, car_sales$Sales_in_thousands, 
     main = "Car Price vs Sales", xlab = "Price in Thousands", 
     ylab = "Sales in Thousands", col = "blue", pch = 19)

## 4.3 Sales by Vehicle Type
* What I did: I summed the total sales for each vehicle type using a bar plot to see which categories are performing the best.
* Insight: SUVs and Sedans make up the bulk of the sales, with SUVs leading slightly. This indicates that SUVs may currently be the preferred vehicle type in the market.
  barplot(tapply(car_sales$Sales_in_thousands, car_sales$Vehicle_type, sum), 
        main = "Total Sales by Vehicle Type", xlab = "Vehicle Type", 
        ylab = "Total Sales in Thousands", col = "green")
## 4.4 Average Price and Horsepower by Vehicle Type
* What I did: I calculated the average price and horsepower for each vehicle type to see if certain types are generally more expensive or more powerful.
* Insight: SUVs and Sports cars have the highest average prices, while Trucks and Sedans tend to be more affordable. As expected, Sports cars have the highest horsepower, followed by SUVs.

  ### Average price by vehicle type
aggregate(Price_in_thousands ~ Vehicle_type, data = car_sales, FUN = mean)

### Average horsepower by vehicle type
aggregate(Horsepower ~ Vehicle_type, data = car_sales, FUN = mean)

## 5. Recommendations
Based on the findings from the data, I propose the following recommendations:
* Focus on SUV Production and Marketing:
Since SUVs show higher sales than other types, focusing on expanding the SUV lineup and targeting the marketing efforts toward this segment could yield significant returns.
* Competitive Pricing for Sedans:
Sedans are still a popular vehicle type but face stiff competition from SUVs. By optimizing the pricing strategy for Sedans, it may be possible to improve sales without significant reductions in margins.
* Leverage Fuel Efficiency for Marketing:
Many consumers today are concerned with fuel efficiency. Highlighting the fuel efficiency of certain car models, especially SUVs and Sedans with higher-than-average fuel efficiency, could attract more environmentally conscious buyers.
* Sports Cars and Niche Markets:
While Sports cars have higher horsepower and price, they constitute a smaller portion of overall sales. It may be beneficial to continue treating them as niche products, focusing on luxury or performance markets rather than mainstream consumers.
## 6. Conclusion
This analysis of the car sales dataset has provided valuable insights into how different vehicle types perform in terms of sales, pricing, and horsepower. By leveraging the findings and recommendations outlined above, we can focus efforts on high-performing segments like SUVs and optimize pricing strategies for other types like Sedans. This data-driven approach will help in aligning production, marketing, and pricing strategies with market demand.


