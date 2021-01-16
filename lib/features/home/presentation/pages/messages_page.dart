import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:service_now/features/appointment/presentation/pages/client_request.dart';
import 'package:service_now/features/professional/presentation/pages/professional_request_page.dart';
import 'package:service_now/utils/all_translations.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:service_now/features/home/domain/entities/message.dart';
import 'package:service_now/features/home/presentation/bloc/message/bloc.dart';
import 'package:service_now/injection_container.dart';
import 'package:service_now/utils/colors.dart';
import 'package:service_now/utils/text_styles.dart';

class MessagesPage extends StatelessWidget {
  static final routeName = 'messages_page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(allTranslations.traslate('mensajes'), style: labelTitleForm),
        backgroundColor: primaryColor
      ),
      body: buildBody(context)
    );
  }

  BlocProvider<MessageBloc> buildBody(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<MessageBloc>(),
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 15),
              child: CustomScrollView(
                slivers: [
                  BlocBuilder<MessageBloc, MessageState>(
                    builder: (context, state) {
                      // ignore: close_sinks
                      final bloc = MessageBloc.of(context);
                      bloc.add(GetMessagesForUser());

                      if (state.status == MessageStatus.ready) {
                        return state.messages.length > 0 ? SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              final Message message = state.messages[index];
                              Map<String, dynamic> content = json.decode(message.content);
                              
                              return GestureDetector(
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 10, right: 15, left: 15, top: 4),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Container(
                                      padding: EdgeInsets.only(left: 20, right: 10, top: 15, bottom: 10),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(_buildMoment(message).replaceFirst(allTranslations.traslate('en'), allTranslations.traslate('hace')), style: TextStyle(fontSize: 11)),
                                          SizedBox(height: 5),
                                          Text(content['title'] ?? '', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                          SizedBox(height: 5),
                                          Divider(height: 0, color: Colors.black38),
                                          SizedBox(height: 8),
                                          Text(content['message'] ?? '', style: TextStyle(fontSize: 13)),
                                        ]
                                      )
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: <BoxShadow>[
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        spreadRadius: 1,
                                        offset: Offset(2, 2)
                                      )
                                    ]
                                  )
                                ),
                                onTap: () {
                                  if (content['tipo'] == 'pnRequestService') {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProfessionalRequest(notification: message.content)));
                                  } else if (content['tipo'] == 'pnResponseService') {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => ClientRequest(notification: message.content)));
                                  }
                                }
                              );
                            },
                            childCount: state.messages.length
                          )
                        ) : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Container(
                              padding: EdgeInsets.only(top: 150),
                              child: Center(
                                child: Column(
                                  children: [
                                    Icon(Icons.mood_bad, size: 60, color: Colors.black38),
                                    SizedBox(height: 10),
                                    Text(allTranslations.traslate('no_hay_informacion'))
                                  ],
                                )
                              ),
                            ),
                            childCount: 1
                          )
                        );
                      } else {
                        return SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return Container(
                                padding: EdgeInsets.only(top: 50),
                                child: Center(
                                  child: CircularProgressIndicator()
                                )
                              );
                            },
                            childCount: 1
                          )
                        );
                      }
                    }
                  )
                ]
              )
            )
          ]
        )
      ),
    );
  }

  String _buildMoment(Message message) {
    Moment.setLocaleGlobally(new LocaleEs());
    var updateDate = DateTime.parse(message.createdAt);
    var moment = new Moment.now();
    String text = moment.from(updateDate);
    return '${text[0].toUpperCase()}${text.substring(1, text.length)}';
  }
}