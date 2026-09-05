# RaceDay SQL Execution Guide

## Requirements

The RaceDay database script should be executed using Microsoft SQL
Server Management Studio 2022.

## Execution Steps

1. Open SQL Server Management Studio 2022.
2. Connect to the SQL Server instance.
3. Open `docs/RaceDay.sql`.
4. Make sure the complete script is loaded.
5. Execute the script.
6. Confirm that the `RaceDay` database is created successfully.
7. Confirm that all seven tables are created.
8. Review the verification query results at the end of the script.

## Tables Created

The script creates the following tables:

- Organisers
- Participants
- Venues
- Events
- Categories
- EventCategories
- Enrolments

## Verification

The verification queries display:

- Organiser records
- Participant records
- Venue records
- Event records
- Category records
- Event category records
- Enrolment records
- Event and organiser relationships
- Participant enrolments and their event categories

## Expected Result

The script should execute without errors and return the sample
records and relationship results from the verification queries.

A screenshot of the successful SQL execution will be captured for
the final assignment documentation and video.