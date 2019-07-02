/* ********************************************
Author: Nabeel Ahmed
Date: 07/01/19
SQL Challenge Q3
********************************************** */
/* *********Assumptions************ */
--Fiscal Q1= Jan - Mar, Q2= Apr - Jun,..
-- Date Handling: Date is assumed to be of the format YYYYMMDD 
-- Query is generalized to work for all years, changes to be made to the date filter as per requirement


/* Using WITH Common table expression to simplify and reduce the size of the query and avoiding brute force self join */
WITH subquery
AS (
	/* Creating a join key called Quarter_index, this will assign a number to each distinct Year_quarter after ordering the column
	   This index is required for the join logic
	*/
	SELECT ugc_id
		,Year_Quarter
		,DENSE_RANK() OVER (
			ORDER BY Year_Quarter
			) AS Quarter_index
	FROM (
		/* Query starts here************* 
		Create a base table at a ugc_id X Year_Quarter level => 1 row per customer for each quarter a purchase was made*/
		SELECT ugc_id
			,CONCAT (
				YEAR(to_date(visit_date, 'YYYYMMDD'))
				,QUARTER(to_date(visit_date, 'YYYYMMDD'))
				) AS Year_Quarter -- Creating Year_Quarter using date functions
		FROM TABLE
		WHERE to_date(visit_date, 'YYYYMMDD') BETWEEN '01/01/2017' AND '12/31/2018' -- Converting String date to date format, this filter can be changed as per requirement
			AND channel = 'DOTCOM'
		GROUP BY ugc_id
			,CONCAT (
				YEAR(to_date(visit_date, 'YYYYMMDD'))
				,Quarter(to_date(visit_date, 'YYYYMMDD'))
				)
		)
	)
/*This query will do the final calculations
Now the level of the table is Year_Quarter 
Repeat_rate is shown per quarter
 */	
SELECT Year_Quarter
	,count(ugc_id) AS total_cust
	,count(recur_flag) AS total_recur_cust
	,count(recur_flag) / count(ugc_id) AS Repeat_rate
FROM (
	/*This query will run on top of the subquery doing a self join.
	The level of the table is still ugc_id X Year_quarter
	*/
	SELECT x.Year_Quarter
		,x.ugc_id
		,y.ugc_id AS recur_flag -- This will act as a flag as to whether a customer purchased in the subsequent quarter or not
	FROM subquery x
	LEFT JOIN subquery y ON x.ugc_id = y.ugc_id
		AND x.Quarter_index = y.Quarter_index - 1 --This condition will filter through only the customers who made a purchase in the immediate next quarter also accounting for the Q4 of a year and Q1 of next year
	)
GROUP BY Year_Quarter
ORDER BY Year_Quarter;
