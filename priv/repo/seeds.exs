# Script for populating the database. With pretty data.
# Most useful for demos

alias Litelist.Factory
alias Litelist.Posts
neighbor = Factory.insert(:neighbor, %{username: "neighbor"})
admin = Factory.insert(:neighbor, %{username: "admin", admin: true})

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

Posts.create_post(
    %{
        title: "Bed Stuy Block Party!",
        type: "event",
        description: "Brooklyn's best block party! Next month at Fulton and Nostrand. Live Djs, games for the kids, and great food! Come celebrate summertime!",
        location: "Corner of Nostrand and Fulton",
        contact_info: "",
        url: "bed-stuy-block-party",
        start_date: next_month,
        end_date: next_month_plus_one,
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "blockparty.jpeg",
                    path: "priv/seed_photos/blockparty.jpg"
                }
            }
        ],
        slug: "12346",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "Crown Heights Safe Spaces During a Flood",
        type: "emergency_information",
        description: "If Hurricane Zane hits next month, make sure to go to the community center if you can make it. We'll have food and warmth and company. It also helps to keep the hospitals clear for those who specifically need medical attention. All are welcome. We follow NYC Sanctuary City best practices.",
        location: "900 Church Ave",
        contact_info: "347-882-2212",
        url: "crown-heights-flood-safety",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "communitycenter.jpg",
                    path: "priv/seed_photos/communitycenter.jpg"
                }
            }
        ],
        slug: "12347",
        neighbor_id: 1

    }
)

Posts.create_post(
    %{
        title: "Electrician on a union contract",
        type: "job",
        description: "Electrician needed for new condos on Flatbush Avenue. Union contract.",
        location: "2133b Flatbush Ave",
        contact_info: "347-332-1487, ask for Alex",
        url: "union-electricians",
        position_name: "electrician",
        company_name: "Alex Building and Supplies",
        salary: "$40/hr, full-time",
        start_date: next_month,
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "electrician.jpg",
                    path: "priv/seed_photos/electrician.jpg"
                }
            }
        ],
        slug: "12348",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "Sammy's Pizza",
        type: "business",
        description: "Wood-fired pizza, with the best toppings from the area.",
        location: "822 Nostrand Ave",
        contact_info: "347-883-9228",
        url: "sammys-pizza",
        company_name: "Sammy's Pizza",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "pizza.jpg",
                    path: "priv/seed_photos/pizza.jpg"
                }
            }
        ],
        slug: "12349",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "Barista at Bushwick's Best Cafe!",
        type: "job",
        description: "Early morning shift at Cafe Bushwick. You'll be in charge of all of the early morning activities around the store. Cleaning, prepping, that kind of thing. Regular schedule and a great staff that you'll work with.",
        location: "1512a Bushwick Ave",
        contact_info: "347-456-8833, ask for Terry",
        url: "work-at-bushwicks-best-cafe",
        position_name: "barista",
        company_name: "Cafe Bushwick",
        salary: "Competitive wages",
        start_date: next_week,
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "barista.jpg",
                    path: "priv/seed_photos/barista.jpg"
                }
            }
        ],
        slug: "12350",
        neighbor_id: 1
           
    }
)

Posts.create_post(
    %{
        title: "Vintage Books",
        type: "business",
        description: "Lovely books. Used and new. All genres, all kinds of writers. We have black coffee and a space you'll fall in love with.",
        location: "1281 Halsey St",
        contact_info: "347-773-5411",
        url: "vintage-books",
        company_name: "Vintage Books",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "vintagebooks.jpg",
                    path: "priv/seed_photos/vintagebooks.jpg"
                }
            }
        ],
        slug: "12351",
        neighbor_id: 1
    }
)

# =========================================================================
Posts.create_post(
    %{
        title: "vintage brown leater race jacket size 2x",
        type: "for_sale",
        description: "vintage mens...leather race jacket 3 outside pockets 1 inside pocket zip front size 2xx this is a big jaket $140/cash or trade what you got ?????",
        location: "Kew Gardens",
        contact_info: "vintage.brown.leather",
        url: "1998-mazda",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "jacket.jpg",
                    path: "priv/seed_photos/jacket.jpg"
                }
            }
        ],
        slug: "12355",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "AFTER WORK FRIDAY'S AT THE TAJ LOUNGE",
        type: "event",
        description: "MAXWELL ENTERTAINMENT PRESENTS AFTER WORK FRIDAY'S AT TAJ LOUNGE. THIS FRIDAY, APRIL 27, 2018, DJ BENT ROC FROM 107.5 WBLS CLASSIC FLAVORS SHOW AND DJ LANCE WILL BE ON THE SET. DOORS OPEN AT 5PM . FREE ADMISSION FROM 5PM TO 7PM. $15 COVER AFTER 7PM. BRING YOUR MAXWELL ENTERTAINMENT MEMBERSHIP CARD AND THE COVER CHARGE WILL BE $10. FREE APPETIZERS FROM 5PM TO 6PM. TWO FOR ONE DRINKS FROM 5PM TO 8PM. FOR TABLE RESERVATIONS CALL",
        location: "broadway and evergreen",
        contact_info: "(212) 620-3033",
        url: "taj-lounge",
        start_date: next_month,
        end_date: next_month_plus_one,
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "afterwork-event.jpg",
                    path: "priv/seed_photos/afterwork-event.jpg"
                }
            }
        ],
        slug: "12366",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "Community Center post-march",
        type: "emergency_information",
        description: "Safe space to decompress after march",
        location: "900 Church Ave",
        contact_info: "347-882-2212",
        url: "dicks-emergency",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "communitycenter.jpg",
                    path: "priv/seed_photos/communitycenter.jpg"
                }
            }
        ],
        slug: "12397",
        neighbor_id: 1

    }
)

