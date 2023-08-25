import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hazel_client/bloc/hashtagview/hashtag_view_bloc.dart';


class HazelHashTagLeavesView extends StatefulWidget {
  const HazelHashTagLeavesView({super.key});

  @override
  State<HazelHashTagLeavesView> createState() => _HazelHashTagLeavesViewState();
}

class _HazelHashTagLeavesViewState extends State<HazelHashTagLeavesView> {

  HashtagViewBloc hashtagViewBloc = HashtagViewBloc();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HashtagViewBloc, HashtagViewState>(
      bloc:  hashtagViewBloc,
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        return Scaffold();
      },
    );
  }
}
