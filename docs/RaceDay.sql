/* ============================================================
   RaceDay System
   Part 1 - Database SQL Script
   ============================================================ */

USE master;
GO

/* ============================================================
   CREATE A FRESH RACEDAY DATABASE
   ============================================================ */

IF DB_ID('RaceDay') IS NOT NULL
BEGIN
    ALTER DATABASE RaceDay SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE RaceDay;
END;
GO

CREATE DATABASE RaceDay;
GO

USE RaceDay;
GO

/* ============================================================
   1. ORGANISERS
   ============================================================ */

CREATE TABLE Organisers
(
    OrganiserID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    PasswordHash NVARCHAR(255) NOT NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Organisers
        PRIMARY KEY (OrganiserID),

    CONSTRAINT UQ_Organisers_Email
        UNIQUE (Email)
);
GO

/* ============================================================
   2. PARTICIPANTS
   ============================================================ */

CREATE TABLE Participants
(
    ParticipantID INT IDENTITY(1,1) NOT NULL,
    FirstName NVARCHAR(50) NOT NULL,
    LastName NVARCHAR(50) NOT NULL,
    Email NVARCHAR(150) NOT NULL,
    Phone NVARCHAR(30) NULL,
    DateOfBirth DATE NULL,
    CreatedAt DATETIME2 NOT NULL DEFAULT GETDATE(),

    CONSTRAINT PK_Participants
        PRIMARY KEY (ParticipantID),

    CONSTRAINT UQ_Participants_Email
        UNIQUE (Email)
);
GO
/* ============================================================
   3. VENUES
   ============================================================ */

CREATE TABLE Venues
(
    VenueID INT IDENTITY(1,1) NOT NULL,
    VenueName NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    City NVARCHAR(100) NOT NULL,

    CONSTRAINT PK_Venues
        PRIMARY KEY (VenueID)
);
GO

/* ============================================================
   4. EVENTS
   ============================================================ */

CREATE TABLE Events
(
    EventID INT IDENTITY(1,1) NOT NULL,
    OrganiserID INT NOT NULL,
    VenueID INT NOT NULL,
    EventName NVARCHAR(150) NOT NULL,
    EventDescription NVARCHAR(500) NULL,
    EventDate DATE NOT NULL,
    RegistrationDeadline DATE NOT NULL,
    Status NVARCHAR(30) NOT NULL DEFAULT 'Open',

    CONSTRAINT PK_Events
        PRIMARY KEY (EventID),

    CONSTRAINT FK_Events_Organisers
        FOREIGN KEY (OrganiserID)
        REFERENCES Organisers(OrganiserID),

    CONSTRAINT FK_Events_Venues
        FOREIGN KEY (VenueID)
        REFERENCES Venues(VenueID),

    CONSTRAINT CK_Events_Status
        CHECK (Status IN ('Open', 'Closed', 'Cancelled', 'Completed')),

    CONSTRAINT CK_Events_Dates
        CHECK (RegistrationDeadline <= EventDate)
);
GO
/* ============================================================
   5. CATEGORIES
   ============================================================ */

CREATE TABLE Categories
(
    CategoryID INT IDENTITY(1,1) NOT NULL,
    CategoryName NVARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    MinimumAge INT NOT NULL DEFAULT 0,
    MaximumAge INT NULL,

    CONSTRAINT PK_Categories
        PRIMARY KEY (CategoryID),

    CONSTRAINT CK_Categories_Distance
        CHECK (DistanceKm > 0),

    CONSTRAINT CK_Categories_MinAge
        CHECK (MinimumAge >= 0),

    CONSTRAINT CK_Categories_MaxAge
        CHECK (MaximumAge IS NULL OR MaximumAge >= MinimumAge)
);
GO

/* ============================================================
   6. EVENT CATEGORIES
   ============================================================ */

CREATE TABLE EventCategories
(
    EventCategoryID INT IDENTITY(1,1) NOT NULL,
    EventID INT NOT NULL,
    CategoryID INT NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,
    MaximumEntries INT NOT NULL,

    CONSTRAINT PK_EventCategories
        PRIMARY KEY (EventCategoryID),

    CONSTRAINT FK_EventCategories_Events
        FOREIGN KEY (EventID)
        REFERENCES Events(EventID),

    CONSTRAINT FK_EventCategories_Categories
        FOREIGN KEY (CategoryID)
        REFERENCES Categories(CategoryID),

    CONSTRAINT UQ_EventCategories
        UNIQUE (EventID, CategoryID),

    CONSTRAINT CK_EventCategories_EntryFee
        CHECK (EntryFee >= 0),

    CONSTRAINT CK_EventCategories_MaxEntries
        CHECK (MaximumEntries > 0)
);
GO
/* ============================================================
   7. ENROLMENTS
   ============================================================ */

