List questions = [
  {
    "page": 1,
    "text": "Name",
    "other": false,
    "attribute": "name",
    "type": "text",
  },
  {
    "page": 1,
    "text": "Street Address",
    "other": false,
    "attribute": "addressLine1",
    "type": "text",
  },
  {
    "page": 1,
    "text": "Street Address 2",
    "other": false,
    "attribute": "addressLine2",
    "type": "text",
  },
  {
    "page": 1,
    "text": "State",
    "other": false,
    "attribute": "state",
    "type": "text",
  },
  {
    "page": 1,
    "text": "Country",
    "other": false,
    "attribute": "country",
    "type": "text",
  },
  {
    "page": 1,
    "text": "Zip Code",
    "other": false,
    "attribute": "postal",
    "type": "text",
  },
  {
    "page": 1,
    "text": "Phone Number",
    "other": false,
    "attribute": "phone",
    "type": "text",
  },
  {
    "page": 2,
    "text": "About your Gym.",
    "other": true,
    "attribute": "about",
    "type": "text",
    "maxLines": 2
  },
  {
    "page": 2,
    "text": "How many locations does your gym have?",
    "other": true,
    "attribute": "noOfLocations",
    "type": "dropDown",
    "values": ["<5", ">5", "10+"],
  },
  {
    "page": 2,
    "text": "Are your facilities insured?",
    "other": true,
    "attribute": "facilitesInsured",
    "type": "radioBtn",
    "values": [
      "Yes",
      "No",
    ],
    "axis": "horizontal"
  },
  {
    "page": 2,
    "text": "What are your hours of Operation?",
    "other": true,
    "attribute": "workingHrs",
    "type": "text",
  },
  {
    "page": 2,
    "text": "What types of access does your gym have available?",
    "other": true,
    "attribute": "contractType",
    "type": "radioBtn",
    "values": [
      "Drop-in",
      "Month-to-Month",
      "Annual Contract",
      "Discounted",
    ],
    "axis": "vertical"
  },
  {
    "page": 3,
    "text":
        "Is your access tiered? If yes, please provide number of tiers and descriptions below",
    "other": true,
    "attribute": "noOfTiers",
    "type": "radioBtn",
    "values": [
      "Yes",
      "No",
    ],
    "axis": "horizontal"
  },
  {
    "page": 3,
    "text": "Is multiple location access included in your memberships?",
    "other": true,
    "attribute": "multiLocationAccess",
    "type": "radioBtn",
    "values": ["Yes", "No", "N/A"],
    "axis": "horizontal"
  },
  {
    "page": 3,
    "text": "What is the average staff size for each location?",
    "other": true,
    "attribute": "staffSize",
    "type": "radioBtn",
    "values": [
      "1-4",
      "5-10",
      "11-15",
      "16+",
    ],
    "axis": "vertical"
  },
  {
    "page": 3,
    "text": "What is the average monthly membership price?",
    "other": true,
    "attribute": "membershipPrice",
    "type": "text",
  },
  {
    "page": 4,
    "text": "What's your drop in fee if available?",
    "other": true,
    "attribute": "dropInFee",
    "type": "text",
  },
  {
    "page": 4,
    "text": "Do you use social media to communicate?",
    "other": true,
    "attribute": "socialMedia",
    "type": "radioBtnWithText",
    "values": [
      "Instagram ID",
      "Facebook Profile Url",
      "Twitter ID",
      "Youtube Channel Url",
    ],
    "axis": "vertical"
  },
  {
    "page": 4,
    "text": "Of your staff, how many are licensed personal trainers?",
    "other": true,
    "attribute": "licensedTrainers",
    "type": "text",
  },
  {
    "page": 4,
    "text": "What is the hourly rate for personal training?",
    "other": true,
    "attribute": "trainerHourPrice",
    "type": "text",
  },
  {
    "page": 5,
    "text": "What type of training  do you specialize in?",
    "other": true,
    "attribute": "specialization",
    "type": "selectStrips",
    "values": [
      "Yoga",
      "1:1 Individual Training",
      "Flexology",
      "Barre Classes",
      "Running",
      "Weight Machines",
      "Supplement/Smoothie Bar",
      "Basketball",
      "Boxing",
      "Lockers",
      "Pickle-Ball",
      "Synchronized Swimming",
      "Zumba",
      "Cardio",
      "Nutrition",
      "Free Weights",
      "Stretching",
      "Spin Classes",
      "Outdoor Amenities",
      "Personal Training",
      "Rehabilitation & Therapy Services",
      "Dining",
      "Group Training",
      "Child Care",
      "Pool"
    ]
  },
  {
    "page": 5,
    "text": "What equipments does the gym posses",
    "other": true,
    "attribute": "equipment",
    "type": "iconStrips",
    "values": equipment
  },
  {
    "page": 5,
    "text": "What amenities does the gym posses",
    "other": true,
    "attribute": "aminities",
    "type": "iconStrips",
    "values": aminities
  },
  {
    "page": 5,
    "text": "Are your facilities ADA Compliant?",
    "other": true,
    "attribute": "adaCompliant",
    "type": "radioBtn",
    "values": ['Yes', "No", "N/A"],
    "axis": "horizontal"
  },
  {
    "page": 5,
    "text": "Are you LGBTQ+ friendly?",
    "other": true,
    "attribute": "lgbtq",
    "type": "radioBtn",
    "values": ['Yes', "No", "N/A"],
    "axis": "horizontal"
  },
];

List<Map<String, String>> equipment = [
  {"icon": "gym_lifting", "text": "Weights"},
  {"icon": "gym_bike", "text": "Cycles"},
  {"icon": "gym_swim", "text": "Pool"},
];
List<Map<String, String>> aminities = [
  {"icon": "gym_drinks", "text": "Drinks"},
  {"icon": "gym_canteen", "text": "Canteen"},
  {"icon": "gym_mask", "text": "Mask required"},
  {"icon": "gym_vaccine", "text": "Vaccination \n required"},
];
