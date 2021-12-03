
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
Future<dynamic>? showBottom(
    {required BuildContext context,required TextEditingController txtcnt,required String content}) {
  return showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text('save as',
                  style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    TextFormField(style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                    ),
                      controller: txtcnt,
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Color(0xFF0A3471),
                          onPressed: () async {
                            String? destination;
                            if (Platform.isAndroid) {
                              if (await Permission.storage.request().isGranted) {
                                destination = '/storage/emulated/0/Download';
                              } else {
                                //showMessageDialog(context, trans('$appName needs storage permissions in order to download files. You can grant this permission from app settings.'));
                              }
                            } else {
                              //destination = (await getApplicationDocumentsDirectory()).path;
                            }
                            if(destination!=null){

                              await File('${destination}/${txtcnt.text}.json').writeAsString(content);
                              Navigator.of(context).pop();
                            }
                          },
                          child: Text("حفظ",style: TextStyle(color: Colors.white),),
                        ),
                        FlatButton(
                          textColor: Colors.black45,
                          child: Text('إلغاء'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ],
                ))
          ],
        ),
      ));
}
