/* Welcome to the SQL mini project. You will carry out this project partly in
the PHPMyAdmin interface, and partly in Jupyter via a Python connection.

This is Tier 1 of the case study, which means that there'll be more guidance for you about how to 
setup your local SQLite connection in PART 2 of the case study. 

The questions in the case study are exactly the same as with Tier 2. 

PART 1: PHPMyAdmin
You will complete questions 1-9 below in the PHPMyAdmin interface. 
Log in by pasting the following URL into your browser, and
using the following Username and Password:

URL: https://sql.springboard.com/
Username: student
Password: learn_sql@springboard

The data you need is in the "country_club" database. This database
contains 3 tables:
    i) the "Bookings" table,
    ii) the "Facilities" table, and
    iii) the "Members" table.

In this case study, you'll be asked a series of questions. You can
solve them using the platform, but for the final deliverable,
paste the code for each solution into this script, and upload it
to your GitHub.

Before starting with the questions, feel free to take your time,
exploring the data, and getting acquainted with the 3 tables. */


/* QUESTIONS 
/* Q1: Some of the facilities charge a fee to members, but some do not.
Write a SQL query to produce a list of the names of the facilities that do. */

SELECT `name` FROM `Facilities` WHERE `membercost` > 0;

name	
Tennis Court 1	
Tennis Court 2	
Massage Room 1	
Massage Room 2	
Squash Court	


/* Q2: How many facilities do not charge a fee to members? */

ANSWER: 4
QUERY: SELECT COUNT(*) FROM `Facilities` WHERE `membercost` = 0;

/* Q3: Write an SQL query to show a list of facilities that charge a fee to members,
where the fee is less than 20% of the facility's monthly maintenance cost.
Return the facid, facility name, member cost, and monthly maintenance of the
facilities in question. */

QUERY: SELECT `facid`,`name`,`membercost`,`monthlymaintenance` FROM `Facilities` WHERE `membercost` > 0 AND `membercost` < (.20 * `monthlymaintenance`);

facid	name	membercost	monthlymaintenance	
0	Tennis Court 1	5.0	200	
1	Tennis Court 2	5.0	200	
4	Massage Room 1	9.9	3000	
5	Massage Room 2	9.9	3000	
6	Squash Court	3.5	80	

/* Q4: Write an SQL query to retrieve the details of facilities with ID 1 and 5.
Try writing the query without using the OR operator. */

QUERY: SELECT * FROM `Facilities` WHERE `name` LIKE "%2";

facid	name	membercost	guestcost	initialoutlay	monthlymaintenance	expense_label	
1	Tennis Court 2	5.0	25.0	8000	200	NULL	
5	Massage Room 2	9.9	80.0	4000	3000	NULL	


/* Q5: Produce a list of facilities, with each labelled as
'cheap' or 'expensive', depending on if their monthly maintenance cost is
more than $100. Return the name and monthly maintenance of the facilities
in question. */

QUERY: SELECT `name`, `monthlymaintenance`, CASE WHEN `monthlymaintenance` <= 100 THEN 'cheap' ELSE 'expensive' END AS cost_category FROM `Facilities`;


SELECT `name`, 
       `monthlymaintenance`, 
       CASE 
           WHEN `monthlymaintenance` <= 100 THEN 'cheap' 
           ELSE 'expensive' 
       END AS cost_category
FROM `Facilities`;


name	monthlymaintenance	cost_category	
Tennis Court 1	200	expensive	
Tennis Court 2	200	expensive	
Badminton Court	50	cheap	
Table Tennis	10	cheap	
Massage Room 1	3000	expensive	
Massage Room 2	3000	expensive	
Squash Court	80	cheap	
Snooker Table	15	cheap	
Pool Table	15	cheap	



/* Q6: You'd like to get the first and last name of the last member(s)
who signed up. Try not to use the LIMIT clause for your solution. */


QUERY: SELECT `firstname`,`surname` FROM `Members` ORDER BY `joindate` DESC LIMIT 1;

Darren	Smith	

(I tried multiple attempts at getting the answer without using LIMIT, but none of them worked)


/* Q7: Produce a list of all members who have used a tennis court.
Include in your output the name of the court, and the name of the member
formatted as a single column. Ensure no duplicate data, and order by
the member name. */


