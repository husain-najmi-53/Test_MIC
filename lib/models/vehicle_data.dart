// Map defining sections and their fields per vehicle category.
// Replace the sample fields with your actual field names from result screens.

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
    "[B] Liability Premium": [
      "Liability Premium (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
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
    "[B] Liability Premium": [
      "Liability Premium (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
      "Other CESS"
    ]
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
      "Accessories Value",
      "IMT 23",
      "Discount on OD Premium",
      "Basic OD Premium after discount",
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
      "Geographical Ext (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total Liability Premium (C)"
    ],
    "[D] Total Premium": [
      "Total Premium (A+B+C)",
      "GST (18%)",
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
      "Geographical Ext (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Other Employee",
      "Total Liability Premium (C)"
    ],
    "[D] Total Premium": [
      "Total Premium (A+B+C)",
      "GST (18%)",
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
      "Base OD Rate (%)",
      "Basic OD Premium",
      "IMT 23 Loading",
      "CNG/LPG Kit Loading",
      "External CNG/LPG Kit Loading",
      "Total OD before Discount",
      "Discount on OD Premium (%)",
      "Discount Amount",
      "OD after Discount",
      "No Claim Bonus (%)",
      "NCB Amount",
      "Net OD Premium",
    ],
    "[B] Liability Premium": [
      "Base TP Premium",
      "Restricted TPPD",
      "TP Premium after restriction",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total Liability Premium (TP + PA + LL)",
    ],
    "[C] Total Premium": [
      "Total Premium before Taxes",
      "GST @ 18%",
      "Other CESS (%)",
      "Other CESS Amount",
      "Final Premium Payable",
    ],
  },
  "Three Wheeler PCV (More Than 6 Upto 17 passenger)": {
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
      "Base OD Rate (%)",
      "Basic OD Premium",
      "IMT 23 Loading",
      "CNG/LPG Kit Loading",
      "External CNG/LPG Kit Loading",
      "Total OD before Discount",
      "Discount on OD Premium (%)",
      "Discount Amount",
      "OD after Discount",
      "No Claim Bonus (%)",
      "NCB Amount",
      "Net OD Premium",
    ],
    "[B] Liability Premium": [
      "Base TP Premium",
      "Restricted TPPD",
      "TP Premium after restriction",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total Liability Premium (TP + PA + LL)",
    ],
    "[C] Total Premium": [
      "Total Premium before Taxes",
      "GST @ 18%",
      "Other CESS (%)",
      "Other CESS Amount",
      "Final Premium Payable",
    ],
  },
  "Taxi (Upto 6 Passengers)": {
    "Basic Details": [
      "IDV",
      // "Depreciation (%)",
      // "Current IDV",
      "Year of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers"
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate (%)",
      "Basic OD Premium",
      "Discount on OD Premium (%)",
      "Discount Amount",
      "Anti Theft Discount",
      "OD Premium after Discounts",
      "Accessories Loading",
      "No Claim Bonus (%)",
      "NCB Amount",
      "Net OD Premium",
      "Zero Depreciation Premium",
      "RSA Amount",
      "Total A (Net OD Premium + Zero Dep + RSA)"
    ],
    "[B] Liability Premium": [
      "Liability Premium (TP)",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "Total B (Liability Premium)"
    ],
    "[C] Total Premium": [
      "Total Package Premium (A + B)",
      "GST @ 18%",
      "Other CESS (%)",
      "Other CESS Amount",
      "Final Premium Payable"
    ]
  },
  "Bus Upto 6 Passenger": {
    "Basic Details": [
      "IDV (₹)",
      // "Depreciation (%)",
      // "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Basic OD Rate (%)",
      'Electrical/Electronic Accessories (₹)',
      "CNG/LPG Kits (Externally Fitted) (₹)",
      "Basic OD Premium (₹)",
      "IMT 23 Loading (₹)",
      "Discount on OD Premium (%)",
      "Discount Amount (₹)",
      "OD Premium after Discount (₹)",
      "CNG/LPG Kit Loading (₹)",
      "Total OD Premium before NCB (₹)",
      "No Claim Bonus (%)",
      "NCB Amount (₹)",
      "Net OD Premium (₹)",
    ],
    "[B] Liability Premium": [
      "TP Premium (₹)",
      "Restricted TPPD",
      "PA to Owner Driver (₹)",
      "LL to Paid Driver (₹)",
      "Premium Before Cess (₹)",
    ],
    "[C] Total Premium": [
      "Other Cess (%)",
      'Other Cess Amount (₹)',
      "GST @ 18% (₹)",
      "Final Premium Payable (₹)",
    ],
  },
  "School Bus": {
    "Basic Details": [
      "IDV (₹)",
      // "Depreciation (%)",
      // "Current IDV (₹)",
      "Year Of Manufacture",
      "Zone",
      "Age of Vehicle",
      "No. of Passengers",
    ],
    "[A] Own Damage Premium Package": [
      "Basic OD Rate (%)",
      "Electrical Accessories (₹)",
      "CNG/LPG Kits (Externally Fitted) (₹)",
      "Basic OD Premium (₹)",
      "Geographical Extension (₹)",
      "IMT 23 Applied",
      "Anti Theft Applied",
      "Discount on OD Premium (%)",
      "Discount on OD Premium (₹)",
      "No Claim Bonus (%)",
      "Net OD Premium (₹)",
      "OD Premium after Discount (₹)",
      "RSA/Addons (₹)",
      "NCB Amount (₹)",
      "Total Basic Premium (₹)",
    ],
    "[B] Liability Premium": [
      "TP Premium (₹)",
      "CNG/LPG Kits",
      "PA to Owner Driver (₹)",
      "LL to Paid Driver (₹)",
      "LL to Other Employees (₹)",
      "Premium Before Cess (₹)",
    ],
    "[C] Total Premium": [
      "Other CESS (%)",
      "Other CESS Amount (₹)",
      "GST @ 18% (₹)",
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
      "CNG/LPG kit (Externally Mounted)",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD Premium Before discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Total A"
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
      "GST @ 18%",
      "Other CESS"
    ],
  },
  "Trailer": {
    "Basic Details": [
      "IDV",
      "no of Trailers (Attached)",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
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
      "GST @ 18%",
      "Other CESS"
    ],
  },
  "Hearses": {
    "Basic Details": [
      "IDV",
      "Year of Manufacture",
      "Zone",
    ],
    "[A] Own Damage Premium Package": [
      "Vehicle Basic Rate",
      "Basic for Vehicle",
      "CNG/LPG kit (Externally Mounted)",
      "Basic OD Premium",
      "IMT 23",
      "Basic OD Before Discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Total A"
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
      "GST @ 18%",
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
      "Basic OD Premium Before Discount",
      "Discount on OD Premium",
      "Loading on OD Premium",
      "Basic OD Before NCB",
      "No Claim Bonus",
      "Net Own Damage Premium",
      "Total A"
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
      "GST @ 18%",
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
      "No Claim Bonus",
      "Net Own Damage Premium",
    ],
    "[B] Liability Premium": [
      "Basic Liability Premium (TP)",
      "Geographical Ext",
      "PA to Owner Driver",
      "LL to Paid Driver",
      "LL to Employee Other than Paid Driver",
      "Total B"
    ],
    "[C] Total Premium": [
      "Total Package Premium[A+B]",
      "GST @ 18%",
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
      "Basic OD Before Discount",
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
      "LL to Employee/Other",
      "Total Liability Premium (B)"
    ]
  },
  //Private Car categories
  "Four Wheeler": {
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
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
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
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
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
      "Basic OD Premium after discount",
      "Accessories Value",
      "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
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
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
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
      "Basic OD Premium after discount",
      "Accessories Value",
      "Optional Extensions(GeoExt+FiberGT+DrTutions)",
      "Total Discounts(AntiTheft+Handicap+AAI+VoluntaryDeduct)",
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
      "PA to Owner Driver",
      "LL to Paid Driver",
      "PA to Unnamed Passenger",
      "Total C"
    ],
    "[D] Total Premium": [
      "Total Package Premium[A+B+C]",
      "GST @ 18%",
      "Other CESS"
    ]
  },
};
// Add similar entries for the other 3 categories
