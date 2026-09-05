# RaceDay Entity Relationship Diagram

The RaceDay database contains seven entities:

- Organisers
- Participants
- Venues
- Events
- Categories
- EventCategories
- Enrolments

```mermaid
erDiagram

    ORGANISERS ||--o{ EVENTS : creates
    VENUES ||--o{ EVENTS : hosts
    EVENTS ||--o{ EVENT_CATEGORIES : offers
    CATEGORIES ||--o{ EVENT_CATEGORIES : contains
    PARTICIPANTS ||--o{ ENROLMENTS : makes
    EVENT_CATEGORIES ||--o{ ENROLMENTS : receives

    ORGANISERS {
        int OrganiserID PK
        nvarchar FirstName
        nvarchar LastName
        nvarchar Email UK
        nvarchar PasswordHash
        datetime2 CreatedAt
    }

    PARTICIPANTS {
        int ParticipantID PK
        nvarchar FirstName
        nvarchar LastName
        nvarchar Email UK
        nvarchar Phone
        date DateOfBirth
        datetime2 CreatedAt
    }

    VENUES {
        int VenueID PK
        nvarchar VenueName
        nvarchar Address
        nvarchar City
    }

    EVENTS {
        int EventID PK
        int OrganiserID FK
        int VenueID FK
        nvarchar EventName
        nvarchar EventDescription
        date EventDate
        date RegistrationDeadline
        nvarchar Status
    }

    CATEGORIES {
        int CategoryID PK
        nvarchar CategoryName
        decimal DistanceKm
        int MinimumAge
        int MaximumAge
    }

    EVENT_CATEGORIES {
        int EventCategoryID PK
        int EventID FK
        int CategoryID FK
        decimal EntryFee
        int MaximumEntries
    }

    ENROLMENTS {
        int EnrolmentID PK
        int ParticipantID FK
        int EventCategoryID FK
        datetime2 EnrolmentDate
        nvarchar EnrolmentStatus
    }