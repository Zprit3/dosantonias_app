// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LikeButton extends StatelessWidget {
  final bool liked;
  void Function()? onTap;
  LikeButton({
    Key? key,
    required this.liked,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(
        liked ? Icons.favorite : Icons.favorite_border,
        color: liked ? Colors.orange : Colors.grey,
      ),
    );
  }
}
