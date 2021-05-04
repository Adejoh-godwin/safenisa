import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:safenisa/Widget/adaptive.dart';
import 'package:safenisa/Widget/loadingWidget.dart';
import 'package:safenisa/Widget/spaces.dart';
import 'package:safenisa/Widget/values.dart';
import 'package:safenisa/assistant/assistantMethods.dart';
import 'package:safenisa/core/presentation/res/assets.dart';
import 'package:safenisa/core/presentation/widgets/rounded_bordered_container.dart';
import 'package:safenisa/home/model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:safenisa/models/blogModel.dart';
import 'package:safenisa/src/widgets/network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Config/config.dart';
import 'article.dart';

final List rooms = [
  {"image": "assets/hotel/room1.jpg", "title": "Awesome room near Bouddha"},
  {"image": "assets/hotel/room2.jpg", "title": "Peaceful Room"},
  {"image": "assets/hotel/room3.jpg", "title": "Beautiful Room"},
  {
    "image": "assets/hotel/room4.jpg",
    "title": "Vintage room near Pashupatinath"
  },
];

// ignore: must_be_immutable
class Tips extends StatelessWidget {
  List<MenuItem> menuList = [
    MenuItem("Home", iconData: FeatherIcons.home, route: '/home'),
    MenuItem("Profile", iconData: FeatherIcons.settings, route: '/profile'),
    MenuItem("contacts", iconData: FeatherIcons.user, route: '/listcontact'),
    MenuItem("Recordings", iconData: Icons.mic, route: '/recording'),
    MenuItem("Tips", iconData: Icons.topic, route: '/recording'),
  ];
  static const String idScreen = "home";
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  SharedPreferences sharedPreferences;

  GoogleMapController newGoogleMapController;
  Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLngPostion = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPostion, zoom: 14);

    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String address = await AssistantMethods.searchCoordinateAddres(position);
    print("this is" + address);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: Colors.pink,
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.pinkAccent,
          child: Icon(Icons.add_circle),
          onPressed: () async {
            Navigator.pushNamed(context, '/addContact');
          }),
      drawer: ClipRRect(
        borderRadius: BorderRadius.only(
          topRight: const Radius.circular(Sizes.RADIUS_60),
          bottomRight: const Radius.circular(Sizes.RADIUS_60),
        ),
        child: Drawer(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.pink,
            ),
            child: Column(
              children: <Widget>[
                DrawerHeader(
                  margin: const EdgeInsets.all(Sizes.MARGIN_0),
                  padding: const EdgeInsets.all(Sizes.PADDING_0),
                  child: _buildDrawerHeader(context),
                  decoration: BoxDecoration(
                    color: Colors.pink,
                  ),
                ),
                ..._buildMenuList(menuList, context),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'challenge_home');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Design Home',
                      style: theme.textTheme.subtitle2.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async {
                    {
                      await _firebaseAuth.signOut();
                    }

                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.logout,
                      color: Colors.amber,
                    ),
                    title: Text(
                      StringConst.LOG_OUT,
                      style: theme.textTheme.subtitle2.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _buildFeaturedNews(),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection("security")
                  .limit(15)
                  .snapshots(),
              builder: (context, dataSnapshot) {
                return !dataSnapshot.hasData
                    ? SliverToBoxAdapter(
                        child: Center(
                          child: circularProgress(),
                        ),
                      )
                    : SliverStaggeredGrid.countBuilder(
                        crossAxisCount: 2,
                        mainAxisSpacing: 1.0,
                        staggeredTileBuilder: (c) => StaggeredTile.fit(1),
                        itemBuilder: (context, index) {
                          BlogModel model = BlogModel.fromJson(
                              dataSnapshot.data.docs[index].data);
                          return _buildRooms(context, model);
                        },
                        itemCount: dataSnapshot.data.docs.length,
                      );
              }),
        ],
      ),
