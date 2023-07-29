import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  final bool liked;
  final void Function()? onTap;
  const LikeButton({
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
        color: liked ? Colors.red : Colors.grey,
      ),
    );
  }
}
