# DataAnalytics-Assessment

**Assessment_Q1**

So, for this one, I basically wanted to get a good overview of each customer. What I did was figure out 
how many regular savings and investment plans each person has. Then, I added up all the confirmed 
deposits they've made. To keep things organized, I broke it down into smaller steps – looking at their 
savings, then their investments, then their deposits, and also making sure I handled their names 
correctly. If a customer had the same name listed a few times, I only counted it once. Finally, I put 
all this info together in a list, and to make it easy to see who the big names are, I sorted it by 
the total deposits, with the highest ones showing up first.

**Assessment_Q2**

With this query, I was trying to understand how active our customers are on a monthly basis. First, I 
calculated how many transactions each person made in each month. Then, I found the average of those 
monthly counts for each customer. After that, I decided to categorize each customer into groups – High, 
Medium and Low activity – based on their average. To wrap it up, I counted how many customers fell into 
each of these activity levels and what their average transaction rate was. I then presented this 
information, ordered from the most active group to the least active.

**Assessment_Q3**

Here, the idea was to pinpoint the savings or investment plan that each customer hasn't used in the 
longest time. The way I did this was by calculating the number of days since the last transaction for 
each plan. I used a step-by-step approach: first, I got the latest transaction date across the board, 
then I figured out the last activity date for each specific plan, and finally, I calculated the 
difference in days to see how inactive they were. For each customer, I then ranked their plans based on 
this inactivity, and I only picked out the one that had been inactive for the longest. I used DATEDIFF()
to calculate the days, CROSS JOIN for combining, and CASE statements to create those categories.

**Assessment_Q4**

For this one, I took on the task of estimating how much value each customer might bring in over their 
entire relationship with us. To do this, I looked at their past transaction history. My first step was 
to find the most recent transaction date for all customers. Then, for each customer, I calculated how 
long they've been with and how many transactions they've made in total, and the average value of each 
of their transactions. Using these pieces of information, I then used a provided formula to calculate 
their CLV, essentially projecting their annualized transaction behavior. If I noticed any duplicate customer 
names, I made sure to only consider the first instance. Lastly, I compiled a list of all our customers, 
ranked by their estimated lifetime value, with the highest-value customers at the very top.

