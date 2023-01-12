/* Question: Assume you are given the table below that shows job postings for all companies on the LinkedIn platform. Write a query to get the number of companies that have posted duplicate job listings.

job_listings Table:
Column Name	Type
job_id	integer
company_id	integer
title	string
description	string



Answer:
To start off we would need to find all the companies that have listed the jobs with same title and its description. A simple way to do that would be to use the COUNT function on job_id grouped by the company_id and description. */


SELECT
	company_id,
	title,
	description,
	COUNT(job_id) AS job_count
FROM job_listings
GROUP BY
	company_id,
	title,
	description;


/* We will now filter the query for when job_count is more than 1. This would essentially mean that we only want where there are 2 or more duplicate job listings. After that, we apply DISTINCT on company_id to get the unique company_id and we count them. That should give us an integar that represents the number the duplicate job listings there are. */


SELECT COUNT(DISTINCT company_id) AS duplicate_jobs
FROM (
	SELECT
	company_id,
title,
	description,
	COUNT(job_id) AS job_count
FROM job_listings
GROUP BY
	company_id,
	title,
	description) AS jobs_grouped
WHERE job_count > 1;



