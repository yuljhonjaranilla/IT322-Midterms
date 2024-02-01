import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lawod/components/bottomnav.dart';
import 'package:lawod/pages/Community%20Support/community.dart';
import 'package:lawod/pages/Marketplace/Marketplace%20Seller/sell_product.dart';
import 'package:lawod/pages/Marketplace/Marketplace%20Seller/user_account.dart';
import 'package:lawod/pages/Marketplace/Marketplace%20Seller/view_orders.dart';
import 'package:lawod/pages/Marketplace/Marketplace%20Seller/view_products.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

import '../marketplace.dart';
import 'fisherfolk_registration.dart';

class FisherfolkLanding extends StatefulWidget {
  const FisherfolkLanding({Key? key}) : super(key: key);

  Future<Map<String, dynamic>> getFisherfolkAccountData(String userId) async {
    final DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc.data() ?? {};
  }

  @override
  State<FisherfolkLanding> createState() => _FisherfolkLandingState();
}

class _FisherfolkLandingState extends State<FisherfolkLanding> {
  String userName = '';
  String storeLocation = '';

  @override
  void initState() {
    super.initState();
    fetchFisherfolkData();
  }

  Future<void> fetchFisherfolkData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final DocumentSnapshot fisherfolkDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('accounts')
            .doc('fisherfolk')
            .get();

        if (fisherfolkDoc.exists &&
            fisherfolkDoc.data() is Map<String, dynamic>) {
          Map<String, dynamic> fisherfolkData =
              fisherfolkDoc.data() as Map<String, dynamic>;
          if (fisherfolkData['storeName'] != null &&
              fisherfolkData['storeLocation'] != null) {
            setState(() {
              userName = fisherfolkData['storeName'];
              storeLocation = fisherfolkData['storeLocation'];
            });
          } else {
            // If there's no storeName or storeLocation, then we must fill it in
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => FisherfolkRegistration()),
            );
          }
        } else {
          // If the document doesn't exist, we need to create it
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => FisherfolkRegistration()),
          );
        }
      }
    } catch (error) {
      if (kDebugMode) {
        print('Error fetching Fisherfolk data: $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const double avatarRadius = 65.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Seller',
          style: TextStyle(
            color: Color(0xFF196DFF),
            fontWeight: FontWeight.bold,
            fontSize: 30,
            fontFamily: 'Proxima Nova',
          ),
        ),
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.only(left: 20.0),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
      body: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Column(
            children: [
              const SizedBox(height: avatarRadius + 5), // Space for the avatar
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => const UserAccount()),
                  ); // Replace with your route
                },
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, avatarRadius, 20, 20),
                  margin: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF196DFF),
                        Color(0xFF0054E5),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        userName,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Proxima Nova',
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        storeLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                '10',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFAB19),
                                  fontFamily: 'Proxima Nova',
                                ),
                              ),
                              Text(
                                'Products',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: 'Proxima Nova',
                                    color: Colors.white),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '4.9',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFFAB19),
                                  fontFamily: 'Proxima Nova',
                                ),
                              ),
                              Text(
                                'Rating',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Proxima Nova',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Container(
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFFFFAB19),
                      Color(0xFFF0C735)
                    ], // Linear gradient color
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Your total sales',
                          style: TextStyle(
                              fontSize: 18,
                              fontFamily: 'Proxima Nova',
                              color: Colors.white),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '₱ 12,500', // Replace with your dynamic data
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: 'Proxima Nova',
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const SellProduct()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFFAD1B),
                        // Text color
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        elevation: 4,
                        // Shadow elevation
                        shadowColor:
                            Colors.grey.withOpacity(0.5), // Shadow color
                      ),
                      child: const Text(
                        'Sell Now',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Proxima Nova',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildCustomButton(
                    context,
                    'assets/icons/products.png',
                    'Products',
                  ),
                  _buildCustomButton(
                    context,
                    'assets/icons/orders.png',
                    'Orders',
                  ),
                ],
              ),
            ],
          ),
          const Positioned(
            top: 6.5, // Adjust this value as needed
            child: CircleAvatar(
              radius: avatarRadius,
              backgroundColor: Colors.transparent,
              child: CircleAvatar(
                radius: avatarRadius,
                backgroundImage: NetworkImage(
                  'https://drive.google.com/uc?export=view&id=1Dc-e2GPOpqWgumRNt8kLVp6b_ztKI2yw',
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const Community()));
          } else if (index == 1) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const MarketPlace()));
          } else if (index == 2) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const UserAccount()));
          }
        },
      ),
    );
  }

  Widget _buildCustomButton(
      BuildContext context, String imagePath, String label) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 0.5,
            blurRadius: 10,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          if (label == 'Products') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ViewProducts(),
            ));
          }
          if (label == 'Orders') {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const ViewOrders(),
            ));
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(58, 25, 58, 25),
              child: Image.asset(imagePath, width: 48), // Asset image
            ),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF0A1034),
                fontWeight: FontWeight.bold,
                fontFamily: 'Proxima Nova',
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class CustomCurvedNavigationBar extends StatelessWidget {
  final int index;
  final Function(int) onNavigationTap;

  const CustomCurvedNavigationBar({
    Key? key,
    required this.index,
    required this.onNavigationTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
        index: index,
        height: 70.0,
        items: <Widget>[
          Image.asset('assets/images/marketplaceseller/communitybtn.png',
              width: 40, height: 30, color: Colors.white),
          Image.asset('assets/images/marketplaceseller/marketplacebtn.png',
              width: 40, height: 30, color: Colors.white),
          Image.asset('assets/images/marketplaceseller/accountbtn.png',
              width: 40, height: 30, color: Colors.white),
        ],
        color: const Color(0xFFE0ECF8),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: const Color(0xFF196DFF),
        animationDuration: const Duration(milliseconds: 300),
        onTap: onNavigationTap);
  }
}