CREATE TABLE Enrolments
(
    EnrolmentID INT IDENTITY(1,1) NOT NULL,
    ParticipantID INT NOT NULL,
    EventCategoryID INT NOT NULL,
    EnrolmentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    EnrolmentStatus NVARCHAR(30) NOT NULL DEFAULT 'Confirmed',

    CONSTRAINT PK_Enrolments
        PRIMARY KEY (EnrolmentID),

    CONSTRAINT FK_Enrolments_Participants
        FOREIGN KEY (ParticipantID)
        REFERENCES Participants(ParticipantID),

    CONSTRAINT FK_Enrolments_EventCategories
        FOREIGN KEY (EventCategoryID)
        REFERENCES EventCategories(EventCategoryID),

    CONSTRAINT UQ_Enrolments
        UNIQUE (ParticipantID, EventCategoryID),

    CONSTRAINT CK_Enrolments_Status
        CHECK (EnrolmentStatus IN ('Pending', 'Confirmed', 'Cancelled'))
);
GO
/* ============================================================
   SAMPLE DATA - ORGANISERS
   ============================================================ */

INSERT INTO Organisers
    (FirstName, LastName, Email, PasswordHash)
VALUES
    ('Sarah', 'Mokoena', 'sarah.mokoena@raceday.com', 'HASH_SARAH_123'),
    ('James', 'Naidoo', 'james.naidoo@raceday.com', 'HASH_JAMES_123');
GO
/* ============================================================
   SAMPLE DATA - PARTICIPANTS
   ============================================================ */

INSERT INTO Participants
    (FirstName, LastName, Email, Phone, DateOfBirth)
VALUES
    ('Thabo', 'Dlamini', 'thabo.dlamini@example.com', '0821234567', '1998-05-14'),
    ('Lerato', 'Khumalo', 'lerato.khumalo@example.com', '0839876543', '2002-11-23');
GO
/* ============================================================
   SAMPLE DATA - VENUES
   ============================================================ */

INSERT INTO Venues
    (VenueName, Address, City)
VALUES
    ('Cape Town Stadium', 'Fritz Sonnenberg Road, Green Point', 'Cape Town'),
    ('Durban Athletics Stadium', 'Walter Gilbert Road, Kings Park', 'Durban');
GO
/* ============================================================
   SAMPLE DATA - EVENTS
   ============================================================ */

INSERT INTO Events
    (OrganiserID, VenueID, EventName, EventDescription,
     EventDate, RegistrationDeadline, Status)
VALUES
    (1, 1, 'Cape Town City Run',
     'A scenic road race through Cape Town.',
     '2026-11-15', '2026-11-01', 'Open'),

    (1, 2, 'Durban Beach Run',
     'A coastal running event along Durban.',
     '2026-12-06', '2026-11-22', 'Open'),

    (2, 1, 'Summer Charity Marathon',
     'A charity-focused marathon event.',
     '2027-01-17', '2027-01-03', 'Open');
GO
/* ============================================================
   SAMPLE DATA - CATEGORIES
   ============================================================ */

INSERT INTO Categories
    (CategoryName, DistanceKm, MinimumAge, MaximumAge)
VALUES
    ('5K Fun Run', 5.00, 13, NULL),
    ('10K Road Race', 10.00, 16, NULL),
    ('Half Marathon', 21.10, 18, NULL),
    ('Full Marathon', 42.20, 18, NULL);
GO
/* ============================================================
   SAMPLE DATA - EVENT CATEGORIES
   ============================================================ */

INSERT INTO EventCategories
    (EventID, CategoryID, EntryFee, MaximumEntries)
VALUES
    (1, 1, 100.00, 500),
    (1, 2, 150.00, 400),
    (2, 1, 80.00, 300),
    (2, 2, 120.00, 250),
    (3, 3, 250.00, 300),
    (3, 4, 350.00, 200);
GO
/* ============================================================
   SAMPLE DATA - ENROLMENTS
   ============================================================ */

INSERT INTO Enrolments
    (ParticipantID, EventCategoryID, EnrolmentStatus)
VALUES
    (1, 1, 'Confirmed'),
    (1, 2, 'Confirmed'),
    (2, 3, 'Confirmed'),
    (2, 5, 'Pending');
GO
/* ============================================================
   VERIFICATION QUERIES
   ============================================================ */

SELECT * FROM Organisers;
SELECT * FROM Participants;
SELECT * FROM Venues;
SELECT * FROM Events;
SELECT * FROM Categories;
SELECT * FROM EventCategories;
SELECT * FROM Enrolments;
GO

/* Verify event and organiser relationships */
SELECT
    E.EventID,
    E.EventName,
    O.FirstName + ' ' + O.LastName AS OrganiserName,
    V.VenueName,
    E.EventDate,
    E.Status
FROM Events E
INNER JOIN Organisers O
    ON E.OrganiserID = O.OrganiserID
INNER JOIN Venues V
    ON E.VenueID = V.VenueID;
GO

/* Verify participant enrolments */
SELECT
    P.FirstName + ' ' + P.LastName AS ParticipantName,
    E.EventName,
    C.CategoryName,
    EC.EntryFee,
    EN.EnrolmentStatus
FROM Enrolments EN
INNER JOIN Participants P
    ON EN.ParticipantID = P.ParticipantID
INNER JOIN EventCategories EC
    ON EN.EventCategoryID = EC.EventCategoryID
INNER JOIN Events E
    ON EC.EventID = E.EventID
INNER JOIN Categories C
    ON EC.CategoryID = C.CategoryID;
GO
