# Script for populating the database. With pretty data.
# Most useful for demos

alias Litelist.Factory
alias Litelist.Posts

next_week = Timex.shift(Timex.today, days: 7)
next_month = Timex.shift(Timex.today, days: 30)

next_week_plus_one = Timex.shift(Timex.today, days: 8)
next_month_plus_one = Timex.shift(Timex.today, days: 31)

Posts.create_post(
    %{
        title: "1998 Mazda",
        type: "for_sale",
        description: "Still runs. 300,000 miles. $3500/BO",
        location: "12 Washington Ave",
        contact_info: "917-477-2332, ask for Nicki",
        url: "1998-mazda",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "mazda.jpeg",
                    path: "priv/seed_photos/mazda.jpeg"
                }
            }
        ],
        slug: "12345",
        neighbor_id: 1
    }
)

Factory.insert(
    :event,
    %{
        title: "Bed Stuy Block Party!",
        description: "Brooklyn's best block party! Next month at Fulton and Nostrand. Live Djs, games for the kids, and great food! Come celebrate summertime!",
        location: "Corner of Nostrand and Fulton",
        contact_info: "",
        url: "bed-stuy-block-party",
        start_date: next_month,
        end_date: next_month_plus_one
    }
)

Factory.insert(
    :emergency_information,
    %{
        title: "Crown Heights Safe Spaces During a Flood",
        description: "If Hurricane Zane hits next month, make sure to go to the community center if you can make it. We'll have food and warmth and company. It also helps to keep the hospitals clear for those who specifically need medical attention. All are welcome. We follow NYC Sanctuary City best practices.",
        location: "900 Church Ave",
        contact_info: "347-882-2212",
        url: "crown-heights-flood-safety"
    }
)

Factory.insert(
    :job,
    %{
        title: "Electrician on a union contract",
        description: "Electrician needed for new condos on Flatbush Avenue. Union contract.",
        location: "2133b Flatbush Ave",
        contact_info: "347-332-1487, ask for Alex",
        url: "union-electricians",
        position_name: "electrician",
        company_name: "Alex Building and Supplies",
        salary: "$40/hr, full-time",
        start_date: next_month
    }
)

Factory.insert(
    :business,
    %{
        title: "Sammy's Pizza",
        description: "Wood-fired pizza, with the best toppings from the area.",
        location: "822 Nostrand Ave",
        contact_info: "347-883-9228",
        url: "sammys-pizza",
        company_name: "Sammy's Pizza"
    }
)

Factory.insert(
    :job,
    %{
        title: "Barista at Bushwick's Best Cafe!",
        description: "Early morning shift at Cafe Bushwick. You'll be in charge of all of the early morning activities around the store. Cleaning, prepping, that kind of thing. Regular schedule and a great staff that you'll work with.",
        location: "1512a Bushwick Ave",
        contact_info: "347-456-8833, ask for Terry",
        url: "work-at-bushwicks-best-cafe",
        position_name: "barista",
        company_name: "Cafe Bushwick",
        salary: "Competitive wages",
        start_date: next_week
    }
)

Factory.insert(
    :business,
    %{
        title: "Vintage Books",
        description: "Lovely books. Used and new. All genres, all kinds of writers. We have black coffee and a space you'll fall in love with.",
        location: "1281 Halsey St",
        contact_info: "347-773-5411",
        url: "vintage-books",
        company_name: "Vintage Books"
    }
)

Factory.insert(
    :emergency_information,
    %{
        title: "Mold removal after the flood",
        description: "Some say use bleach. Some say bleach will just hide the mold. One thing everyone agrees on... ",
        location: "5532 Dekalb Ave",
        contact_info: "347-322-8432",
        url: "mold-removal"
    }
)


Factory.insert(
    :event,
    %{
        title: "Moving sale!",
        description: "I'm moving out of the city for sunny LA! I wanted to try this new website to sell my stuff back to the community. Community-friendly prices. Everything from furniture and appliances to blankets and photo frames.",
        location: "1899 Grand st Brooklyn",
        contact_info: "347-339-0553",
        url: "moving-sale",
        start_date: next_week,
        end_date: next_week_plus_one
    }
)

Factory.insert(
    :for_sale,
    %{
        title: "Air conditioner",
        description: "Perfect condition. 1 year old. Moving to Maine so I don't need it anymore.",
        location: "88 Court St",
        contact_info: "917-993-0884",
        url: "buy-my-air-conditioner"
    }
)

