/**
 ** Name: Malcolm White
 ** Assignment: 3
 ** Date: February 13th, 2024
 **/


-- Business rules 

-- Villager rules 
-- A villager may live in only one village.
-- A villager may visit many tourist sites.
-- A villager must have an age, and the age must be 18 to be included in the DB.
-- A villager must have both a first and last name.
-- A villager must have a villager_id.
-- A villager can either have a job or no job.

-- Village rules 
-- A village can have many villagers.
-- A village must have a unique village_id.
-- A village must have a name.
-- A village population must be 0 or higher.
-- A village must have a zip code.
-- A village must have a measurable, positive size in square km.

-- Tourist_site rules 
-- A tourist site must have a unique site_id.
-- A tourist site must have a name.
-- A tourist site may exist inside of a village, or outside.
-- Multiple tourist sites may exist in a village.
-- A tourist site must have a category.
-- A tourist site must have both a closing and opening time.

-- Visits rules
-- A visit must be a unique instance of a villager visiting a tourist site, represented by visit_id.
-- The combination of villager_id, site_id, and visit_date must be unique.
-- A villager may visit the same tourist site multiple times a day.
-- Visit_date must be a valid date and not in the future.
-- Duration hours (the length of the stay) must be a positive integer.



-- Dropping/Deleting tables

-- Dropping the Visits table
DROP TABLE IF EXISTS Visits;

-- Dropping the Villagers table
DROP TABLE IF EXISTS Villagers;

-- Dropping the Tourist_sites table
DROP TABLE IF EXISTS Tourist_sites;

-- Dropping the Villages table
DROP TABLE IF EXISTS Villages;



-- Table creation

-- Creating Villages Table
CREATE TABLE Villages (
    village_id 			NUMERIC (4,0) NOT NULL,
    village_name 		VARCHAR(50) NOT NULL,
    population 			NUMERIC(8,0) NOT NULL,
    zip_code 			VARCHAR(6) NOT NULL,
    square_km 			DECIMAL(10, 2) NOT NULL,
	CONSTRAINT VillagePKey
		PRIMARY KEY (village_id),
	CONSTRAINT PopulationCheck
		CHECK (population > 0),
	CONSTRAINT AreaCheck
		CHECK (square_km > 0)
);

-- Creating Tourist_sites Table
CREATE TABLE Tourist_sites (
    site_id          SERIAL PRIMARY KEY,
    site_name        VARCHAR(100) NOT NULL,
    village_id       INT REFERENCES Villages(village_id),
    category         VARCHAR(50) NOT NULL,
    opening_time     TIME NOT NULL,
    closing_time     TIME NOT NULL
);

-- Creating Villagers Table
CREATE TABLE Villagers (
    villager_id      SERIAL PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    age              INT NOT NULL,
    occupation       VARCHAR(50),
    village_id       INT REFERENCES Villages(village_id)
	CONSTRAINT AgeIs18
		CHECK (age >= 18)
);

-- Creating Visits Table (Joiner Table)
CREATE TABLE Visits (
    visit_id          SERIAL PRIMARY KEY,
    villager_id       INT REFERENCES Villagers(villager_id),
    site_id           INT REFERENCES Tourist_sites(site_id),
    visit_date        DATE NOT NULL,
    duration_hours    INT NOT NULL,
    UNIQUE (villager_id, site_id, visit_date),
	CONSTRAINT VisitDateIsValid
		CHECK (visit_date <= CURRENT_DATE),
	CONSTRAINT PositiveDurationHours
		CHECK (duration_hours > 0)
);



-- Populating data

INSERT INTO Villages (village_id, village_name, population, zip_code, square_km)
VALUES 
    (1, 'Halifax', 540000, 'R2Y9F6', 547),
    (2, 'Toronto', 2440000, 'M6G3Y7', 590),
    (3, 'Chicago', 2320000, 'K7NF5G', 607),
    (4, 'Los Angeles', 7540000, 'B5L3D4', 831),
    (5, 'Berlin', 1540000, 'P9LH7U', 531);

