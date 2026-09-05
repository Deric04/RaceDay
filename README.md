# RaceDay

## System Description

RaceDay is a race event management system designed to help organisers
create and manage running events while allowing participants to view
available races and enrol in race categories.

The system will use a Microsoft SQL Server relational database and a
RESTful API to manage race events, participants, categories and
enrolments.

## User Roles

### Organiser

An Organiser is responsible for managing race events.

Organisers can:

- Create race events
- Update race events
- Cancel race events
- Create and manage race categories
- Add categories to events
- View participants enrolled in their events

### Participant

A Participant is a user who enters races through the RaceDay system.

Participants can:

- Register an account
- Log in
- View available events
- View event details
- View race categories
- Enrol in a race
- View their enrolments
- Cancel their enrolment

## Database

The RaceDay database will contain the following entities:

- Organisers
- Participants
- Venues
- Events
- Categories
- EventCategories
- Enrolments

The database design includes primary keys, foreign keys, unique
constraints, check constraints and relationships between the entities.

## Documentation

The project documentation is stored in the `docs` folder.

- [Entity Relationship Diagram](docs/ERD.md)
- [API Endpoint Plan](docs/API-Endpoint-Plan.md)
- [SQL Database Script](docs/RaceDay.sql)

## CI/CD

GitHub Actions will be used to automatically validate the RaceDay
project whenever changes are pushed to the repository.

### Successful CI/CD Build

The successful GitHub Actions build screenshot will be added here
after the CI/CD workflow has been configured and successfully executed.

![Successful GitHub Actions Build](docs/images/ci-green-build.png)

## Video

An unlisted YouTube video explaining the RaceDay system, ERD,
API Endpoint Plan, SQL script, database execution and GitHub
Actions CI/CD will be added here.

**YouTube Video:** To be added after completion.