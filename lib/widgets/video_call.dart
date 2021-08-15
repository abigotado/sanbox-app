import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sandbox/widgets/signaling.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCall extends StatefulWidget {
  VideoCall({Key? key}) : super(key: key);

  @override
  _VideoCallState createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  Signaling signaling = Signaling();
  RTCVideoRenderer _localRenderer = RTCVideoRenderer();
  RTCVideoRenderer _remoteRenderer = RTCVideoRenderer();
  String? roomId;
  TextEditingController textEditingController = TextEditingController(text: '');
  bool _calling = false;
  var cam = false;
  var mic = false;

  @override
  void initState() {
    _localRenderer.initialize();
    _remoteRenderer.initialize();

    signaling.onAddRemoteStream = ((stream) {
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _localRenderer.dispose();
    _remoteRenderer.dispose();
    super.dispose();
  }

  void _reset() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        transitionDuration: Duration.zero,
        pageBuilder: (_, __, ___) => VideoCall(),
      ),
    );
  }

  showIdDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text('OK'),
      onPressed: () => Navigator.pop(context),
    );

    AlertDialog idDialog = AlertDialog(
      title: Text('Room ID:'),
      content: SelectableText(roomId!),
      actions: [
        okButton,
      ],
    );

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return idDialog;
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: _calling
            ? AppBar(
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Call',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
                centerTitle: true,
              )
            : null,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: _calling
            ? Padding(
                padding: const EdgeInsets.all(48.0),
                child: SizedBox(
                    width: 235.0,
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          FloatingActionButton(
                              onPressed: () {
                                signaling.stopCamera();
                                setState(() => cam = !cam);
                              },
                              backgroundColor: cam
                                  ? Color.fromRGBO(108, 108, 108, 1)
                                  : Color.fromRGBO(217, 217, 217, 1),
                              child: cam
                                  ? SvgPicture.asset(
                                      'assets/icons/video-off.svg')
                                  : SvgPicture.asset(
                                      'assets/icons/video-on.svg')),
                          FloatingActionButton(
                            onPressed: () {
                              signaling.muteMic();
                              setState(() => mic = !mic);
                            },
                            backgroundColor: mic
                                ? Color.fromRGBO(108, 108, 108, 1)
                                : Color.fromRGBO(217, 217, 217, 1),
                            child: mic
                                ? SvgPicture.asset('assets/icons/mic-off.svg')
                                : SvgPicture.asset('assets/icons/mic-on.svg'),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              signaling.hangUp(_localRenderer);
                              _reset();
                            },
                            tooltip: 'Hangup',
                            child:
                                SvgPicture.asset('assets/icons/end-call.svg'),
                            backgroundColor: Colors.red,
                          ),
                        ])),
              )
            : null,
        body: OrientationBuilder(builder: (context, orientation) {
          return Container(
            child: _calling
                ? Stack(
                    children: <Widget>[
                      Positioned(
                          left: 0.0,
                          right: 0.0,
                          top: 0.0,
                          bottom: 0.0,
                          child: Container(
                              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: Colors.black54,
                              child: RTCVideoView(_remoteRenderer))),
                      Positioned(
                        right: 14.0,
                        top: 100.0,
                        child: Container(
                          width: orientation == Orientation.portrait
                              ? 119.0
                              : 181.0,
                          height: orientation == Orientation.portrait
                              ? 181.0
                              : 119.0,
                          padding: EdgeInsets.only(left: 10),
                          child: Container(
                              child:
                                  RTCVideoView(_localRenderer, mirror: true)),
                        ),
                      ),
                      Positioned(
                        bottom: 120,
                        left: 20,
                        child: Container(
                          height: 50,
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color.fromRGBO(117, 125, 232, 1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: TextButton(
                            onPressed: () {
                              showIdDialog(context);
                            },
                            child: Text(
                              'Show room ID',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                : SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(117, 125, 232, 1))),
                              onPressed: () {
                                signaling.joinRoom(
                                  textEditingController.text,
                                  _remoteRenderer,
                                );
                                signaling.openUserMedia(
                                    _localRenderer, _remoteRenderer);
                                setState(() {
                                  _calling = true;
                                });
                              },
                              child: Text("Join room"),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Color.fromRGBO(117, 125, 232, 1))),
                              onPressed: () async {
                                signaling.openUserMedia(
                                    _localRenderer, _remoteRenderer);
                                roomId =
                                    await signaling.createRoom(_remoteRenderer);
                                textEditingController.text = roomId!;
                                setState(() {
                                  _calling = true;
                                });
                              },
                              child: Text("Create room"),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text("Join the following Room: "),
                        Flexible(
                          child: TextFormField(
                            controller: textEditingController,
                          ),
                        ),
                      ],
                    ),
                  ),
          );
        }));
  }
}
