import 'package:flutter/material.dart';
import 'package:movies/core/resources/AssetsManager.dart';
import 'package:movies/core/resources/ColorManager.dart';
import 'package:movies/core/reusable_components/custom_button.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: ColorManager.screen_background,
      appBar: AppBar(
        backgroundColor: ColorManager.navbarColor,
        centerTitle: true,
        title: Text(
          "profile",
          style: TextStyle(
            color: ColorManager.yellow,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                color: ColorManager.navbarColor,
                height: screenHeight * 0.25,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(AssetsManager.red_Avatar),
                          const SizedBox(width: 50),
                          Column(
                            children: [
                              Text("Wish List"),
                              const SizedBox(height: 10),
                              Text("10"),
                            ],
                          ),
                          const SizedBox(width: 50),
                          Column(
                            children: [
                              Text("History"),
                              const SizedBox(height: 10),
                              Text("10"),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          const SizedBox(height: 50),
                          Column(
                            children: [
                              Text(
                                "John Safwat",
                                style: TextStyle(fontSize: 20),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Expanded(
                        flex: 3,
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Container(
                                // width: screenWidth * 0.60,
                                child: CustomButton(
                                  title: Text("Edit Profile"),
                                  onclick: () {},
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 1,
                              child: Container(
                                // width: screenWidth * 0.25,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 16,
                                    ),
                                    backgroundColor: ColorManager.red,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                  ),
                                  child: Text(
                                    "Exit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
