## Casper app directory
* Name: Home, Frontend: Elm, Backend: None
* Portal to all internal Casper apps
* Google OAuth
* User model called 'Ghost'

## Budget app
* Name: Budget, Frontend: Phoenix, Backend: Phoenix
* Set budget
* Refill to budget line every month
* Categories
* Spendee
* Savings
* Auto pull spend from bank?

## Game score app
* Name: Scoreboard, Frontend: Elm, Backend: Rust/actix-web
* Keep long term score for games (sequence)
* Form teams, run championships, statistics

## Movie directory
* Name: Movies, Frontend: Go/revel, Backend: Go/revel
* Keep track of the movies we own, and in which form (physical, on computer, in apple)
* Possibly market to lettows

## Recipe index
* Name: Recipes, Frontend: Rails, Backend: Rails
* Recipe list with links to original
* Original recipes if we've got any

## Auth
* Name: Auth, Frontend: Golang, Backend: Golang
* Responsible for presenting google oauth when not authenticated
* Responsible for generating JWTs

## Router
* Name: Router, Tech: Envoy
* Responsible for doing path-based service routing, to keep everything under one domain

## Dailies
* Name: Dailies, Frontend: React, Backend: TBD
* Daily task list, can persist or drop tasks between days

## Queue
* Name: Queue, Tech: Kafka
* Responsible for passing messages and events between services

## Trips
* Name: Trips, Tech: ??
* Record of the trips we've taken
