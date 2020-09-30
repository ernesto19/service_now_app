import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:service_now/utils/responsive.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';

class BusinessDetailPage extends StatefulWidget {
  const BusinessDetailPage({Key key}) : super(key: key);

  @override
  _BusinessDetailPageState createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<BusinessDetailPage> {
  ButtonState stateOnlyText = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://images.unsplash.com/photo-1520342868574-5fa3804e551c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=6ff92caffcdd63681a35134a6770ed3b&auto=format&fit=crop&w=1951&q=80',
      'https://images.unsplash.com/photo-1522205408450-add114ad53fe?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=368f45b0888aeb0b7b08e3a1084d3ede&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1519125323398-675f0ddb6308?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=94a1e718d89ca60a6337a6008341ca50&auto=format&fit=crop&w=1950&q=80',
      'https://images.unsplash.com/photo-1523205771623-e0faa4d2813d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=89719a0d55dd05e2deae4120227e6efc&auto=format&fit=crop&w=1953&q=80',
      'https://images.unsplash.com/photo-1508704019882-f9cf40e475b4?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=8c6e5e3aba713b17aa1fe71ab4f0ae5b&auto=format&fit=crop&w=1352&q=80',
      'https://images.unsplash.com/photo-1519985176271-adb1088fa94c?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=a0c8d632e977f94e5d312d9893258f59&auto=format&fit=crop&w=1355&q=80',
      'https://images.pexels.com/photos/396547/pexels-photo-396547.jpeg?auto=compress&cs=tinysrgb&h=350'
    ];

    final Responsive responsive = Responsive.of(context);

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                backgroundColor: Colors.white,
                expandedHeight: responsive.hp(35),
                floating: false,
                flexibleSpace: CarouselSlider(
                  options: CarouselOptions(
                    height: 350
                  ),
                  items: imgList.map((item) => Container(
                    child: Center(
                      child: Image.network(item, fit: BoxFit.cover, width: 1000, height: 350)
                    ),
                  )).toList()
                )
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(text: 'Información'),
                      Tab(text: 'Fotos'),
                      Tab(text: 'Solicitar')
                    ]
                  )
                )
              )
            ];
          },
          body: TabBarView(
            children: [
              CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text('BARBERIA ABC', style: TextStyle(fontSize: 19))
                              ),
                              // RawMaterialButton(
                              //   elevation: 2.0,
                              //   fillColor: secondaryColor,
                              //   child: Icon(
                              //     Icons.favorite_border,
                              //     size: 20,
                              //     color: Colors.white
                              //   ),
                              //   shape: CircleBorder(),
                              //   onPressed: () {},
                              // )
                            ]
                          ),
                          SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('3.5'),
                              SizedBox(width: 10),
                              RatingBar(
                                initialRating: 3.5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 20,
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber
                                ),
                                ignoreGestures: true,
                                onRatingUpdate: null
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          Text('450 km'),
                          SizedBox(height: 20),
                          Text(
                            'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.'                    
                          ),
                        ]
                      )
                    )
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return _buildComment();
                      },
                      childCount: 10
                    ),
                  )
                ]
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Container(
                            height: 100,
                            alignment: Alignment.center,
                            color: Colors.grey,
                            // child: Text('grid item $index'),
                            child: Image.network(imgList[index], fit: BoxFit.cover, width: 350, height: 350)
                          );
                        },
                        childCount: imgList.length,
                      ), 
                      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 200.0,
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 10.0,
                        childAspectRatio: 1.1
                      )
                    )
                  ],
                ),
              ),
              Container(
                child: Center(
                  child: ProgressButton.icon(
                    iconedButtons: {
                      ButtonState.idle:
                        IconedButton(
                          text: "Send",
                          icon: Icon(Icons.send,color: Colors.white),
                          color: Colors.deepPurple.shade500),
                      ButtonState.loading:
                        IconedButton(
                          text: "Loading",
                          color: Colors.deepPurple.shade700),
                      ButtonState.fail:
                        IconedButton(
                          text: "Failed",
                          icon: Icon(Icons.cancel,color: Colors.white),
                          color: Colors.red.shade300),
                      ButtonState.success:
                        IconedButton(
                          text: "Success",
                          icon: Icon(Icons.check_circle,color: Colors.white,),
                          color: Colors.green.shade400
                        )
                    }, 
                    onPressed: onPressedCustomButton,
                    state: stateOnlyText
                  )
                )
              )
            ]
          )
        )
      )
    );
  }

  void onPressedCustomButton() {
    setState(() {
      switch (stateOnlyText) {
        case ButtonState.idle:
          stateOnlyText = ButtonState.loading;
          break;
        case ButtonState.loading:
          stateOnlyText = ButtonState.fail;
          break;
        case ButtonState.success:
          stateOnlyText = ButtonState.idle;
          break;
        case ButtonState.fail:
          stateOnlyText = ButtonState.success;
          break;
      }
    });
  }

  Widget _buildComment() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Align(
            alignment: Alignment.center,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: Colors.grey,
            ),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RatingBar(
                  initialRating: 3.5,
                  minRating: 1,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 15,
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber
                  ),
                  ignoreGestures: true,
                  onRatingUpdate: null
                ),
                Text(
                  'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                  style: TextStyle(fontSize: 13),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      child: _tabBar
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}