SELECT DISTINCT CONCAT(m.firstname, ' ', m.surname) AS member_name, f.name AS court_name
FROM `Members`AS m
INNER JOIN `Bookings` AS b
ON m.memid = b.memid
INNER JOIN `Facilities` AS f
ON b.facid = f.facid
WHERE f.name LIKE '%Tennis Court%'
ORDER BY member_name;


member_name   	court_name	
Anne Baker	Tennis Court 2	
Anne Baker	Tennis Court 1	
Burton Tracy	Tennis Court 1	
Burton Tracy	Tennis Court 2	
Charles Owen	Tennis Court 1	
Charles Owen	Tennis Court 2	
Darren Smith	Tennis Court 2	
David Farrell	Tennis Court 1	
David Farrell	Tennis Court 2	
David Jones	Tennis Court 1	
David Jones	Tennis Court 2	
David Pinker	Tennis Court 1	
Douglas Jones	Tennis Court 1	
Erica Crumpet	Tennis Court 1	
Florence Bader	Tennis Court 2	
Florence Bader	Tennis Court 1	
Gerald Butters	Tennis Court 2	
Gerald Butters	Tennis Court 1	
GUEST GUEST	Tennis Court 2	
GUEST GUEST	Tennis Court 1	
Henrietta Rumney	Tennis Court 2	
Jack Smith	Tennis Court 1	
Jack Smith	Tennis Court 2	
Janice Joplette	Tennis Court 2	
Janice Joplette	Tennis Court 1	



/* Q8: Produce a list of bookings on the day of 2012-09-14 which
will cost the member (or guest) more than $30. Remember that guests have
different costs to members (the listed costs are per half-hour 'slot'), and
the guest user's ID is always 0. Include in your output the name of the
facility, the name of the member formatted as a single column, and the cost.
Order by descending cost, and do not use any subqueries. */


SELECT 
f.name, 
CONCAT(m.surname, ', ', m.firstname) AS member_name,
CASE 
	WHEN b.memid != 0 THEN (f.membercost * b.slots)
	ELSE (f.guestcost * b.slots) 
    END AS 'cost'
FROM Bookings AS b
INNER JOIN Facilities AS f USING (facid)
INNER JOIN Members AS m USING (memid)
WHERE b.starttime LIKE '2012-09-14%'
AND ((b.memid != 0 AND f.membercost * b.slots > 30) OR (b.memid = 0 AND f.guestcost * b.slots > 30))
ORDER BY cost DESC;


name	member_name	cost   	
Massage Room 2	GUEST, GUEST	320.0	
Massage Room 1	GUEST, GUEST	160.0	
Massage Room 1	GUEST, GUEST	160.0	
Massage Room 1	GUEST, GUEST	160.0	
Tennis Court 2	GUEST, GUEST	150.0	
Tennis Court 1	GUEST, GUEST	75.0	
Tennis Court 1	GUEST, GUEST	75.0	
Tennis Court 2	GUEST, GUEST	75.0	
Squash Court	GUEST, GUEST	70.0	
Massage Room 1	Farrell, Jemima	39.6	
Squash Court	GUEST, GUEST	35.0	
Squash Court	GUEST, GUEST	35.0	



/* Q9: This time, produce the same result as in Q8, but using a subquery. */


SELECT CONCAT(m.firstname, ' ', m.surname) AS member_name,
       f.name AS facility_name,
       CASE 
           WHEN b.memid != 0 THEN f.membercost * b.slots
           ELSE f.guestcost * b.slots
       END AS cost
FROM (
    SELECT *
    FROM Bookings
    WHERE starttime LIKE '2012-09-14%'
) AS b
INNER JOIN Facilities AS f
ON b.facid = f.facid
LEFT JOIN Members AS m
ON b.memid = m.memid
WHERE (
    (b.memid = 0 AND f.guestcost * b.slots > 30) 
    OR 
    (b.memid != 0 AND f.membercost * b.slots > 30)
)
ORDER BY cost DESC;


