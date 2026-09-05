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