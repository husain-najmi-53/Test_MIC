import 'package:flutter/material.dart';

class VehicleTypeScreen extends StatefulWidget {
  const VehicleTypeScreen({super.key});

  @override
  State<VehicleTypeScreen> createState() => _VehicleTypeScreenState();
}

class _VehicleTypeScreenState extends State<VehicleTypeScreen> {
  final Map<String, String> subtypeRouteMap = {
    // Bike
    'Two Wheeler 1 Year OD': '/twoWheeler1YearOD',
    'Two Wheeler 1 Year OD 1 Year TP': '/twoWheeler1YearOD1YearTP',
    'Two Wheeler 1 Year OD 5 Year TP': '/twoWheeler1YearOD5YearTP',
    'Electric Two Wheeler 1 year OD': '/electricTwoWheeler1YearOD',
    'Electric Two Wheeler 1 year OD 1 Year TP': '/electricTwoWheeler1YearOD1YearTP',
    'Electric Two Wheeler 1 year OD 5 Year TP': '/electricTwoWheeler1YearOD5YearTP',
    'Two Wheeler Passeneger carrying': '/twoWheelerPassengerCarrying',

    // Car
    'Private Car 1 Year OD': '/privateCar1YearOD',
    '⁠Private Car 1 Year OD 1 Year TP': '/privateCar1YearOD1YearTP',
    '⁠Private Car 1 Year OD 3 Years TP': '/privateCar1YearOD3YearsTP',
    'Private Car Complete': '/privateCarComplete',
    '⁠Electric Private Car 1 Year OD': '/electricPrivateCar1YearOD',
    '⁠Electric Private Car 1 Year OD 1 Year TP': '/electricPrivateCar1YearOD1YearTP',
    '⁠Electric Private Car 1 Year OD 3 Years TP': '/electricPrivateCar1YearOD3YearsTP',
    '⁠Electric Private Car Complete': '/electricPrivateCarComplete',

    // Goods Carrying
    'Goods Carrying Vehicle': '/goodsCarryingVehicle',
    'Electric goods Carrying Vehicle': '/electricGoodsCarryingVehicle',
    'Three Wheeler Goods Carrying': '/threeWheelerGoodsCarrying',
    'E-Rickshaw Goods Carrying': '/eRickshawGoodsCarrying',

    // Passenger
    'Three Wheeler PCV(Upto 6 Passengers)': '/threeWheelerPCVUpto6',
    'Three Wheeler PCV(More than 6 upto 17 Passengers)': '/threeWheelerPCVMoreThan6',
    'Bus (More than 6 Passenger)': '/busUpto6',
    'Taxi(Upto 6 Passengers)': '/taxiUpto6',
    // 'Bus': '/bus',
    'School Bus': '/schoolBus',

    // Misc
    'Ambulance': '/ambulance',
    'Trailer': '/trailer',
    'Hearse(Dead Body Carry Vehicle)': '/hearses',
    'Pedestrian Controlled Agricultural Tractors': '/agriculturalTractors',
    'Trailer and other MISC': '/trailerAndOtherMisc',
    'Other MISC vehicle': '/otherMiscVehicle',
  };

