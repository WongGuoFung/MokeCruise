# Introduction

EnDine is a database booking system which allows their passengers from MokéCruise to order cabin service, reserve seats in restaurants and dining halls as well as book activities and entertainment on board any of their cruise ships.

## Description of EnDine Booking System
EnDine is a new online booking platform that functions as a software solution that allows passengers to book for their activities and has tools that guides them for the various activities within MokéCruise. 

This online booking system helps the staff to passively receive booking requests and reservations. It also acts as a hub for information storage for the various activities and entertainment that the passengers participating in as well as the reservations that they have made for restaurants and dining halls. 

Our booking system further enhances the user experiences by keeping track of all bookings in real time and allows the gathering of data which could potentially showcase which event organise by MokéCruise is most widely enjoyed and popular.

EnDine assists the personnel in staying organized with their data by categorizing each amenity into its own entity and assigning attributes to each passenger and their behaviours during the voyage. The Passenger ID, for example, is left as a footprint in each entity to trace when and what the passenger did at any given time. 

The booking system allows passengers to book and reserve seats on the trip at any time and from any location. Passengers can review and cancel their reservations at any time, and the system will adjust the availability to allow others to take their place. Because everything is updated in real-time, this will provide a smooth cancellation system as well as eliminate the issue wasted seats.
EnDine features conveniences to booking and reserving by showcasing the name, unique identifiers, time slots and capacity for each type of entertainment, activities, restaurants, and dining halls available to the passenger anytime.
Additionally, it tracks the type of food purchased via the cabin service and allows the passengers to know all menu items that are suitable for their diet. Such as food options that are Halal, for vegetarian and vegan. 

Furthermore, knowing where their clients are at any given time allows the personnel to control their passengers' security. EnDine would assist MokéCruise's crew in having an efficient and productive cruise management experience by providing a system that incorporates information from all amenities.

Restaurant booking takes the passenger's name, phone number, email address, their preferred timing and the number of pax. Like dining halls, activities and entertainment. Which functions as a booking receipt for staff to view and to prevent overbooking.

Cabin services would collect the passenger's name, room number, phone number, and email address in order to deliver the meal they've requested and send them an email receipt as proof of payment. The system could also inform the passenger if the meals that they order are currently unavailable by calling their phone number. The system would also allow the menu to display the item name from the restaurant or dining hall, as well as the pricing or dietary values, so that passengers can better understand the dish on display. 

The Menu would then obtain the price of the menu item, and check if the dish is Halal or Vegetarian and it would have to prepared by a unique restaurant ID. This would allow each menu item to be distinct even if they have the same name (E.g., Egg Fried Rice from Ding Tai Fung “Non-Halal”, Egg Fried Rice from Wok Hey “Halal”)

## Mapped Relation
Passenger ( PgrID , PgrName , PgrEmail , PgrDOB , PgrGender , CabinNo )

PassengerContact ( [PgrID] ,PgrContactNo)

EventType (ETID, ETName )

Event ( EventID , EventName , EventDescr , EventLoc , MinAge , MaxAge , EventCapacity , EventDuration , AdultPrice , ChildPrice, [ETID])

EventSession ([EventID],  SessionNo , EventDateTime  )

FoodCategory ( FcID , FcName , FcDescr)

Ingredient ( IngredID , IngredName)

Cuisine ( cuisineID , cuisineName )

Eatery ( EatyID , EatyOpHr, EatyCIHr , EatyCapacity , EatyLoc , EatyName )

Dish ( DishID , DishName , DishDescr ,  [cusineID] , [EatyID] )

CSDish ( [DishID]  , Price)

DishCategory ( [FcID] , [DishID] )

DishIngred ( [IngredID]  , [DishID] )

Orders ( [PgrID] , [DishID]  , OrderPrice , OrderQty , OrderDateTime , DeliverTo , DelDateTime )

Reservation ( ReservID, [PgrID] , [EatyID], ReservStatus, ReservDateTime, RequiredDateTime , NoOfPax ) 

Booking ( BookingID ,  [PgrID] , [EventID] , <SessionNo> ,NoOfAdultTicket , NoOfChildTicket , AdultSalesPrice , ChildSalesPrice , BookStatus , BookDateTime) 