Posts.create_post(
    %{
        title: "Graphic Designer Email and Social media Full time",
        type: "job",
        description: "Advantages is a boutique branding and design agency made up of fun-loving, intelligent, and committed people. We are a small but strong agency (going on 20 years), experienced in developing corporate branding, web design, and lots and lots of print materials--anything that gets our clients noticed! We like all of our team members to be able to manage several roles and be tenacious about accomplishing tasks, even if it means stepping outside of their comfort zone. 
            Our ideal candidate is passionate about being creative and bringing a fresh perspective to the table. You are able to be proactive and work with a quick turn-around and keep the ball rolling. You should have a few years industry/agency experience as a graphic designer but we're also here to support your growth. Having a passion for learning and growing, no matter how experienced you are, is a quality we expect from everyone on our design team. Fitting in with our company culture is extremely important, so in addition to being an awesome designer, you should be an even more awesome person!

You will be working from our office based in Kew Gardens, Queens--steps away from the E/F train. Please only apply if you are able to commute to our office in Queens, as we are not looking for freelancers or remote employees at this time.

Here's what we are looking for in a candidate:

Skills
• Proven ability to design high quality, beautiful, on-trend design work 
• Knowledge of current design trends, both in print and digital
• 3+ years full-time design industry experience (agency preferred)
• Must have a good understanding of marketing principles and be able to apply that knowledge to design projects
• Advanced Experience in Adobe CC, InDesign, Photoshop, and Illustrator 
• Exceptional attention to detail and ability to self-check your designs for any potential mistakes or flaws
• Understand HTML basics and be able to communicate with programmers to develop web projects from your designs 
• Web design and/or development experience is a huge plus: HTML, CSS, PHP, Javascript, CMS systems
• Able to meet tight deadlines and juggle multiple jobs
• Confident in creating project calendars, deadlines, and goals 

We want someone who is...
• Creative--comes up with fresh ideas and can think outside the box
• Proactive--doesn't just do the bare minimum but does whatever is needed to accomplish the goal without being asked
• A Great Communicator--never leaves anyone wondering what next steps are, especially clients
• Enthusiastic--a team player and can take on a leader role when needed
• Inquisitive--doesn't assume, but prompts questions to get all the information needed
• Knowledgeable--knows what they're doing and why they're doing it and doesn't need to be coached 24/7
• Fearless--willing to try new things and not afraid to stand behind their choices with confidence


Please submit your resume in PDF, JPEG, or online form, a link to your portfolio, and in the body of the email include a little bit about yourself, why you would be the perfect fit, and your desired salary. Please include the subject line Experienced Designer. Please do not attempt to apply in person or over the phone.",
        location: "2133b Flatbush Ave",
        contact_info: "347-332-1487, ask for Alex",
        url: "a1get.noticed",
        position_name: "Graphic Design",
        company_name: "A One Design",
        salary: "$40/hr, full-time",
        start_date: next_month,
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "graphicdesign.jpg",
                    path: "priv/seed_photos/graphicdesign.jpg"
                }
            }
        ],
        slug: "11348",
        neighbor_id: 1
    }
)

Posts.create_post(
    %{
        title: "Sammy's Pizza",
        type: "business",
        description: "We are an Artist-Run Gallery with members including painters, sculptors, photographers, collagists, printmakers, mixed media and experimenters of all kinds, dedicated to exhibiting works of the highest esthetic standards. We are especially proud of our diversity in styles, methods, age and individuality. We also deeply value our philosophy of complete freedom of expression without the constraints of commercial galleries.

Many of us have been widely exhibited here and abroad, have won multiple
awards, including a Fulbright Scholar, and have been selected for exhibitions
juried by the most prominent museum curators and art historians.",
        location: "822 Nostrand Ave",
        contact_info: "347-883-9228",
        url: "pleidas-gallery.fun",
        company_name: "pleiadasgallery",
        images: [
            %{
                "image" => %Plug.Upload{
                    content_type: "image/jpeg",
                    filename: "business.jpg",
                    path: "priv/seed_photos/business.jpg"
                }
            }
        ],
        slug: "12149",
        neighbor_id: 1
    }
)




