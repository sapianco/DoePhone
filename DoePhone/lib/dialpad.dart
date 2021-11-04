import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sip_ua/sip_ua.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'widgets/top_container.dart';
import 'widgets/action_button.dart';

final String assetName = 'assets/images/Logo_circular_DoePhone.svg';
final Widget svgDoePhoneLogo = SvgPicture.asset(
  assetName,
  semanticsLabel: 'Logo Circular DoePhone',
  height: 100,
	width: 100,
);

class DialPadWidget extends StatefulWidget {
  final SIPUAHelper _helper;
  DialPadWidget(this._helper, {Key key}) : super(key: key);
  @override
  _MyDialPadWidget createState() => _MyDialPadWidget();
}

class _MyDialPadWidget extends State<DialPadWidget>
    implements SipUaHelperListener {
  String _dest;
  SIPUAHelper get helper => widget._helper;
  TextEditingController _textController;
  SharedPreferences _preferences;
  bool _dialpadNumIsVisible = false;
  int _selectedIndex = 0;

  String receivedMsg;

  @override
  initState() {
    super.initState();
    receivedMsg = '';
    _bindEventListeners();
    _loadSettings();
    _initialRegiter();
  }

  void _loadSettings() async {
    _preferences = await SharedPreferences.getInstance();
    _dest = _preferences.getString('dest') ?? 'sip:*43@sapian.sbc.dialbox.cloud';
    _textController = TextEditingController(text: _dest);
    _textController.text = _dest;

    setState(() {});
  }

  void _bindEventListeners() {
    helper.addSipUaHelperListener(this);
  }

  void _initialRegiter() async {
    bool _registerAtStart;
    _registerAtStart = false;
    _preferences = await SharedPreferences.getInstance();
    _registerAtStart = _preferences.getBool('register_at_start') ?? false;

    final _wsExtraHeaders = <String, String>{
      'Origin': ' https://doephone.dialbox.cloud',
      'Host': 'sbc.dialbox.cloud'
    };

    final _iceServers = <Map<String, String>>[
      <String, String>{'url': 'stun:stun.l.google.com:19302'},
      // turn server configuration example.
      {'url': 'stun:sbc.dialbox.cloud:3478'},
      {
        'url': 'turn:sbc.dialbox.cloud:3478',
        'username': 'doephone',
        'credential': 'Esheil0maingoh3i'
      },
    ];
    
    if (_registerAtStart){
      UaSettings settings;
      settings = UaSettings();

      settings.webSocketUrl = _preferences.getString('ws_uri') ?? 'wss://sbc.dialbox.cloud/wss/sip/';
      settings.webSocketSettings.extraHeaders = _wsExtraHeaders;
      //settings.webSocketSettings.allowBadCertificate = true;
      //settings.webSocketSettings.userAgent = 'Dart/2.8 (dart:io) for OpenSIPS.';

      settings.uri = _preferences.getString('sip_uri') ?? 'doephone@sapian.sbc.dialbox.cloud';
      settings.authorizationUser = _preferences.getString('auth_user') ?? 'doephone';
      settings.password = _preferences.getString('password');
      settings.displayName = _preferences.getString('display_name') ?? 'DoePhone';
      settings.userAgent = 'DoePhone SIP Client v1.0.0';
      settings.dtmfMode = DtmfMode.RFC2833;
      settings.iceServers = _iceServers;

      helper.start(settings);
    }
  }

  Future<Widget> _handleCall(BuildContext context,
      [bool voiceonly = false]) async {
    var dest = _textController.text;
    if (dest == null || dest.isEmpty) {
      showDialog<Null>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Target is empty.'),
            content: Text('Please enter a SIP URI or username!'),
            actions: <Widget>[
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      return null;
    }

    final mediaConstraints = <String, dynamic>{'audio': true, 'video': true};

    MediaStream mediaStream;

    if (kIsWeb && !voiceonly) {
      mediaStream =
          await navigator.mediaDevices.getDisplayMedia(mediaConstraints);
      mediaConstraints['video'] = false;
      MediaStream userStream =
          await navigator.mediaDevices.getUserMedia(mediaConstraints);
      mediaStream.addTrack(userStream.getAudioTracks()[0], addToNative: true);
    } else {
      mediaConstraints['video'] = !voiceonly;
      mediaStream = await navigator.mediaDevices.getUserMedia(mediaConstraints);
    }

    helper.call(dest, voiceonly: voiceonly, mediaStream: mediaStream);
    _preferences.setString('dest', dest);
    return null;
  }

  void _handleBackSpace([bool deleteAll = false]) {
    var text = _textController.text;
    if (text.isNotEmpty) {
      setState(() {
        text = deleteAll ? '' : text.substring(0, text.length - 1);
        _textController.text = text;
      });
    }
  }

  void _handleNum(String number) {
    setState(() {
      _textController.text += number;
    });
  }

	
  void _toogleDialpadNum() {
    setState(() {
      _dialpadNumIsVisible = !_dialpadNumIsVisible;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _buildNumPad() {
    var lables = [
      [
        {'1': ''},
        {'2': 'abc'},
        {'3': 'def'}
      ],
      [
        {'4': 'ghi'},
        {'5': 'jkl'},
        {'6': 'mno'}
      ],
      [
        {'7': 'pqrs'},
        {'8': 'tuv'},
        {'9': 'wxyz'}
      ],
      [
        {'*': ''},
        {'0': '+'},
        {'#': ''}
      ],
    ];

    return lables
        .map((row) => Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: row
                    .map((label) => ActionButton(
                          title: '${label.keys.first}',
                          subTitle: '${label.values.first}',
                          onPressed: () => _handleNum(label.keys.first),
                          number: true,
                        ))
                    .toList())))
        .toList();
  }

  List<Widget> _buildDialPad() {
    return [
      Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          TopContainer(
            height: 200,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0, vertical: 0.0
                    ),
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.center,
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        svgDoePhoneLogo,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              child: Text(
                                'DoePhone',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 22.0,
                                  color: Colors.white,
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
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]
            ),
          ),
          Positioned(
            bottom: -25,
            child: Container(
              //width: 360,
              //color: Colors.blue,
              //width: width,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    width: 360,
                    child: TextField(
                      keyboardType: TextInputType.text,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                          borderSide: BorderSide(color: Colors.grey, width: 0.0)
                        ),
                        hintText: "sip:*43@sapian.sbc.dialbox.cloud",
                        filled: true,
                        fillColor: Colors.white70
                      ),
                      controller: _textController,
                    )
                  ),
                ]
              )
            ),
          )
        ]
      ),
      Visibility(
        visible: _dialpadNumIsVisible,
        child: Container(
            width: 300,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildNumPad())),
      ),
      Container(
        height: 25,
      ),
      Container(
          width: 300,
          child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ActionButton(
                    icon: Icons.videocam,
                    onPressed: () => _handleCall(context),
                  ),
                  ActionButton(
                    icon: Icons.dialer_sip,
                    fillColor: Colors.green,
                    onPressed: () => _handleCall(context, true),
                  ),
                  ActionButton(
                    icon: Icons.dialpad,
                    fillColor: Colors.green[700],
                    onPressed: () => _toogleDialpadNum(),
                    //onLongPress: () => _toogleDialpadNum(true),
                  ),
                ],
              )
          )
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DoePhone"),
          backgroundColor: Colors.green[900],
          actions: <Widget>[
            PopupMenuButton<String>(
                onSelected: (String value) {
                  switch (value) {
                    case 'account':
                      Navigator.pushNamed(context, '/register');
                      break;
                    case 'about':
                      Navigator.pushNamed(context, '/about');
                      break;
                    case 'Home':
                      Navigator.pushNamed(context, '/Home');
                      break;
                    default:
                      break;
                  }
                },
                icon: Icon(Icons.menu),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                      PopupMenuItem(
                        value: 'account',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                              child: Icon(
                                Icons.account_circle,
                                color: Colors.black38,
                              ),
                            ),
                            SizedBox(
                              width: 64,
                              child: Text('Account'),
                            )
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'about',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Icon(
                              Icons.info,
                              color: Colors.black38,
                            ),
                            SizedBox(
                              width: 64,
                              child: Text('About'),
                            )
                          ],
                        ),
                      ),
                      // PopupMenuItem(
                      //   value: 'Home',
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //     children: <Widget>[
                      //       Icon(
                      //         Icons.info,
                      //         color: Colors.black38,
                      //       ),
                      //       SizedBox(
                      //         width: 64,
                      //         child: Text('Home'),
                      //       )
                      //     ],
                      //   ),
                      // )
                    ]
                  ),
          ],
        ),
        body: Align(
            alignment: Alignment(0, 0),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildDialPad(),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Center(
                      child: Text(
                    'Status: ${EnumHelper.getName(helper.registerState.state)}',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    )
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: Center(
                      child: Text(
                    'Received Message: ${receivedMsg}',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                    )
                  ),
                ),
              ]
            )
          ),
        bottomNavigationBar: BottomNavigationBar(
          mouseCursor: SystemMouseCursors.grab,
          backgroundColor: Colors.green[900],
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white24,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          //selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          selectedFontSize: 20,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.dialer_sip),
              label: 'Dialer',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.login),
              label: 'Acoount',
            ),
          ],
          currentIndex: _selectedIndex, 
          onTap: _onItemTapped,
        ),
        //floatingActionButton: FloatingActionButton(),
        );
  }

  @override
  void registrationStateChanged(RegistrationState state) {
    setState(() {});
  }

  @override
  void transportStateChanged(TransportState state) {}

  @override
  void callStateChanged(Call call, CallState callState) {
    if (callState.state == CallStateEnum.CALL_INITIATION) {
      Navigator.pushNamed(context, '/callscreen', arguments: call);
    }
  }

  @override
  void onNewMessage(SIPMessageRequest msg) {
    //Save the incoming message to DB
    String msgBody;
    msgBody = msg.request.body as String;
    setState(() {
      receivedMsg = msgBody;
    });
  }
}
