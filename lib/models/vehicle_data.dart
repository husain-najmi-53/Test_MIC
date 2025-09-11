const Map<String, Map<String, List<String>>> vehicleCategorySections = {
  // Two Wheeler categories
  "Two Wheeler 1Y OD": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    /* "[B] Liability Premium": [
          "Liability Premium (TP)",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "PA to Unnamed Passenger",
          "Total B"
        ],*/
    "[B] Total Premium": ["Total Package Premium[A]", "GST @ 18%", "Other CESS"]
  },
  "Two Wheeler 1Y OD + 1Y TP": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Two Wheeler 1Y OD + 5Y TP": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Electric Two Wheeler 1Y OD": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    /* "[B] Liability Premium": [
          "Liability Premium (TP)",
          "PA to Owner Driver",
          "LL to Paid Driver",
          "PA to Unnamed Passenger",
          "Total B"
        ],*/
    "[B] Total Premium": ["Total Package Premium[A]", "GST @ 18%", "Other CESS"]
  },
  "Electric Two Wheeler 1Y OD + 1Y TP": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD ",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Electric Two Wheeler 1Y OD + 5Y TP": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Two Wheeler Passenger Carrying": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
      "Cubic Capacity",
      "No. of Passengers"
    ],
    "[A] Own Damage Premium": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Accessories Value",
      "IMT 23",
      "Total Basic Premium",
      "No Claim Bonus",
      "Total A",
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },

  //Goods Carrying categories
  "Goods Carrying Vehicle": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
      "Gross Vehicle Weight"
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electrical Accessories",
      "CNG/LPG Kits",
      "Basic OD Premium",
      "Geographical Extn",
      "IMT 23",
      "Anti-Theft",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD before NCB",
      "No Claim Bonus",
      //"Net Own Damage Premium (A)",
      "Total A"
    ],
    "[B] Addon Coverage": ["Zero Depreciation", "RSA", "Total B"],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium (A+B+C)",
      "GST @ (18%)",
      "GST @ (12%) on Basic TP",
      "Other CESS",
      //"Final Premium"
    ],
  },
  "Electric Goods Carrying": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
      "Gross Vehicle Weight"
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electrical Accessories",
      "CNG/LPG Kits",
      "Basic OD Premium",
      "Geographical Extn",
      "IMT 23",
      "Anti-Theft",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD before NCB",
      "No Claim Bonus",
      //"Net Own Damage Premium (A)",
      "Total A"
    ],
    "[B]Add-on Coverage": ["RSA", "Zero Depreciation", "Total B"],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium (A+B+C)",
      "GST @ (18%)",
      "GST @ (12%) on Basic TP",
      "Other CESS",
      // "Final Premium"
    ]
  },
  "Three-Wheeler Goods Carrying": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "CNG/LPG kits",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD before NCB",
      "No Claim Bonus",
      //"Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium (A+B)",
      "GST @ (18%)",
      "GST @ (12%) on Basic TP",
      "Other CESS",
      //"Final Premium"
    ]
  },
  "E-Three Wheeler Goods Carrying": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic rate",
      "Basic for Vehicle",
      "Electrical Accessories",
      "IMT 23",
      "Basic OD before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD before NCB",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Value Added Service",
      "Total B",
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total package Premium (A+B+C)",
      "GST @ (18%)",
      "Other CESS",
      // "Final Premium"
    ]
  },

  // Passenger Carrying categories
  "Three Wheeler PCV(Upto 6 Passengers)": {
    "Basic Details": [
      "IDV",
      // "Depreciation %",
      // "Current IDV",
      "Year of Manufacture",
      "Zone",
      // "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG Kit",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD Before NCB",
      "No Claim Bonus",
      //"Net OD Premium[A]",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      //"Total Liability Premium",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium [A+B]",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS",
      //"Final Premium Payable",
    ],
  },
  "Three Wheeler PCV (More Than 6 Upto 17 passenger)": {
    "Basic Details": [
      "IDV",
      // "Depreciation %",
      // "Current IDV",
      "Year of Manufacture",
      "Zone",
      // "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic For Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG Kit",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net OD Premium(A)",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      //"Total Liability Premium (B)",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS",
      // "Final Premium Payable",
    ],
  },
  "Taxi (Upto 6 Passengers)": {
    "Basic Details": [
      "IDV",
      // "Depreciation (%)",
      // "Current IDV",
      "Year of Manufacture",
      "Zone",
      // "Age of Vehicle",
      "No. of Passengers",
      "Cubic Capacity" // added this
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG kits",
      "Basic OD Premium",
      "Anti-Theft",
      "Basic OD Before Discount",
      "Discount on OD",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net OD Premium[A]",
      // "Discount Amount",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA/Additional for Addons",
      // "Total Addon Premium",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium(A + B + C)",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS",
      // "Other CESS Amount",
      //"Final Premium Payable"
    ]
  },
  "Bus More than 6 Passenger": {
    "Basic Details": [
      "IDV",
      // "Depreciation (%)",
      // "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      // "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electrical Accessories",
      "CNG/LPG Kits",
      "Basic OD Premium",
      "Geographical Extn",
      "IMT 23",
      "Anti-Theft",
      "Basic OD Before Discount",
      "Discount on OD",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net OD Premium",
      "Total A"
    ],
    "[B] Addon Coverages": [
      "Zero Dep Premium",
      "RSA/Additional for Addons",
      // "Total Addon Premium",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "Geographical Extn (TP)",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employees",
      //"Total Liability Premium",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package premium[A+B+C]",
      "GST @ 18% [Applied on A+B+C]",
      "Other CESS",
      //"Final Premium Payable",
    ],
  },
  "School Bus": {
    "Basic Details": [
      "IDV",
      // "Depreciation (%)",
      // "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      // "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electrical Accessories",
      "CNG/LPG Kits",
      "Basic OD Premium",
      "Geographical Extn",
      "IMT 23",
      "Anti-Theft",
      "Basic OD Before Discount",
      "Discount on OD",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net OD Premium",
      "Total A"
    ],
    "[B] Addon Coverages": [
      "Zero Dep Premium",
      "RSA/Additional for Addons",
      // "Total Addon Premium",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "Passenger Coverage",
      "Geographical Extn (TP)",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employees",
      //  "Total Liability Premium",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18% [Applied on A+B+C]",
      "Other CESS",
      //"Final Premium Payable",
    ],
  },

  //Miscellaneous Categories
  "Ambulance": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "CNG/LPG kit",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net Own Damage Premium [Total A]",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "LL to Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ],
  },
  "Trailer": {
    "Basic Details": [
      "IDV",
      "No. of Trailers (Attached)",
      "Trailer Towed By",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "IMT 23",
      "CNG/LPG kit",
      "Basic OD before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Trailer Liability Premium",
      "Total Trailer Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      // "LL to Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ],
  },
  "Hearse": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "CNG/LPG kit",
      "Basic OD Premium",
      "IMT23",
      "Basic OD Before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net Own Damage Premium [A]",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "LL to Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ],
  },
  "Pedestrian Controlled Agricultural Tractors": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "CNG/LPG kit",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD Before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      //"Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "LL to Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ]
  },
  "Other MISC Vehicle": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Vehicle Type"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD Premium After discount",
      "Geographical Extn",
      "Overturning For Cranes",
      "IMT 23",
      "Total Own Damage Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A",
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ]
  },
  "Trailer And Other Miscellaneous": {
    "Basic Details": [
      "IDV",
      "Trailer IDV (Attached trailer)",
      "No of Trailers (Attached)",
      "Trailer Towed By",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Trailer OD",
      "Basic OD Premium",
      "Overturning for Cranes",
      "IMT 23",
      "CNG/LPG kit",
      "Basic OD before Discount",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium",
      "Trailer Liability Premium",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      //"Total Liability Premium (B)",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18% [Applied on OD and TP]",
      "Other CESS"
    ],
  },

  //Private Car categories
  "Four Wheeler OD": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Loading Discount Premium",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      //"Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Four Wheeler": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Basic OD after Discount",
      "Loading Discount Premium",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "CNG/LPG kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Electric Four Wheeler OD": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Electric Four Wheeler": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD after Discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "CNG/LPG kit (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Four Wheeler Complete": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD after Discount",
      "Accessories Value",
      // "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "Geographical Extn",
      "Fiber Glass Tank",
      "Driving Tutions",
      // "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
      "Anti-Theft",
      "Handicap",
      "AAI",
      "Voluntary Deduct",
      "Total Basic Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Consumables",
      "Tyre Cover",
      "NCB Protection",
      "Engine Protector",
      "Return To Invoice",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "CNG/LPG kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
  "Electric Four Wheeler Complete": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Kilowatt"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD",
      "Loading Discount Premium",
      "Basic OD after Discount",
      "Accessories Value",
      "Geographical Extn",
      "Fiber Glass Tank",
      "Driving Tutions",
      // "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "Anti-Theft",
      "Handicap",
      "AAI",
      "Voluntary Deduct",
      // "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
      "Total Basic Premium",
      "No Claim Bonus",
      // "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Addon Coverage": [
      "Zero Dep Premium",
      "RSA",
      "Consumables",
      "Tyre Cover",
      "NCB Protection",
      "Engine Protector",
      "Return To Invoice",
      "Other Addon Coverage",
      "Value Added Services",
      "Total B"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium",
      "CNG/LPG kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Restricted TPPD",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
};
