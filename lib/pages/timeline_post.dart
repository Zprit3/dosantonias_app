import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimeLinePost extends StatefulWidget {
  final String message;
  final String user;
  final String postId;
  final List<String> likes;

  const TimeLinePost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes});

  @override
  State<TimeLinePost> createState() => _TimeLinePostState();
}

class _TimeLinePostState extends State<TimeLinePost> {
  //usuario
  final user = FirebaseAuth.instance.currentUser!;
  bool liked = false;

  @override
  void initState() {
    super.initState();
    liked = widget.likes.contains(user.email);
  }

  //like switcher (implementar parecido al switcher de paginas)
  void likeSwitcher() {
    setState(() {
      liked = !liked;
    });

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Posts del usuario')
        .doc(widget.postId);
    if (liked) {
      //si el post esta likeado, agregar el email del usuario al campo de likes
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email])
      });
    } else {
      //si el post se actualiza como unlike, remover el email del campo likes
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Row(
        children: [
          /*
          //IMAGEN DE PERFIL. PROBAR CON FIREBASE
          Container(
            decoration: 
              BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
              padding: EdgeInsets.all(10),
              child:Icon(Icons.person,
                color: Colors.white),
          ),*/
          Column(
            children: [
              //boton like
              LikeButton(
                liked: liked,
                onTap: likeSwitcher,
              ),
              //contador likes
              const SizedBox(height: 5),
              Text(
                widget.likes.length.toString(),
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.user,
                style: TextStyle(color: Colors.grey[500]),
              ),
              const SizedBox(height: 10),
              Text(widget.message),
            ],
          ),
        ],
      ),
    );
  }
}