  final List<Map<String, dynamic>> vehicleTypes = [
    {
      'name': 'Bike',
      'icon': Icons.motorcycle,
      'subtypes': [
        {'name': 'Two Wheeler 1 Year OD', 'icon': Icons.motorcycle},
        {'name': 'Two Wheeler 1 Year OD 1 Year TP', 'icon': Icons.motorcycle},
        {'name': 'Two Wheeler 1 Year OD 5 Year TP', 'icon': Icons.motorcycle},
        {'name': 'Electric Two Wheeler 1 year OD', 'icon': Icons.electric_bike},
        {
          'name': 'Electric Two Wheeler 1 year OD 1 Year TP',
          'icon': Icons.electric_bike
        },
        {
          'name': 'Electric Two Wheeler 1 year OD 5 Year TP',
          'icon': Icons.electric_bike
        },
        {'name': 'Two Wheeler Passeneger carrying', 'icon': Icons.people},
      ],
    },
    {
      'name': 'Private Car',
      'icon': Icons.directions_car,
      'subtypes': [
        {'name': 'Private Car 1 Year OD', 'icon': Icons.directions_car},
        {
          'name': '⁠Private Car 1 Year OD 1 Year TP',
          'icon': Icons.directions_car_filled
        },
        {
          'name': '⁠Private Car 1 Year OD 3 Years TP',
          'icon': Icons.directions_car_filled
        },
        {'name': 'Private Car Complete', 'icon': Icons.directions_car_filled},
        {
          'name': '⁠Electric Private Car 1 Year OD',
          'icon': Icons.directions_car_filled
        },
        {
          'name': '⁠Electric Private Car 1 Year OD 1 Year TP',
          'icon': Icons.directions_car_filled
        },
        {
          'name': '⁠Electric Private Car 1 Year OD 3 Years TP',
          'icon': Icons.directions_car_filled
        },
        {
          'name': '⁠Electric Private Car Complete',
          'icon': Icons.directions_car_filled
        },
      ],
    },
    {
      'name': 'Goods Carrying Vehicle',
      'icon': Icons.local_shipping,
      'subtypes': [
        {'name': 'Goods Carrying Vehicle', 'icon': Icons.local_shipping},
        {
          'name': 'Electric goods Carrying Vehicle',
          'icon': Icons.electric_rickshaw
        },
        {'name': 'Three Wheeler Goods Carrying', 'icon': Icons.local_shipping},
        {'name': 'E-Rickshaw Goods Carrying', 'icon': Icons.electric_rickshaw},
      ],
    },
    {
      'name': 'Passenger Carrying Vehicle',
      'icon': Icons.directions_bus,
      'subtypes': [
        {
          'name': 'Three Wheeler PCV(Upto 6 Passengers)',
          'icon': Icons.directions_bus_filled
        },
        {
          'name': 'Three Wheeler PCV(More than 6 upto 17 Passengers)',
          'icon': Icons.directions_bus_filled
        },
        {'name': 'Taxi(Upto 6 Passengers)', 'icon': Icons.local_taxi}, 
        {'name': 'Bus (More than 6 Passenger)', 'icon': Icons.departure_board},
        {'name': 'School Bus', 'icon': Icons.departure_board},
      ],
    },
    {
      'name': 'Miscellaneous Vehicle',
      'icon': Icons.miscellaneous_services,
      'subtypes': [
        {'name': 'Ambulance', 'icon': Icons.local_hospital},
        {'name': 'Trailer', 'icon': Icons.local_shipping},
        {
          'name': 'Hearse(Dead Body Carry Vehicle)',
          'icon': Icons.airport_shuttle
        },
        {
          'name': 'Pedestrian Controlled Agricultural Tractors',
          'icon': Icons.agriculture
        },
        {
          'name': 'Trailer and other MISC',
          'icon': Icons.miscellaneous_services
        },
        {'name': 'Other MISC vehicle', 'icon': Icons.miscellaneous_services},
      ],
    },
  ];

 @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Select Vehicle Type',
          style: TextStyle(color: Colors.white)),
      backgroundColor: Colors.indigo.shade700,
      elevation: 4,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    body: ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vehicleTypes.length,
      itemBuilder: (context, index) {
        final vehicle = vehicleTypes[index];
        final hasSubtypes = vehicle['subtypes'] != null;

        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: hasSubtypes
              ? ExpansionTile(
                  leading:
                      Icon(vehicle['icon'], size: 30, color: Colors.blue),
                  title: Text(
                    vehicle['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  children: List<Widget>.generate(
                    vehicle['subtypes'].length,
                    (subIndex) {
                      final subtype = vehicle['subtypes'][subIndex];
                      final subtypeName = subtype['name'];
                      final routeName = subtypeRouteMap[subtypeName];

                      return ListTile(
                        leading: Icon(subtype['icon'], color: Colors.grey),
                        title: Text(subtypeName),
                        onTap: () {
                          if (routeName != null) {
                            Navigator.pushNamed(context, routeName);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Route not defined for "$subtypeName"'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
                )
              : ListTile(
                  leading:
                      Icon(vehicle['icon'], size: 30, color: Colors.blue),
                  title: Text(
                    vehicle['name'],
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    final subtypeName = vehicle['name'];
                    final routeName = subtypeRouteMap[subtypeName];

                    if (routeName != null) {
                      Navigator.pushNamed(context, routeName);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content:
                              Text('Route not defined for "$subtypeName"'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                ),
        );
      },
    ),
  );
}
}
