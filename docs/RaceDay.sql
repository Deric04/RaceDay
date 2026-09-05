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