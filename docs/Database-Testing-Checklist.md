# RaceDay Database Testing Checklist

## Database Creation

- [ ] RaceDay database is created successfully.
- [ ] No SQL errors occur during execution.
- [ ] All seven tables are created.

## Organisers

- [ ] At least two organiser records exist.
- [ ] Organiser email addresses are unique.

## Participants

- [ ] At least two participant records exist.
- [ ] Participant email addresses are unique.

## Events

- [ ] At least three events exist.
- [ ] Each event is linked to an organiser.
- [ ] Each event is linked to a venue.
- [ ] Event status uses an allowed value.

## Categories

- [ ] Race categories exist.
- [ ] Category distances are greater than zero.
- [ ] Category age restrictions are valid.

## Event Categories

- [ ] Events can have multiple categories.
- [ ] Categories can be used by multiple events.
- [ ] Entry fees are valid.
- [ ] Maximum entries are greater than zero.

## Enrolments

- [ ] At least two participants have enrolments.
- [ ] Each enrolment references a valid participant.
- [ ] Each enrolment references a valid event category.
- [ ] Enrolment status uses an allowed value.

## Relationships

- [ ] Organisers → Events relationship works.
- [ ] Venues → Events relationship works.
- [ ] Events → EventCategories relationship works.
- [ ] Categories → EventCategories relationship works.
- [ ] Participants → Enrolments relationship works.
- [ ] EventCategories → Enrolments relationship works.

## Final Verification

- [ ] Verification queries return the expected sample data.
- [ ] Successful SQL execution screenshot captured.
- [ ] GitHub Actions CI build passes successfully.