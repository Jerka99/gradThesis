import 'package:flutter/material.dart';
import 'package:travel_mate/model.dart';
import 'package:travel_mate/myMap/personal_rides_list.dart';

import '../../AutoScrollingText.dart';
import '../../user_role.dart';

class MyProfile extends StatefulWidget {
  final Function() logOut;
  final Function() fetchPersonalRides;
  final UserData user;
  final PersonalRidesList personalRidesList;
  final Function(int) navigateToAllRides;

  const MyProfile({
    super.key,
    required this.logOut,
    required this.fetchPersonalRides,
    required this.user,
    required this.personalRidesList,
    required this.navigateToAllRides
  });

  @override
  State<MyProfile> createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  late UserRole role;
  late List<PersonalRide> personalRidesList;

  @override
  void initState() {
    widget.fetchPersonalRides();
    role = widget.user.role!;
    personalRidesList = widget.personalRidesList.listOfRides;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MyProfile oldWidget) {
    personalRidesList = widget.personalRidesList.listOfRides;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 20),
      child: Flex(
        direction: Axis.vertical,
        children: [
          SizedBox(
            height: 200,
            child: Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  // Align to the left
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        'Name: ${widget.user.name![0].toUpperCase() + widget.user.name!.substring(1)}',
                        style: TextStyle(
                            fontSize: 33.0, fontWeight: FontWeight.bold)),
                    Text(
                        'Role: ${(role.name[0].toUpperCase() + role.name.substring(1))}',
                        style: TextStyle(fontSize: 33.0, color: Colors.grey)),
                  ],
                ),
                Container(
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: widget.logOut,
                    icon: const Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    // Open door icon
                    label: const Text(
                      'Log out',
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (personalRidesList.isNotEmpty)
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  const Text("ALL YOUR SCHEDULED RIDES", style: TextStyle(fontSize: 33),),
                  const SizedBox(height: 12,),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.blue
                            )),
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: personalRidesList.length,
                            itemBuilder: (context, index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 25),
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom: BorderSide(width: 1, color: Colors.black),
                                    ),
                                ),
                                child: GestureDetector(
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: AutoScrollingText(
                                        text:personalRidesList[index].firstLocation.toString(),
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            offset: Offset(100, 0)),
                                      ),
                                      Container(width: 12),
                                      const Text("-", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
                                      Container(width: 12,),
                                          Expanded(
                                            child: AutoScrollingText(
                                                text:personalRidesList[index].lastLocation.toString(),
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                offset: Offset(100, 0)),
                                          ),
                                    ],
                                  ),
                                  onTap: (){
                                    widget.navigateToAllRides(personalRidesList[index].rideId!);
                                  },
                                ),
                              ),
                                ],
                              );
                            })),
                  ),
                ],
              ),
            )
        ],
      ),
    );
  }
}
