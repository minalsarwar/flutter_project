import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_application_1/networking/drawer/about.dart';
import 'package:flutter_application_1/networking/duas/dua_list.dart';
import 'package:flutter_application_1/networking/emotions.dart';
import 'package:flutter_application_1/networking/drawer/faqs.dart';
import 'package:flutter_application_1/networking/favourites_list.dart';
import 'package:flutter_application_1/networking/drawer/feedback.dart';
import 'package:flutter_application_1/networking/journal/journal_entry.dart';
import 'package:flutter_application_1/networking/journal/journal_list.dart';
import 'package:flutter_application_1/networking/reminder.dart';
import 'package:flutter_application_1/networking/app_bar/search.dart';
import 'package:flutter_application_1/networking/app_bar/settings.dart';
import 'package:flutter_application_1/networking/drawer/tasbeeh_counter.dart';
import 'package:flutter_application_1/provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int currentIndex = ref.watch(currentIndexProvider);
    final auth = ref.read(authServiceProvider);
    String appBarTitle = 'Home';

    switch (currentIndex) {
      case 0:
        appBarTitle = 'Home';
        break;
      case 1:
        appBarTitle = 'Favourites';
        break;
      case 2:
        appBarTitle = 'Journal';
        break;
      case 3:
        appBarTitle = 'Emotions';
        break;
      case 4:
        appBarTitle = 'Reminder';
        break;
    }

    void launchSocialMediaLink(String label) async {
      Uri url;
      switch (label) {
        case 'facebook':
          url = Uri.parse('https://www.facebook.com/alifewithallah/');
          break;
        case 'instagram':
          url = Uri.parse('https://www.instagram.com/alifewithallah/?hl=en');
          break;
        case 'twitter':
          url = Uri.parse(
              'https://twitter.com/alifewithallah?ref_src=twsrc%5Egoogle%7Ctwcamp%5Eserp%7Ctwgr%5Eauthor');
          break;
        case 'telegram':
          url = Uri.parse('https://t.me/alifewithallah');
          break;
        case 'whatsapp':
          url = Uri.parse('https://chat.whatsapp.com/IV3CEj2q5AO2LVkNstaMir');
          break;
        default:
          return; // Do nothing for unknown labels
      }

      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    Widget buildSocialIcon(String label, IconData icon) {
      return GestureDetector(
        onTap: () {
          launchSocialMediaLink(label);
        },
        child: Column(
          children: [
            Ink(
              decoration: ShapeDecoration(
                color: Colors.grey[200],
                shape: CircleBorder(),
              ),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  icon,
                  color: CustomColors.mainColor,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.mainColor,
        title: Text(
          appBarTitle,
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchScreen()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
          // IconButton(
          //   icon: Icon(Icons.logout, color: Colors.white),
          //   onPressed: () async {
          //     try {
          //       await auth.signOut();
          //       // Wait for the sign-out operation to complete
          //       await Future.delayed(Duration.zero);
          //       // Refresh controllers and navigate to login
          //       ref.refresh(emailControllerProvider);
          //       ref.refresh(passwordControllerProvider);
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         SnackBar(
          //           content: Text(
          //             'Signing out',
          //             textAlign: TextAlign.center,
          //           ),
          //           duration: Duration(seconds: 1),
          //           backgroundColor: CustomColors.mainColor,
          //         ),
          //       );
          //       Navigator.pushNamedAndRemoveUntil(
          //           context, '/login', (route) => false);
          //     } catch (error) {
          //       print("Error signing out: $error");
          //       // Handle any errors that occur during sign out
          //     }
          //   },
          // ),
        ],
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: Image.asset('android/assets/appLogo.png',
                        height: 80, width: 70),
                  ),
                  Text('Dua Pal',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black)),
                  Text('رفيق الدعاء',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Colors.black)),
                ],
              ),
            ),
            ListTile(
              leading: Image.asset(
                'android/assets/tasbih.png', // Adjust the path to the icon
                width: 30, // Specify the width of the icon
                height: 30, // Specify the height of the icon
                color: CustomColors.mainColor, // Set the desired icon color
              ),
              title: Text(
                'Tasbih Counter',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TasbeehCounter()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat_bubble_outline,
                  size: 28, color: CustomColors.mainColor),
              title: Text('Feedback',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FeedbackScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help_outline_rounded,
                  size: 28, color: CustomColors.mainColor),
              title: Text('FAQs',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaqScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.info_outline_rounded,
                  size: 28, color: CustomColors.mainColor),
              title: Text('About Dua Pal',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AboutScreen()),
                );
              },
            ),
            ListTile(
              leading:
                  Icon(Icons.logout, size: 28, color: CustomColors.mainColor),
              title: Text('Sign Out',
                  style: TextStyle(fontSize: 16, color: Colors.black)),
              onTap: () async {
                try {
                  await auth.signOut();
                  // Wait for the sign-out operation to complete
                  await Future.delayed(Duration.zero);
                  // Refresh controllers and navigate to login
                  ref.refresh(emailControllerProvider);
                  ref.refresh(passwordControllerProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Signing out',
                        textAlign: TextAlign.center,
                      ),
                      duration: Duration(seconds: 1),
                      backgroundColor: CustomColors.mainColor,
                    ),
                  );
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/login', (route) => false);
                } catch (error) {
                  print("Error signing out: $error");
                  // Handle any errors that occur during sign out
                }
              },
            ),
            const SizedBox(height: 260),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                buildSocialIcon('facebook', Icons.facebook),
                buildSocialIcon('instagram', FontAwesomeIcons.instagram),
                buildSocialIcon('twitter', FontAwesomeIcons.twitter),
                buildSocialIcon('telegram', FontAwesomeIcons.telegram),
                buildSocialIcon('whatsapp', FontAwesomeIcons.whatsapp),
              ],
            ),
          ],
        ),
      ),
      body: currentIndex == 1
          ? FavListScreen()
          : currentIndex == 4
              ? ReminderScreen()
              : currentIndex == 3
                  ? EmotionsContent()
                  : currentIndex == 2
                      ? JournalListScreen()
                      : HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: CustomColors.mainColor,
        unselectedItemColor: Colors.grey,
        selectedFontSize: 14,
        unselectedFontSize: 14,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline),
            label: 'Favourites',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_emotions_outlined),
            label: 'Emotions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Reminder',
          ),
        ],
        onTap: (index) {
          print('Tapped on index: $index');
          ref.read(currentIndexProvider.notifier).state = index;
          print(
              'current index: ${ref.watch(currentIndexProvider.notifier).state}');
        },
      ),
    );
  }
}

