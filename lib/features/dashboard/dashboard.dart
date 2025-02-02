import 'package:empapp/barrel.dart';
import 'package:empapp/features/authentication/utils/provider.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final User? user = FirebaseAuth.instance.currentUser;

  late bool defprofileboy;
  late bool defprofilegirl;

  @override
  void initState() {
    super.initState();
    updateSharedPrefs();
  }

  // update shared preferences
  void updateSharedPrefs() async {
    SharedPreferences logindata = await SharedPreferences.getInstance();
    logindata.setBool('login', false);
  }

  void _onItemTapped(int index) {
    // Handle navigation based on index
    setState(() {
      _selectedIndex = index;
    });

    if (index == 1) {
      Navigator.of(context)
          .push(
        PageTransition(
          type: PageTransitionType.rightToLeft,
          childCurrent: const DevicesHome(),
          duration: const Duration(milliseconds: 700),
          reverseDuration: const Duration(milliseconds: 700),
          child: const DevicesHome(),
        ),
      )
          .then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    } else if (index == 2) {
      Navigator.of(context)
          .push(
        PageTransition(
          type: PageTransitionType.rightToLeft,
          childCurrent: const Notifications(),
          duration: const Duration(milliseconds: 700),
          reverseDuration: const Duration(milliseconds: 700),
          child: const Notifications(),
        ),
      )
          .then((_) {
        setState(() {
          _selectedIndex = 0;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primaryFixed,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.white, // Set your desired color here
          ),
          title: const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              'Emission Pulse',
              style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.white),
            ),
          ),
          backgroundColor: Theme.of(context)
              .colorScheme
              .primaryFixed, // Setting the background color
          actions: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                icon: const Icon(
                  Icons.settings,
                  color: Colors.white,
                ),
                onPressed: () {
                  // navigate to settings page
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const SettingsPage())
                      );
                },
              ),
            ),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(user?.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SingleChildScrollView(
                child: Container(
                  height: 800,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            }

            if (snapshot.hasError) {
              return SingleChildScrollView(
                child: Container(
                  height: 800,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: const Center(
                    child: Text('Error fetching user details'),
                  ),
                ),
              );
            }

            Map<String, dynamic> userData =
                snapshot.data!.data() as Map<String, dynamic>;
            if (userData['gender'] == 'male') {
              defprofileboy = true;
              defprofilegirl = false;
            } else {
              defprofileboy = false;
              defprofilegirl = true;
            }

            return SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    decoration: const BoxDecoration(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20)),
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  const Text(
                                    'Hello ',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 25.0),
                                  ),
                                  Text(
                                    userData['fullname'],
                                    style: TextStyle(
                                        color: appGreen,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 25.0),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Profile()),
                                  );
                                },
                                child: profileProvider.image != null
                                    ? CircleAvatar(
                                        radius: 25,
                                        backgroundImage:
                                            MemoryImage(profileProvider.image!),
                                      )
                                    : userData['hasprofpic']
                                        ? CircleAvatar(
                                            radius: 25,
                                            backgroundImage: NetworkImage(
                                                userData['userimage']),
                                          )
                                        : CircleAvatar(
                                            radius: 25,
                                            backgroundImage: AssetImage(
                                                defprofilegirl
                                                    ? "assets/img/userdefgirl.png"
                                                    : "assets/img/userdefboy.png"),
                                          ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5.0),
                              child: Text(
                                'See your carbon footprint for today!',
                                style: TextStyle(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 14.0),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                           Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CirclerIndicator(
                                    timeframe: 'Today', weight: userData['userems']['wed']['total'].toDouble()),
                                const Padding(
                                  padding: EdgeInsets.only(top: 16.0),
                                  child: Text(
                                    'Good Job!',
                                    style: TextStyle(
                                        fontWeight: FontWeight.normal,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(right: 40.0),
                            child: SmallAppButton(
                                empuser:  userData,
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Details(empuser: userData,)),
                                  );
                                },
                                buttonText: "View Details"),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 10),
                              GasBar(
                                  gas: "CO₂",
                                  time: "captured 2 minutes ago",
                                  weight: '${userData['userems']['wed']['CO2'].toString()}.0'),
                              const SizedBox(height: 20),
                              GasBar(
                                  gas: "NOx",
                                  time: "captured 2 minutes ago",
                                  weight: '${userData['userems']['wed']['NOx'].toString()}.0'),
                              const SizedBox(height: 20),
                              GasBar(
                                  gas: "SO₂",
                                  time: "captured 2 minutes ago",
                                  weight: '${userData['userems']['wed']['SO2'].toString()}.0'),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const DeviceBox(),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Tips for ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                Text(
                                  'Sustainability',
                                  style: TextStyle(
                                      color: appGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          const TipsBox(
                              imagePath: "assets/img/tips1.png",
                              heading: "Green Route",
                              tip:
                                  "Leave your car behind and take a greener route, walking, biking or public transport. Reduce emissions, save money, and stay fit on the go."),
                          const TipsBox(
                              imagePath: "assets/img/tips2.png",
                              heading: "Reduce, Reuse, Recycle",
                              tip:
                                  "A simple mantra that encourages us to be mindful of our consumption habits and minimize waste by finding new uses for existing items"),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Row(
                              children: [
                                const Text(
                                  'Ads For ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                                Text(
                                  'You',
                                  style: TextStyle(
                                      color: appGreen,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25.0),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              "assets/img/ad.png",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Theme.of(context)
            .colorScheme
            .secondary, // Set your desired background color
        selectedItemColor: Theme.of(context)
            .colorScheme
            .onPrimary, // Set the color for the selected item
        unselectedItemColor: Theme.of(context)
            .colorScheme
            .onPrimary, // Set the color for the unselected items
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Iconify(
                color: Theme.of(context).colorScheme.onPrimary,
                MaterialSymbols.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Iconify(
                color: Theme.of(context).colorScheme.onPrimary,
                MaterialSymbols.devices_other), // widget
            label: 'Devices', // Remove label text
          ),
          BottomNavigationBarItem(
            icon: Iconify(
                color: Theme.of(context).colorScheme.onPrimary, Cil.bell),
            label: 'Notifications', // Remove label text
          ),
        ],
      ),
    );
  }
}