INSERT INTO Villagers (villager_id, first_name, last_name, age, occupation, village_id)
VALUES 
    (1, 'Rence', 'Mayores', 21, 'Blacksmith', 1),
    (2, 'Hayden', 'Ploszay', 30, 'Engineer', 1),
    (3, 'Chance', 'Parker', 36, 'Welder', 3),  
    (4, 'Aaron', 'Tuason', 21, 'Powerlifter', 4),  
    (5, 'Michael', 'Fontaine', 34, 'Tax Fraudster', 2);
	
INSERT INTO Tourist_sites (site_id, site_name, village_id, category, opening_time, closing_time)
VALUES 
    (1, 'Chicago Bean', 3, 'Monument', '05:00:00', '23:00:00'),
    (2, 'Sears Tower', 3, 'Skyscraper', '08:00:00', '21:00:00'),
    (3, 'CN Tower', 2, 'Skyscraper', '08:00:00', '20:00:00'),
    (4, 'Griffith Observatory', 4, 'Observatory', '09:00:00', '17:00:00'),
    (5, 'Shedd Aquarium', 3, 'Aquarium', '09:00:00', '17:30:00');

INSERT INTO Visits (visit_id, villager_id, site_id, visit_date, duration_hours)
VALUES
	(1, 1, 3, '2023-07-23', 3),
	(2, 2, 1, '2023-09-04', 1),
	(3, 1, 4, '2024-01-20', 3),
	(4, 3, 5, '2023-01-19', 4),
	(5, 1, 3, '2023-07-24', 2),
	(6, 4, 3, '2023-07-23', 3),
	(7, 5, 2, '2024-01-20', 3),
	(8, 1, 3, '2024-02-10', 2),
	(9, 2, 3, '2023-01-08', 1),
	(10, 2, 2, '2023-06-22', 3);



/*

-- Testing check constraints for villages
-- Population > 0 Constraint
INSERT INTO Villages(village_id, village_name, population, zip_code, square_km)
VALUES (6, 'Winnipeg', -2, 'R3M1E2', 3);

-- Square_km > 0 Constraint
INSERT INTO Villages(village_id, village_name, population, zip_code, square_km)
VALUES (6, 'Winnipeg', 200000, 'R3M1E2', -3);


-- Testing check constraints for villagers
-- Villager over 18 constraint
INSERT INTO Villagers(villager_id, first_name, last_name, age, occupation, village_id)
VALUES (6, 'Underage', 'Kid', 10, 'Child', 2);


-- Testing check constraints for visits
-- Visit date isn't future date constraint
INSERT INTO Visits(visit_id, villager_id, site_id, visit_date, duration_hours)
VALUES (6, 2, 2, '2025-02-02', 3);

-- Duration hours arent less than 0 constraint
INSERT INTO Visits(visit_id, villager_id, site_id, visit_date, duration_hours)
VALUES (6, 2, 2, '2022-02-02', -2);

*/

-- Updating tables
UPDATE Villagers
SET first_name = 'Malcolm',
	last_name = 'White',
	age = '26',
	occupation = 'Software Developer',
	village_id = '1'
WHERE villager_id = 2;

UPDATE Tourist_sites
SET category = 'Tower'
WHERE site_id IN (2,3)



-- Further Testing tables

/*

-- Villagers have village names associated with them
SELECT ve.villager_id, ve.first_name, ve.last_name, v.village_name
FROM Villagers ve
INNER JOIN Villages v
ON v.village_id = ve.village_id
ORDER BY villager_id ASC;

-- Sites are visited and villagers can visit sites more than once
SELECT vi.visit_id, v.first_name, v.last_name, vi.visit_date, t.site_name, t.site_id, t.category
FROM Visits vi
JOIN Villagers v ON vi.villager_id = v.villager_id
JOIN Tourist_sites t ON t.site_id = vi.site_id;

*/







