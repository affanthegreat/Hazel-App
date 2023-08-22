part of 'leaf_bloc.dart';

@immutable
abstract class LeafState {}

class LeafInitial extends LeafState {}

class LeafLoadingState extends LeafState{

}

class LeafSuccessfulLoadState extends LeafState{
  final Map<String, bool> map;

  LeafSuccessfulLoadState(this.map);
}
