import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:animator/animator.dart';
class Page5 extends StatelessWidget {
  const Page5({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 60,
                  color: Colors.white,
                  width: _width,
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                    SizedBox(width: 10,),
                    Image.asset('assets/images/intro_4.jpg',),
                    SizedBox(width: 10,),
                    Text('therosygrail', style: TextStyle(fontWeight: FontWeight.w500,color: Colors.grey.shade700),),
                    SizedBox(width: 10,),
                    Expanded(
                      child: Stack(children: [Text('Follow', style: TextStyle(fontWeight: FontWeight.w600,fontSize:16,color: Colors.lightBlueAccent),),
                        Animator<double>(
                          tween: Tween<double>(begin: 4, end: 1),
                          curve: Curves.elasticOut,
                          resetAnimationOnRebuild: true,
                          cycles: 10,
                          repeats: 1,
                          duration:const Duration(seconds: 2) ,
                          builder: (_, animationState, __) => Transform.scale(
                              scale: animationState.value,
                              child: const Text('Follow', style: TextStyle(fontWeight: FontWeight.w600,fontSize:16,color: Colors.lightBlueAccent),)),
                        )]),
                    ),

                  ],),

                ),
                Image.asset('assets/images/cat.png',width: _width,height: _height/2,fit: BoxFit.cover,),
                Container(
                  height: 60,
                  color: Colors.white,
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('539 notes', style: TextStyle(fontWeight: FontWeight.w700,color: Colors.grey.shade600),),
                      Row(
                        children: [
                          Icon(CupertinoIcons.location_fill, color: Colors.grey.shade600,),
                          const SizedBox(width: 10,),
                          Icon(CupertinoIcons.chat_bubble, color: Colors.grey.shade600,),
                          const SizedBox(width: 10,),
                          Stack(
                            children: [
                              Icon(CupertinoIcons.repeat, color: Colors.grey.shade600,),
                              Animator<double>(
                                tween: Tween<double>(begin: 2, end: 1),
                                curve: Curves.elasticInOut,
                                resetAnimationOnRebuild: true,
                                cycles: 5,
                                repeats: 1,
                                duration:const Duration(seconds: 2) ,
                                builder: (_, animationState, __) => Transform.scale(
                                    scale: animationState.value,
                                    child: const Icon(
                                      CupertinoIcons.repeat,
                                      color: Colors.green,

                                    )),
                              )
                            ],
                          ),
                          const SizedBox(width: 10,),
                          Stack(children: [Icon(Icons.favorite_border, color: Colors.grey.shade600,),
                            Animator<double>(
                              tween: Tween<double>(begin: 4, end: 1),
                              curve: Curves.elasticOut,
                              resetAnimationOnRebuild: true,
                              cycles: 5,
                              repeats: 1,
                              duration:const Duration(seconds: 2) ,
                              builder: (_, animationState, __) => Transform.scale(
                              scale: animationState.value,
                              child: const Icon(
                                Icons.favorite,
                                color: Colors.red,

                              )),
                          )]),
                          const SizedBox(width: 10,),

                        ],
                      )
                    ],),

                ),
              ],
            ),
    );
  }
}
