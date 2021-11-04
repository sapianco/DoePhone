import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/top_container.dart';

final String assetName = 'assets/images/Logo_circular_DoePhone.svg';
final Widget svgDoePhoneLogo = SvgPicture.asset(
  assetName,
  semanticsLabel: 'Logo Circular DoePhone',
  height: 100,
	width: 100,
);

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int currentIndex = 0;

  void setBottomBarIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white.withAlpha(55),
      body: Stack(
        children: <Widget>[
          TopContainer(
              height: 200,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          // CircularPercentIndicator(
                          //   radius: 90.0,
                          //   lineWidth: 5.0,
                          //   animation: true,
                          //   percent: 0.75,
                          //   circularStrokeCap: CircularStrokeCap.round,
                          //   progressColor: LightColors.kRed,
                          //   backgroundColor: LightColors.kDarkYellow,
                          //   center: CircleAvatar(
                          //     backgroundColor: LightColors.kBlue,
                          //     radius: 35.0,
                          //     backgroundImage: AssetImage(
                          //       'assets/images/avatar.png',
                          //     ),
                          //   ),
                          // ),
                          svgDoePhoneLogo,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Text(
                                  'DoePhone',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 22.0,
                                    // color: LightColors.kDarkBlue,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              Container(
                                child: Text(
                                  'Softphone WebRTC de DialBox Online Edition',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black45,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ]),
            ),
          //svgDoePhoneLogo,
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: Container(
          //     width: size.width,
          //     height: 80,
          //     child: Stack(
          //       clipBehavior: Clip.none, children: [
          //         CustomPaint(
          //           size: Size(size.width, 80),
          //           painter: BNBCustomPainter(),
          //         ),
          //         Center(
          //           heightFactor: 0.6,
          //           child: FloatingActionButton(
          //             backgroundColor: Colors.orange, 
          //             elevation: 0.1, 
          //             onPressed: () {}, 
          //             child: Icon(Icons.shopping_basket)
          //           ),
          //         ),
          //         Container(
          //           width: size.width,
          //           height: 80,
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //             children: [
          //               IconButton(
          //                 icon: Icon(
          //                   Icons.home,
          //                   color: currentIndex == 0 ? Colors.orange : Colors.grey.shade400,
          //                 ),
          //                 onPressed: () {
          //                   setBottomBarIndex(0);
          //                 },
          //                 splashColor: Colors.white,
          //               ),
          //               IconButton(
          //                   icon: Icon(
          //                     Icons.restaurant_menu,
          //                     color: currentIndex == 1 ? Colors.orange : Colors.grey.shade400,
          //                   ),
          //                   onPressed: () {
          //                     setBottomBarIndex(1);
          //                   }),
          //               Container(
          //                 width: size.width * 0.20,
          //               ),
          //               IconButton(
          //                   icon: Icon(
          //                     Icons.bookmark,
          //                     color: currentIndex == 2 ? Colors.orange : Colors.grey.shade400,
          //                   ),
          //                   onPressed: () {
          //                     setBottomBarIndex(2);
          //                   }),
          //               IconButton(
          //                   icon: Icon(
          //                     Icons.notifications,
          //                     color: currentIndex == 3 ? Colors.orange : Colors.grey.shade400,
          //                   ),
          //                   onPressed: () {
          //                     setBottomBarIndex(3);
          //                   }),
          //             ],
          //           ),
          //         )
          //       ],
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}

class BNBCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = new Paint()
      ..color = Colors.green[900]
      ..style = PaintingStyle.fill;

    Path path = Path();
    path.moveTo(0, 0); // Start
    path.quadraticBezierTo(size.width * 0.20, 0, size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.40, 0, size.width * 0.40, 20);
    path.arcToPoint(Offset(size.width * 0.60, 20), radius: Radius.circular(20.0), clockwise: false);
    path.quadraticBezierTo(size.width * 0.60, 0, size.width * 0.65, 0);
    path.quadraticBezierTo(size.width * 0.80, 0, size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.lineTo(0, 20);
    canvas.drawShadow(path, Colors.black, 5, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