class HomeContent extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int _currentIndex = 0;
    bool isMainSelected = ref.watch(isMainSelectedProvider);

    return Column(
      children: [
        Container(
          constraints: BoxConstraints(maxWidth: 200),
          padding: EdgeInsets.symmetric(vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(isMainSelectedProvider.notifier).state = true;
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        isMainSelected ? CustomColors.mainColor : Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Ink(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Main',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isMainSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isMainSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(isMainSelectedProvider.notifier).state = false;
                  },
                  style: ElevatedButton.styleFrom(
                    primary:
                        !isMainSelected ? CustomColors.mainColor : Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.all(2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  child: Ink(
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Other',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: !isMainSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: !isMainSelected ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child:
              isMainSelected ? buildMainContent(ref) : buildOtherContent(ref),
        ),
      ],
    );
  }

  Widget buildMainContent(WidgetRef ref) {
    return ListView(
      children: [
        buildCard('Morning', 'android/assets/morning.jpg', () {
          navigateToListView('Morning', ref);
        }),
        buildCard('Evening', 'android/assets/evening.jpg', () {
          navigateToListView('Evening', ref);
        }),
        buildCard('Before Sleep', 'android/assets/beforeSleep.jpg', () {
          navigateToListView('Before Sleep', ref);
        }),
        buildDoubleCard(
          'Salah',
          'android/assets/salah.jpg',
          'After Salah',
          'android/assets/afterSalah.jpg',
          () {
            navigateToListView('Salah', ref);
          },
          () {
            navigateToListView('After Salah', ref);
          },
        ),
        buildCard('Ruqyah Healing', 'android/assets/ruqyah.jpg', () {
          navigateToListView('Ruqyah Healing', ref);
        }),
        buildDoubleCard(
          'Praises of Allah',
          'android/assets/praisesOfAllah.jpg',
          'Salawat',
          'android/assets/salawat.jpg',
          () {
            navigateToListView('Praises of Allah', ref);
          },
          () {
            navigateToListView('Salawat', ref);
          },
        ),
        buildDoubleCard(
          'Quranic Duas',
          'android/assets/quranicDuas.jpg',
          'Sunnah Duas',
          'android/assets/sunnahDuas.jpg',
          () {
            navigateToListView('Quranic Duas', ref);
          },
          () {
            navigateToListView('Sunnah Duas', ref);
          },
        ),
        buildDoubleCard(
          'Istagfar',
          'android/assets/istagfar.jpg',
          'Dhikr of All Times',
          'android/assets/dhikr.jpg',
          () {
            navigateToListView('Istagfar', ref);
          },
          () {
            navigateToListView('Dhikr of All Times', ref);
          },
        ),
        buildCard('Names of Allah', 'android/assets/namesAllah.jpg', () {
          navigateToListView('Names of Allah', ref);
        }),
      ],
    );
  }

  void navigateToListView(String title, WidgetRef ref) {
    ref.read(isEmotionTileSelectedProvider.notifier).state = false;
    ref.read(duaListTitleProvider.notifier).state = title;
    Navigator.push(
      ref.context,
      MaterialPageRoute(
        builder: (context) => DuaListScreen(title: title),
      ),
    );
  }

  Widget buildOtherContent(WidgetRef ref) {
    return GridView.count(
      crossAxisCount: 2,
      children: [
        buildGridCard('Waking Up', 'android/assets/wakingup.jpg', () {
          navigateToListView('Waking Up', ref);
        }),
        buildGridCard('Nightmares', 'android/assets/nightmares.jpg', () {
          navigateToListView('Nightmares', ref);
        }),
        buildGridCard('Clothes', 'android/assets/clothes.jpg', () {
          navigateToListView('Clothes', ref);
        }),
        buildGridCard('Lavatory & Wudu', 'android/assets/wudu.jpg', () {
          navigateToListView('Lavatory & Wudu', ref);
        }),
        buildGridCard('Food & Drink', 'android/assets/food.jpg', () {
          navigateToListView('Food & Drink', ref);
        }),
        buildGridCard('Home', 'android/assets/home.jpg', () {
          navigateToListView('Home', ref);
        }),
        buildGridCard('Adhan & Masjid', 'android/assets/masjid.jpg', () {
          navigateToListView('Adhan & Masjid', ref);
        }),
        buildGridCard('Istikharah', 'android/assets/istikhara.jpg', () {
          navigateToListView('Istikharah', ref);
        }),
        buildGridCard('Gatherings', 'android/assets/gatherings.jpg', () {
          navigateToListView('Gatherings', ref);
        }),
        buildGridCard('Trials & Blessings', 'android/assets/emotions.jpg', () {
          navigateToListView('Trials & Blessings', ref);
        }),
        buildGridCard('Protection of Iman', 'android/assets/iman.jpg', () {
          navigateToListView('Protection of Iman', ref);
        }),
        buildGridCard('Hajj & Umrah', 'android/assets/hajj.jpg', () {
          navigateToListView('Hajj & Umrah', ref);
        }),
        buildGridCard('Travel', 'android/assets/travel.jpg', () {
          navigateToListView('Travel', ref);
        }),
        buildGridCard('Money & Shopping', 'android/assets/shopping.jpg', () {
          navigateToListView('Money & Shopping', ref);
        }),
        buildGridCard('Social Interactions', 'android/assets/social.jpg', () {
          navigateToListView('Social Interactions', ref);
        }),
        buildGridCard('Marriage', 'android/assets/marriage.jpg', () {
          navigateToListView('Marriage', ref);
        }),
        buildGridCard('Death', 'android/assets/death.jpg', () {
          navigateToListView('Death', ref);
        }),
        buildGridCard('Nature', 'android/assets/nature.jpg', () {
          navigateToListView('Nature', ref);
        }),
      ],
    );
  }

  Widget buildCard(String title, String imageAsset, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Stack(
              children: [
                ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.white.withOpacity(0.8),
                    BlendMode.dstATop,
                  ),
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    child: Image.asset(
                      imageAsset,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget buildDoubleCard(String title1, String imageAsset1, String title2,
      String imageAsset2, Function() onTap1, Function() onTap2) {
    return Row(
      children: [
        Expanded(
          child: buildCard(title1, imageAsset1, onTap1),
        ),
        Expanded(
          child: buildCard(title2, imageAsset2, onTap2),
        ),
      ],
    );
  }

  Widget buildGridCard(String title, String imageAsset, Function() onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Card(
          margin: EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ClipRRect(
            borderRadius:
                BorderRadius.circular(15.0), // Adjust the radius as needed
            child: Stack(
              children: [
                Image.asset(
                  imageAsset,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
