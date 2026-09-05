# RaceDay API Endpoint Plan

## Overview

The RaceDay API will provide RESTful endpoints for managing organisers,
participants, events, venues, categories and enrolments.

Authentication will be used to control access to protected endpoints.

---

## Authentication

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/auth/register` | Register a new participant account | Public | FirstName, LastName, Email, Password, Phone, DateOfBirth | 201 Created - Participant created |
| POST | `/api/auth/login` | Authenticate a user | Public | Email, Password | 200 OK - Authentication token |

---

## Events

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/events` | Retrieve all available events | Public | None | 200 OK - List of events |
| GET | `/api/events/{id}` | Retrieve a specific event | Public | None | 200 OK - Event details |
| POST | `/api/events` | Create a new race event | Organiser | EventName, Description, VenueID, EventDate, RegistrationDeadline | 201 Created - Event |
| PUT | `/api/events/{id}` | Update an existing event | Organiser | Updated event details | 200 OK - Updated event |
| DELETE | `/api/events/{id}` | Cancel an event | Organiser | None | 204 No Content |
| GET | `/api/events/{id}/categories` | View categories available for an event | Public | None | 200 OK - List of categories |
| GET | `/api/events/{id}/enrolments` | View participants enrolled in an event | Organiser | None | 200 OK - List of enrolments |

---

## Categories

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/categories` | Retrieve all race categories | Public | None | 200 OK - List of categories |
| GET | `/api/categories/{id}` | Retrieve a specific category | Public | None | 200 OK - Category details |
| POST | `/api/categories` | Create a new race category | Organiser | CategoryName, DistanceKm, MinimumAge, MaximumAge | 201 Created - Category |
| PUT | `/api/categories/{id}` | Update a category | Organiser | Updated category details | 200 OK - Updated category |
| DELETE | `/api/categories/{id}` | Delete a category | Organiser | None | 204 No Content |

---

## Event Categories

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/events/{id}/categories` | Add a category to an event | Organiser | CategoryID, EntryFee, MaximumEntries | 201 Created - Event category |
| DELETE | `/api/events/{id}/categories/{categoryId}` | Remove a category from an event | Organiser | None | 204 No Content |

---

## Participants

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| GET | `/api/participants` | View registered participants | Organiser | None | 200 OK - List of participants |
| GET | `/api/participants/{id}` | View participant details | Organiser / Participant | None | 200 OK - Participant |
| PUT | `/api/participants/{id}` | Update participant profile | Participant | Updated participant details | 200 OK - Updated participant |

---

## Enrolments

| Method | Route | Description | Role Required | Request Body | Expected Response |
|---|---|---|---|---|---|
| POST | `/api/enrolments` | Enrol a participant in an event category | Participant | EventCategoryID | 201 Created - Enrolment |
| GET | `/api/enrolments/my` | View the logged-in participant's enrolments | Participant | None | 200 OK - List of enrolments |
| GET | `/api/enrolments/{id}` | View a specific enrolment | Participant / Organiser | None | 200 OK - Enrolment |
| PUT | `/api/enrolments/{id}/cancel` | Cancel an enrolment | Participant | None | 200 OK - Cancelled enrolment |

---

## API Roles

### Public

Unauthenticated users can:

- Register
- Log in
- View events
- View event details
- View categories

### Organiser

Authenticated organisers can:

- Create events
- Update events
- Cancel events
- Create categories
- Update categories
- Delete categories
- Add categories to events
- Remove categories from events
- View participants
- View event enrolments

### Participant

Authenticated participants can:

- Update their profile
- Enrol in race categories
- View their enrolments
- Cancel their enrolments

---

## Expected HTTP Status Codes

| Status Code | Meaning |
|---|---|
| 200 | Request completed successfully |
| 201 | Resource successfully created |
| 204 | Request successful with no response body |
| 400 | Invalid request |
| 401 | Authentication required |
| 403 | User does not have permission |
| 404 | Resource not found |
| 409 | Conflict, such as duplicate enrolment |
| 500 | Internal server error |