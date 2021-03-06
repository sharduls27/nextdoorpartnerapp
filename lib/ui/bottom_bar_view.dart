import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:nextdoorpartner/ui/orders.dart';
import 'package:nextdoorpartner/ui/products.dart';
import 'package:nextdoorpartner/ui/reviews.dart';
import 'package:nextdoorpartner/util/app_theme.dart';
import 'package:nextdoorpartner/util/custom_toast.dart';
import 'package:nextdoorpartner/util/strings_en.dart';
import '../models/tabIcon_data.dart';

class BottomBarView extends StatefulWidget {
  const BottomBarView({Key key, this.tabIconsList, this.scaffoldKey})
      : super(key: key);

  final List<TabIconData> tabIconsList;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  _BottomBarViewState createState() => _BottomBarViewState();
}

class _BottomBarViewState extends State<BottomBarView>
    with TickerProviderStateMixin {
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        AnimatedBuilder(
          animation: animationController,
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform: Matrix4.translationValues(0.0, 0.0, 0.0),
              child: PhysicalShape(
                color: Colors.white,
                elevation: 16.0,
                clipper: TabClipper(
                    radius: Tween<double>(begin: 0.0, end: 1.0)
                            .animate(CurvedAnimation(
                                parent: animationController,
                                curve: Curves.fastOutSlowIn))
                            .value *
                        38.0),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 80,
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 8, right: 8, top: 4),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: TabIcons(
                                callback: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Products()));
                                },
                                tabIconData: widget.tabIconsList[0],
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                callback: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Reviews()));
                                },
                                tabIconData: widget.tabIconsList[1],
                              ),
                            ),
                            SizedBox(
                              width: Tween<double>(begin: 0.0, end: 1.0)
                                      .animate(CurvedAnimation(
                                          parent: animationController,
                                          curve: Curves.fastOutSlowIn))
                                      .value *
                                  64.0,
                            ),
                            Expanded(
                              child: TabIcons(
                                callback: () {
                                  CustomToast.show(
                                      'Not Yet Completed', context);
                                },
                                tabIconData: widget.tabIconsList[2],
                              ),
                            ),
                            Expanded(
                              child: TabIcons(
                                callback: () {
                                  widget.scaffoldKey.currentState
                                      .openEndDrawer();
                                },
                                tabIconData: widget.tabIconsList[3],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).padding.bottom,
                    )
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
          child: SizedBox(
            width: 66 * 2.0,
            height: 68 + 64.0,
            child: Container(
              alignment: Alignment.topCenter,
              color: Colors.transparent,
              child: SizedBox(
                width: 44 * 2.0,
                height: 44 * 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ScaleTransition(
                    alignment: Alignment.center,
                    scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController,
                            curve: Curves.fastOutSlowIn)),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(0, 8.0),
                              blurRadius: 2.0),
                        ],
                      ),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.white.withOpacity(0.1),
                          highlightColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => Orders()));
                          },
                          child: Column(
                            children: [
                              SizedBox(
                                height: 12,
                              ),
                              Image.asset(
                                'assets/images/orders.png',
                                height: 32,
                                width: 32,
                                color: AppTheme.secondary_color,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              Text(
                                Strings.orders,
                                style: TextStyle(
                                    color: AppTheme.secondary_color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void setRemoveAllSelection(TabIconData tabIconData) {
    if (!mounted) return;
    setState(() {
      widget.tabIconsList.forEach((TabIconData tab) {
        tab.isSelected = false;
        if (tabIconData.index == tab.index) {
          tab.isSelected = true;
        }
      });
    });
  }
}

class TabIcons extends StatefulWidget {
  const TabIcons({Key key, this.tabIconData, this.callback}) : super(key: key);

  final TabIconData tabIconData;
  final Function callback;
  @override
  _TabIconsState createState() => _TabIconsState();
}

class _TabIconsState extends State<TabIcons> with TickerProviderStateMixin {
  @override
  void initState() {
    widget.tabIconData.animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    )..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          if (!mounted) return;
          widget.tabIconData.animationController.reverse();
        }
      });
    super.initState();
  }

  @override
  void dispose() {
    widget.tabIconData.animationController.dispose();
    super.dispose();
  }

  void setAnimation() {
    widget.tabIconData.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Center(
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: () {
            setAnimation();
            widget.callback();
          },
          child: IgnorePointer(
            child: Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                ScaleTransition(
                  alignment: Alignment.center,
                  scale: Tween<double>(begin: 0.88, end: 1.0).animate(
                      CurvedAnimation(
                          parent: widget.tabIconData.animationController,
                          curve:
                              Interval(0.1, 1.0, curve: Curves.fastOutSlowIn))),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 5,
                      ),
                      Icon(widget.tabIconData.icon,
                          size: 32, color: AppTheme.secondary_color),
                      Text(
                        widget.tabIconData.text,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: AppTheme.secondary_color),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TabClipper extends CustomClipper<Path> {
  TabClipper({this.radius = 38.0});

  final double radius;

  @override
  Path getClip(Size size) {
    final Path path = Path();

    final double v = radius * 2;
    path.lineTo(0, 0);
    path.arcTo(Rect.fromLTWH(0, 0, radius, radius), degreeToRadians(180),
        degreeToRadians(90), false);
    path.arcTo(
        Rect.fromLTWH(
            ((size.width / 2) - v / 2) - radius + v * 0.04, 0, radius, radius),
        degreeToRadians(270),
        degreeToRadians(70),
        false);

    path.arcTo(Rect.fromLTWH((size.width / 2) - v / 2, -v / 2, v, v),
        degreeToRadians(160), degreeToRadians(-140), false);

    path.arcTo(
        Rect.fromLTWH((size.width - ((size.width / 2) - v / 2)) - v * 0.04, 0,
            radius, radius),
        degreeToRadians(200),
        degreeToRadians(70),
        false);
    path.arcTo(Rect.fromLTWH(size.width - radius, 0, radius, radius),
        degreeToRadians(270), degreeToRadians(90), false);
    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(TabClipper oldClipper) => true;

  double degreeToRadians(double degree) {
    final double redian = (math.pi / 180) * degree;
    return redian;
  }
}