//drawer: Drawer(),
    );
  }

  Widget _buildDrawerHeader(context) {
    // var image = EcommerceApp.sharedPreferences.getString('image');
    var name = EApp.sharedPreferences.getString('name');
    var number = EApp.sharedPreferences.getString('phone');

    var image = '';

    ThemeData theme = Theme.of(context);
    return Stack(
      children: [
        Image.network(
          'https://firebasestorage.googleapis.com/v0/b/quickpower-4556c.appspot.com/o/dp.jpg?alt=media&token=4a98e3dc-7cef-466e-be5d-6b068a85f8ee',
          width: assignWidth(context: context, fraction: 1),
          height: assignHeight(context: context, fraction: 1),
          fit: BoxFit.cover,
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(
            Sizes.PADDING_16,
            Sizes.PADDING_16,
            Sizes.PADDING_16,
            Sizes.PADDING_8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.amber,
                backgroundImage: NetworkImage(
                  (image == null)
                      ? image
                      : 'https://firebasestorage.googleapis.com/v0/b/quickpower-4556c.appspot.com/o/profiledefault.jpg?alt=media&token=8a061fcb-bb88-4396-b5e1-3f85a90abf6c',
                ),
              ),
              SpaceH8(),
              Text(
                name,
                style: theme.textTheme.subtitle1.copyWith(
                  color: AppColors.white,
                ),
              ),
              Text(
                number,
                style: theme.textTheme.bodyText2.copyWith(
                  color: AppColors.purple10,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  List<Widget> _buildMenuList(List<MenuItem> menuItemList, context) {
    ThemeData theme = Theme.of(context);
    List<Widget> menuList = [];
    void navigationPageHome(name, BuildContext pcontext) {
      Navigator.of(context).pushNamed(name);
    }

    for (int index = 0; index < menuItemList.length; index++) {
      menuList.add(
        ListTile(
          leading: Icon(
            menuItemList[index].iconData,
            color: Colors.white,
          ),
          title: Text(
            menuItemList[index].title,
            style: theme.textTheme.subtitle2.copyWith(
              color: AppColors.white,
            ),
          ),
          onTap: () => navigationPageHome(menuItemList[index].route, context),
        ),
      );
    }
    return menuList;
  }

  Widget _buildRooms(BuildContext context, model) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: Container(
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Stack(
                  children: <Widget>[
                    Image.network(model.imageUrl),
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Icon(
                        Icons.star,
                        color: Colors.grey.shade800,
                        size: 20.0,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Icon(
                        Icons.star_border,
                        color: Colors.white,
                        size: 24.0,
                      ),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    Route route = MaterialPageRoute(
                        builder: (context) => ArticleTwoPage(blogModel: model));
                    Navigator.push(context, route);
                  },
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          model.title,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Text(model.shortDescription),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              RaisedButton(
                                color: Colors.pink,
                                onPressed: null,
                                child: Text('Vew'),
                              )
                            ])
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Container(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 15.0,
          ),
          Category(
            backgroundColor: Colors.pink,
            icon: Icons.add,
            title: "Add Contact",
            route: 'listcontact',
          ),
          SizedBox(
            width: 15.0,
          ),
          Category(
              route: 'record',
              backgroundColor: Colors.blue,
              title: "Record",
              icon: Icons.mic),
          SizedBox(
            width: 15.0,
          ),
          Category(
            route: 'tips',
            icon: Icons.note,
            backgroundColor: Colors.orange,
            title: "Tips",
          )
        ],
      ),
    );
  }

  RoundedContainer _buildFeaturedNews() {
    return RoundedContainer(
      height: 270,
      borderRadius: BorderRadius.circular(0),
      color: Colors.pink,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Tips",
            style: TextStyle(
                fontSize: 28.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Swiper(
              pagination: SwiperPagination(margin: const EdgeInsets.only()),
              viewportFraction: 0.9,
              itemCount: 4,
              loop: false,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RoundedContainer(
                    borderRadius: BorderRadius.circular(4.0),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Text(
                            "A complete set of design elements, and their intitutive design.",
                            // ignore: deprecated_member_use
                            style: Theme.of(context).textTheme.title,
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          flex: 2,
                          child: Container(
                            color: Colors.red,
                            child: PNetworkImage(
                              images[1],
                              fit: BoxFit.cover,
                              height: 210,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Category extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color backgroundColor;
  final String route;

  const Category(
      {Key key,
      @required this.icon,
      @required this.title,
      @required this.route,
      this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
        child: InkWell(
      onTap: () {
        Navigator.pushNamed(context, route);
      },
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.all(Radius.circular(5.0))),
        margin: EdgeInsets.symmetric(vertical: 10.0),
        padding: EdgeInsets.all(10.0),
        width: 100,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              height: 5.0,
            ),
            Text(title, style: TextStyle(color: Colors.white))
          ],
        ),
      ),
    ));
  }
}
