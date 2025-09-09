const Map<String, Map<String, List<String>>> vehicleCategorySections = {
  // Two Wheeler categories
  "Two Wheeler 1Y OD": {
    "Basic Details": ["IDV", "Year of Manufacture", "Zone", "Cubic Capacity"],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Discount on OD Premium",
      "Basic OD Premium after discount",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Zero Dep Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "IMT 23",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium(A)",
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
      "Passenger Coverage",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      "Total Liability Premium (B)"
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
      "Basic Od Premium",
      "Geographical Ext",
      "IMT 23",
      "Anti-Theft",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD before NCB",
      "NCB",
      "Net Own Damage Premium (A)"
    ],
    "[B] Addon Coverage": [
      "Zero Depreciation",
      "RSA",
      "Total Addon Premium (B)"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total Liability Premium (C)"
    ],
    "[D] Total Premium": [
      "Total Premium (A+B+C)",
      "GST (18%)",
      "Gst (12%) on Basic Tp",
      "Other CESS",
      "Final Premium"
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
      "Basic Od Premium",
      "Geographical Ext",
      "IMT 23",
      "Anti-Theft",
      "Basic OD before Discount",
      "Discount on OD",
      "Basic OD before NCB",
      "NCB",
      "Net Own Damage Premium (A)"
    ],
    "[B]Add-on Coverage": [
      "RSA",
      "Zero Depreciation",
      "Total Addon Premium (B)"
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit (TP)",
      "Geographical Extn (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total Liability Premium (C)"
    ],
    "[D] Total Premium": [
      "Total Premium (A+B+C)",
      "GST (18%)",
      "Gst (12%) on Basic Tp",
      "Other CESS",
      "Final Premium"
    ]
  },
  "Three-Wheeler Goods Carrying": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Basic OD Rate (%)",
      "Basic for Vehicle",
      "External CNG/LPG",
      "Basic Od Premium",
      "IMT 23",
      "OD Before Discount",
      "Discount on OD",
      "OD Before NCB",
      "NCB",
      "Net OD Premium"
    ],
    "[B] Liability Premium": [
      "Basic TP",
      "Restricted TPPD",
      "CNG TP",
      "PA Owner Driver",
      "LL to Paid Driver",
      "Total TP Premium"
    ],
    "[C] Total Premium": [
      "Total Premium (OD+TP)",
      "GST (18%)",
      "Gst (12%) on Basic Tp",
      "Other Cess",
      "Final Premium"
    ]
  },
  "E-Rickshaw Goods Carrying": {
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
      "OD Before Discount",
      "Discount on OD Premium",
      "Loading on Discount",
      "OD Before NCB",
      "NCB",
      "Net OD Premium"
    ],
    "[B] Addon Coverage": ["Value Added Service", "Total Addon Premium:"],
    "[C] Liability Premium": [
      "Basic TP",
      "Restricted TPPD",
      "PA Owner Driver",
      "LL to Paid Driver",
      "Total TP Premium",
    ],
    "[D] Total Premium": [
      "Total Premium (OD+TP)",
      "GST (18%)",
      "Other Cess",
      "Final Premium"
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
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG Kit Loading",
      "Basic OD Premium",
      "IMT 23 Loading",
      "Basic OD before Discount",
      "Discount on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net OD Premium[A]",
    ],
    "[B] Liability Premium": [
      "Base TP Premium",
      "Passenger Coverage",
      "CNG/LPG kit",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      "Total Liability Premium",
    ],
    "[C] Total Premium": [
      "Total Premium before Taxes",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS (%)",
      "Final Premium Payable",
    ],
  },
  "Three Wheeler PCV (More Than 6 Upto 17 passenger)": {
    "Basic Details": [
      // "IDV",
      // "Depreciation %",
      "Current IDV",
      "Year of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic For Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG Kit(Externally Fitted)",
      "Basic OD Premium",
      "IMT 23 Loading",
      "Basic OD before Discount",
      "Discount on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net OD Premium(A)",
    ],
    "[B] Liability Premium": [
      "Basic TP Premium",
      "Passenger Coverage",
      "CNG/LPG kit",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Restricted TPPD",
      "Total Liability Premium (B)",
    ],
    "[C] Total Premium": [
      "Total Premium before GST[A+B]",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS (%)",
      "Final Premium Payable",
    ],
  },
  "Taxi (Upto 6 Passengers)": {
    "Basic Details": [
      // "IDV",
      // "Depreciation (%)",
      "Current IDV",
      "Year of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
      "Cubic Capacity" // added this
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate (%)",
      "Basic for Vehicle",
      "Electronic/Electrical Accessories",
      "CNG/LPG kits(Externally Fitted)",
      "Basic OD Premium",
      "Anti Theft Discount",
      "Basic OD Before Discount",
      "Discount on OD Premium (%)",
      "Basic OD Before NCB",
      "No Claim Bonus (%)",
      "Net OD Premium[A]",
      // "Discount Amount",
    ],
    "[B] Addon Coverage": [
      "Zero Depreciation Premium",
      "RSA Amount",
      "Total Addon Premium",
    ],
    "[C] Liability Premium": [
      "Liability Premium (TP)",
      "Passenger Coverage",
      "CNG/LPG Kit",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total C (Liability Premium)"
    ],
    "[D] Total Premium": [
      "Premium Before GST(A + B + C)",
      'GST @ 18% [Applied on OD and TP]',
      "Other CESS (%)",
      "Other CESS Amount",
      "Final Premium Payable"
    ]
  },
  "Bus More than 6 Passenger": {
    "Basic Details": [
      // "IDV (₹)",
      // "Depreciation (%)",
      "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate(₹)",
      "Basics for Vehicle (₹)",
      "Electrical Accessories (₹)",
      "CNG/LPG Kits (Externally Fitted) (₹)",
      "Basic OD Premium (₹)",
      "Geographical Extension (₹)",
      "IMT 23 Applied",
      "Anti Theft Applied",
      "Basic OD Before Discount",
      "Discount on OD Premium (₹)",
      "Basic OD Before Ncb",
      "NCB Amount (₹)",
      "Net OD Premium (₹)",
    ],
    "[B] Addon Coverages": [
      "Zero Depreciation",
      "RSA/Addons (₹)",
      "Total Addon Premium",
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium (₹)",
      "Passenger Coverage",
      "Geographical Extn",
      "CNG/LPG Kits",
      "PA to Owner Driver (₹)",
      "LL to Paid Driver (₹)",
      "LL to Other Employees (₹)",
      "Total Liability Premium (₹)",
    ],
    "[D] Total Premium": [
      "Premium Before GST",
      "GST @ 18% [Applied on A+B+C]",
      "Other CESS Amount (₹)",
      "Final Premium Payable (₹)",
    ],
  },
  "School Bus": {
    "Basic Details": [
      // "IDV (₹)",
      // "Depreciation (%)",
      "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate(₹)",
      "Basics for Vehicle (₹)",
      "Electrical Accessories (₹)",
      "CNG/LPG Kits (Externally Fitted) (₹)",
      "Basic OD Premium (₹)",
      "Geographical Extension (₹)",
      "IMT 23 Applied",
      "Anti Theft Applied",
      "Basic OD Before Discount",
      "Discount on OD Premium (₹)",
      "Basic OD Before Ncb",
      "NCB Amount (₹)",
      "Net OD Premium (₹)",
    ],
    "[B] Addon Coverages": [
      "Zero Depreciation",
      "RSA/Addons (₹)",
      "Total Addon Premium",
    ],
    "[C] Liability Premium": [
      "Basic Liability Premium (₹)",
      "Passenger Coverage",
      "Geographical Extn",
      "CNG/LPG Kits",
      "PA to Owner Driver (₹)",
      "LL to Paid Driver (₹)",
      "LL to Other Employees (₹)",
      "Total Liability Premium (₹)",
    ],
    "[D] Total Premium": [
      "Premium Before GST",
      "GST @ 18% [Applied on A+B+C]",
      "Other CESS Amount (₹)",
      "Final Premium Payable (₹)",
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
      "CNG/LPG kit (Externally Fitted)",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD Premium Before discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium [Total A]"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit",
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
      "CNG/LPG kit (Externally Fitted)",
      "Basic OD Premium Before discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Trailer Liability Premium (TP)",
      "Total Trailer Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit",
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
      "CNG/LPG kit (Externally Fitted)",
      "Basic OD Premium",
      "IMT23",
      "Basic OD Before Discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium [A]"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit",
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
      "CNG/LPG kit (Externally Fitted)",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD Before Discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      // "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee/Other",
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
      "Discount on OD Premium",
      "Basic OD Premium After discount",
      "Geographical Ext",
      "Overturning For Cranes",
      "IMT 23",
      "Total Own Damage Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
      "Geographical Extension",
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
      "CNG/LPG kit (Externally Fitted)",
      "Basic OD Premium before discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Total A"
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Trailer Liability Premium (TP)",
      "Restricted TPPD",
      "CNG/LPG Kit",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "Total Liability Premium (B)"
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Loading Discount Premium",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Discount on OD Premium",
      "Basic OD Premium after discount",
      "Loading Discount Premium",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Liability Premium (TP)",
      "CNG/LPG kit",
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
      "Discount on OD Premium",
      "Loading Discount Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Discount on OD Premium",
      "Loading Discount Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Liability Premium (TP)",
      "CNG/LPG kit",
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
      "Discount on OD Premium",
      "Loading Discount Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      // "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "Geographical Extn",
      "Fiber Glass Tank",
      "Driving Tutions",
      // "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
      "AntiTheft",
      "Handicap",
      "AAI",
      "VoluntaryDeduct",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Liability Premium (TP)",
      "CNG/LPG kit",
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
      "Discount on OD Premium",
      "Loading Discount Premium",
      "Basic OD Premium after discount",
      "Accessories Value",
      "Geographical Extn",
      "Fiber Glass Tank",
      "Driving Tutions",
      // "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "AntiTheft",
      "Handicap",
      "AAI",
      "VoluntaryDeduct",
      // "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
      "Total Basic Premium",
      "No Claim Bonus",
      "Net Own Damage Premium",
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
      "Liability Premium (TP)",
      "CNG/LPG kit",
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
