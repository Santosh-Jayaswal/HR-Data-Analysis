USE human_resource;

/*	1) 	Key Performance Indicator (KPI):
		This will give us basic overview of organisation like how many employee is working,
		count of employees who leaved, active employee and so on.
*/

SELECT
	COUNT(Employee_Name) AS Employee_Count,
    SUM(AttritionCount) AS Attrition_Count,
    ROUND(( SUM(AttritionCount) / COUNT(Employee_Name)) * 100, 2) AS Attrition_Rate,
    (COUNT(Employee_Name) - SUM(AttritionCount)) AS Active_Employee
FROM dataset;

/*	2)	List of Employee by Performance:
		We are using PerformanceScore column in order to list the employee which having these attribute,
		Exceeds, Fully Meets, Needs Improvement, and PIP. As below code returns low performance employee.
*/

SELECT
	Employee_Name,
    SpecialProjectsCount AS Did_Special_Project,
    DaysLateLast30 AS Days_Late_In_Month,
    Absences
FROM dataset
WHERE PerformanceScore = "PIP"
ORDER BY Absences DESC;

/*	3)	Attrition by Gender:
		In this programme we are going to see highest numbers of male and female 
        who leaved the organisation.
*/

SELECT
	Sex AS Gender,
    Count(Sex) AS Attrition_Count
FROM dataset
WHERE AttritionCount = 1
GROUP BY Sex;

/*	4)	Company Diversity
		Here, we ar going to see the diversity of the organisation which we can evaluate
        by looking its department scope in the combination with number of employees.
*/

Select
	Department,
    COUNT(Employee_Name) AS Employee_Count
FROM dataset
GROUP BY Department
ORDER BY Employee_Count DESC;

/*	5)	Best Recruitment Sources:
		Here, we are going to find the best source of hiring employee in the combination
        with AttritionCount which helps the organisation to make decision on hiring process.
*/

SELECT
	RecruitmentSource,
    COUNT(Employee_Name) AS Employee_Count,
    SUM(AttritionCount) AS Attrition_Count,
    ROUND((SUM(AttritionCount) / COUNT(Employee_Name)) * 100, 2) AS Attrition_Rate
FROM dataset
GROUP BY RecruitmentSource
ORDER BY Attrition_Rate DESC;

/*	6)	Attrition Count by Age Group:
		In this function, we are calculating the numbers of age group who leaved the organisation,
        so the company make an strategy and undersand the specific age group of people.
*/

SELECT
    (	SELECT COUNT(Age)
		FROM dataset
		WHERE Age BETWEEN 31 AND 40
			AND AttritionCount = 1
    ) AS 31_to_40,
    (	SELECT COUNT(Age)
		FROM dataset
		WHERE Age BETWEEN 41 AND 50 
			AND AttritionCount = 1
    ) AS 41_to_50,
    (	SELECT COUNT(Age)
		FROM dataset
		WHERE Age BETWEEN 51 AND 60 
			AND AttritionCount = 1
    ) AS 51_to_60,
    (	SELECT COUNT(Age)
		FROM dataset
		WHERE Age > 60 
			AND AttritionCount = 1
    ) AS Over_60,
    SUM(AttritionCount) AS Attrition_Count
FROM dataset
GROUP BY 31_to_40;

/*	7)	Maximum Salary of Each Department:
		This SQL code returns the max salary of each department along with thier respective
        employee name and position.
*/

SELECT
	Employee_Name,
    Position,
	Department,
    Salary
FROM dataset d1
WHERE Salary = (
					SELECT MAX(Salary)
                    FROM dataset d2
                    WHERE d2.Department = D1.Department
				)
Order BY Salary DESC;

/*	8)	Top 2 Highest Salary Employee Name of Each Department:
		This function finds the two employee of each department whose salary is more 
        than the average salary of their department. This data help stakeholder to dicide wether 
        the employee justify their higher salary in relation with PerformanceScore and SpecialProject.
*/

SELECT
	d1.Department,
    d1.Employee_Name,
    d1.Salary,
    d1.PerformanceScore,
    d1.SpecialProjectsCount AS Did_Special_Project
FROM dataset d1
WHERE (
			SELECT COUNT(*)
            FROM dataset d2
            WHERE d2.Department = d1.Department AND d2.Salary >= d1.Salary
		) <= 2
ORDER BY d1.Department, d1.Salary DESC;

/*	9)	Attrition by Marital Status
		Here we are going to see numbers of employee who leaved the organisation based on their 
        marital status, suhc as married, single or divorced.
*/

SELECT
	MaritalDesc,
    COUNT(Employee_Name),
    SUM(AttritionCount) AS Attrition_Count,
    ROUND((SUM(AttritionCount) / COUNT(Employee_Name)) * 100, 2) AS Attrition_Rate
FROM dataset
GROUP BY MaritalDesc
ORDER BY Attrition_Rate DESC;

/*	10)	Work Life Balance
		We are going to see how well employees are balancing their work-life and their productivity?
*/

SELECT
	PerformanceScore AS Performance_Parameter,
    SUM(Absences) AS Total_Absent,
    SUM(SpecialProjectsCount) AS Sp_Project_Did,
    COUNT(PerformanceScore) AS Performance_Score
FROM dataset
GROUP BY PerformanceScore
ORDER BY Performance_Score DESC