member_name	facility_name	cost   	
GUEST GUEST	Massage Room 2	320.0	
GUEST GUEST	Massage Room 1	160.0	
GUEST GUEST	Massage Room 1	160.0	
GUEST GUEST	Massage Room 1	160.0	
GUEST GUEST	Tennis Court 2	150.0	
GUEST GUEST	Tennis Court 1	75.0	
GUEST GUEST	Tennis Court 1	75.0	
GUEST GUEST	Tennis Court 2	75.0	
GUEST GUEST	Squash Court	70.0	
Jemima Farrell	Massage Room 1	39.6	
GUEST GUEST	Squash Court	35.0	
GUEST GUEST	Squash Court	35.0	


/* PART 2: SQLite
/* We now want you to jump over to a local instance of the database on your machine. 

Copy and paste the LocalSQLConnection.py script into an empty Jupyter notebook, and run it. 

Make sure that the SQLFiles folder containing thes files is in your working directory, and
that you haven't changed the name of the .db file from 'sqlite\db\pythonsqlite'.

You should see the output from the initial query 'SELECT * FROM FACILITIES'.

Complete the remaining tasks in the Jupyter interface. If you struggle, feel free to go back
to the PHPMyAdmin interface as and when you need to. 

You'll need to paste your query into value of the 'query1' variable and run the code block again to get an output.
 
QUESTIONS:
/* Q10: Produce a list of facilities with a total revenue less than 1000.
The output of facility name and total revenue, sorted by revenue. Remember
that there's a different cost for guests and members! */

2.6.0
2. Query all tasks
('Table Tennis', 180)
('Snooker Table', 240)
('Pool Table', 270)

^^^ Here's the answer from Jupyter notebook.

Here's the query 1 variable code from Jupyter notebook:
SELECT f.name AS facility_name,
       SUM(
           CASE 
               WHEN b.memid = 0 THEN f.guestcost * b.slots
               ELSE f.membercost * b.slots
           END
       ) AS total_revenue
FROM Facilities f
INNER JOIN Bookings b
ON f.facid = b.facid
LEFT JOIN Members m
ON b.memid = m.memid
GROUP BY f.name
HAVING total_revenue < 1000
ORDER BY total_revenue;

/* Q11: Produce a report of members and who recommended them in alphabetic surname,firstname order */

SELECT CONCAT(m1.surname, ', ', m1.firstname) AS member_name,
       CONCAT(m2.surname, ', ', m2.firstname) AS recommender_name
FROM Members m1
LEFT JOIN Members m2
ON m1.recommendedby = m2.memid
ORDER BY m1.surname, m1.firstname;

^^This code for self-join works in the phpMyAdmin portal. For some reason my Jupyter notebook wouldn't recognize CONCAT. So I pasted the code into markdown in that notebook and included the first 25 rows of report.


/* Q12: Find the facilities with their usage by member, but not guests */

2.6.0
2. Query all tasks
('Badminton Court', 1086)
('Tennis Court 1', 957)
('Massage Room 1', 884)
('Tennis Court 2', 882)
('Snooker Table', 860)
('Pool Table', 856)
('Table Tennis', 794)
('Squash Court', 418)
('Massage Room 2', 54)

^^^Here's the answer from Jupyter Notebook.
Here's the query 1 variable code from Jupyter notebook:

SELECT f.name AS facility_name,
       SUM(b.slots) AS usage_by_member
FROM Facilities f
INNER JOIN Bookings b
ON f.facid = b.facid
INNER JOIN Members m
ON b.memid = m.memid
WHERE b.memid != 0
GROUP BY f.name
ORDER BY usage_by_member DESC;


/* Q13: Find the facilities usage by month, but not guests */


SELECT f.name AS facility_name,
       YEAR(b.starttime) AS year,
       MONTH(b.starttime) AS month,
       SUM(b.slots) AS usage_by_member
FROM Facilities f
INNER JOIN Bookings b
ON f.facid = b.facid
INNER JOIN Members m
ON b.memid = m.memid
WHERE b.memid != 0
GROUP BY f.name, year, month
ORDER BY year, month, usage_by_member DESC;

^^This code works in the phpMyAdmin portal. For some reason my Jupyter notebook wouldn't recognize YEAR(). So I pasted the code into markdown in that notebook and included the first 25 rows of report.


