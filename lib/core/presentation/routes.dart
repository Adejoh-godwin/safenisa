import 'package:flutter/material.dart';
import 'package:safenisa/core/data/models/menu.dart';
import 'package:safenisa/src/pages/misc/bottomsheet.dart';
import 'package:safenisa/src/pages/misc/crop.dart';
import 'package:safenisa/src/pages/misc/image_popup.dart';
import 'package:safenisa/src/pages/misc/otp.dart';
import 'package:safenisa/src/pages/quotes/quotes1.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:safenisa/src/pages/misc/chat2.dart';
import 'package:safenisa/src/pages/misc/chatui.dart';
import 'package:safenisa/src/pages/misc/sliders.dart';
import 'package:safenisa/src/pages/misc/loaders.dart';
import 'package:safenisa/src/pages/dialogs/dialogs.dart';
import 'package:safenisa/src/pages/misc/sliver_appbar.dart';
import 'package:safenisa/src/pages/misc/form_elements.dart';
import 'package:safenisa/src/pages/misc/springy_slider_page.dart';

final List<dynamic> pages = [
  MenuItem(
    title: "Quotes App",
    icon: FontAwesomeIcons.quoteLeft,
    items: [
      SubMenuItem("Quote Page One", QuotesOnePage(), path: QuotesOnePage.path),
    ],
  ),
  MenuItem(title: "Miscellaneous", items: [
    SubMenuItem("OTP Page", OTPPage(), path: OTPPage.path),
    SubMenuItem('Image/Widget Crop', CropPage(),
        path: CropPage.path, icon: Icons.crop),
    SubMenuItem("Image Popup", ImagePopupPage(), path: ImagePopupPage.path),
    SubMenuItem("Chat Messaages", ChatTwoPage(), path: ChatTwoPage.path),
    SubMenuItem("Form Elements", FormElementPage(), path: FormElementPage.path),
    SubMenuItem("Sliders", SlidersPage(), path: SlidersPage.path),
    SubMenuItem("Alert Dialogs", DialogsPage(), path: DialogsPage.path),
    SubMenuItem("Springy Slider", SpringySliderPage(),
        path: SpringySliderPage.path),
    SubMenuItem("Sliver App Bar", SliverAppbarPage(),
        path: SliverAppbarPage.path),
    SubMenuItem("Loaders", LoadersPage(), path: LoadersPage.path),
    SubMenuItem("ChatUi", ChatUi(), path: ChatUi.path),
    SubMenuItem('Bottomsheet', BottomSheetAwesome(),
        path: BottomSheetAwesome.path),
  ]),
];

SubMenuItem getItemForKey(String key) {
  SubMenuItem item;
  List<dynamic> pag = List<dynamic>.from(pages);
  pag.forEach((page) {
    if (page is SubMenuItem && page.title == key) {
      item = page;
    } else if (page is MenuItem) {
      page.items.forEach((sub) {
        if (sub.title == key) item = sub;
      });
    }
  });
  return item;
}
