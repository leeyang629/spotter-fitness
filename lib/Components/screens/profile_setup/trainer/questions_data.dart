List questions = [
  {
    "page": 1,
    "text": "Street Address",
    "attribute": "address1",
    "type": "text",
    "required": true
  },
  {
    "page": 1,
    "text": "Street Address 2",
    "attribute": "address2",
    "type": "text",
    "required": true
  },
  {
    "page": 1,
    "text": "State",
    "attribute": "state",
    "type": "text",
    "required": true
  },
  {
    "page": 1,
    "text": "Zip Code",
    "attribute": "zipCode",
    "type": "text",
    "required": true
  },
  {
    "page": 1,
    "text": "Phone Number",
    "attribute": "phone",
    "type": "text",
  },
  {
    "page": 2,
    "text": "How many years of experience do you have?",
    "attribute": "yoe",
    "type": "dropDown",
    "values": ["<5", ">5", "10+"],
    "required": true
  },
  {
    "page": 2,
    "text": "What are your days and hours of operation?",
    "attribute": "noOfOperationDays",
    "type": "text",
    "required": true
  },
  {
    "page": 2,
    "text": "What types of contracts do you offer?",
    "attribute": "contractType",
    "type": "radioBtn",
    "values": [
      "Drop-in",
      "Month-to-Month",
      "Annual Contract",
      "Discounted",
    ],
    "axis": "vertical",
    "required": true
  },
  {
    "page": 3,
    "text": "Do you want to diplay price in public to everyone?",
    "attribute": "displayPrice",
    "type": "radioBtn",
    "values": ['Yes', "No"],
    "axis": "horizontal",
    "required": true
  },
  {
    "page": 3,
    "text": "What is the average price?",
    "attribute": "price",
    "type": "text",
    "required": true
  },
  {
    "page": 3,
    "text": "Will you travel to train?",
    "attribute": "trainTravel",
    "type": "radioBtn",
    "values": ['Yes', "No", "N/A"],
    "axis": "horizontal",
    "required": true
  },
  {
    "page": 3,
    "text": "What's your drop in fee if available?",
    "attribute": "dropInFee",
    "type": "text",
    "required": true
  },
  {
    "page": 3,
    "text": "Do you use social media to communicate?",
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
    "text": "What type of training do you specialize in?",
    "attribute": "specialization",
    "type": "selectStrips",
    "values": [
      "1:1 Individual Training",
      "Bodybuilding",
      "Boxing",
      "Cardio",
      "Corrective exercise",
      "Free Weights",
      "Flexology",
      "Glute Building",
      "Group Training",
      "Health coaching",
      "Nutrition",
      "Personal Training",
      "Posing",
      "Rehabilitation & Therapy Services",
      "Senior Fitness",
      "Show Prep",
      "Strength and Conditioning",
      "Stretching",
      "Supplement/Smoothie Bar",
      "Synchronized Swimming",
      "Youth Fitness",
      "Weight loss transformation",
      "Weight Machines",
      "Yoga",
    ],
    "required": true
  },
  {
    "page": 4,
    "text": "Are you LGBTQ+ friendly?",
    "attribute": "lgbtq",
    "type": "radioBtn",
    "values": ['Yes', "No", "N/A"],
    "axis": "horizontal",
    "required": true
  },
  {
    "page": 4,
    "text": "Certification",
    "attribute": "certifications",
    "type": "text",
    "required": true
  },
  {
    "page": 4,
    "text": "Published Article",
    "attribute": "publications",
    "type": "text",
    "required": true
  },
  {
    "page": 4,
    "text": "Conference attended",
    "attribute": "conferences",
    "type": "text",
    "required": true
  },
];
