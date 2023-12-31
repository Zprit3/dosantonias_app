import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/otherthings/fix_timestamp.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TimeLinePost extends StatefulWidget {
  final String message;
  final String user;
  final String time;
  final String postId;
  final List<String> likes;
  final String? image;

  const TimeLinePost({
    Key? key,
    required this.message,
    required this.user,
    required this.time,
    required this.postId,
    required this.likes,
    this.image,
  }) : super(key: key);

  @override
  State<TimeLinePost> createState() => _TimeLinePostState();
}

class _TimeLinePostState extends State<TimeLinePost> {
  final user = FirebaseAuth.instance.currentUser!;
  bool liked = false;
  final _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    liked = widget.likes.contains(user.email);
  }

  void deletePost() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Borrar publicacion"),
        content: const Text("¿De verdad queres borrar la publicación?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              final commentLot = await FirebaseFirestore.instance
                  .collection("Posts del usuario")
                  .doc(widget.postId)
                  .collection("Comentarios")
                  .get();

              for (var doc in commentLot.docs) {
                await FirebaseFirestore.instance
                    .collection("Posts del usuario")
                    .doc(widget.postId)
                    .collection("Comentarios")
                    .doc(doc.id)
                    .delete();
              }

              FirebaseFirestore.instance
                  .collection("Posts del usuario")
                  .doc(widget.postId)
                  .delete()
                  .then((value) => print("Publicación borrada"))
                  .catchError((error) =>
                      print("Fallo al intentar borrar la publicación"));

              Navigator.pop(context);
            },
            child: const Text("Borrar"),
          ),
        ],
      ),
    );
  }

  void showCommentDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Agregar comentario"),
        content: TextField(
          controller: _commentTextController,
          decoration:
              const InputDecoration(hintText: "Escribe un comentario.."),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              addComment(_commentTextController.text);
              Navigator.pop(context);
              _commentTextController.clear();
            },
            child: const Text("Publicar"),
          ),
        ],
      ),
    );
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Posts del usuario")
        .doc(widget.postId)
        .collection("Comentarios")
        .add({
      "Comentario": commentText,
      "Comentado por": user.email,
      "Fecha comentario": Timestamp.now(),
    });
  }

  void likeSwitcher() {
    setState(() {
      liked = !liked;
    });

    DocumentReference postRef = FirebaseFirestore.instance
        .collection('Posts del usuario')
        .doc(widget.postId);

    if (liked) {
      postRef.update({
        'Likes': FieldValue.arrayUnion([user.email])
      });
    } else {
      postRef.update({
        'Likes': FieldValue.arrayRemove([user.email])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.image != null)
                    // ignore: sized_box_for_whitespace
                    Container(
                      width: 310,
                      child: Image.network(
                        widget.image!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 400,
                      ),
                    ),
                  const SizedBox(height: 10),
                  Text(widget.message),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      Text(widget.user,
                          style: TextStyle(color: Colors.grey[500])),
                      Text(" ¬ ", style: TextStyle(color: Colors.grey[500])),
                      Text(widget.time,
                          style: TextStyle(color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  LikeButton(
                    liked: liked,
                    onTap: likeSwitcher,
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.likes.length.toString(),
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                children: [
                  CommentButton(onTap: showCommentDialog),
                  const SizedBox(height: 5),
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              const SizedBox(width: 5),
              Column(
                children: [
                  if (widget.user == user.email)
                    DeleteButton(onTap: deletePost),
                  const SizedBox(height: 5),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("Posts del usuario")
                .doc(widget.postId)
                .collection("Comentarios")
                .orderBy("Fecha comentario", descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  final commentData = doc.data() as Map<String, dynamic>;
                  return PostComment(
                    text: commentData["Comentario"],
                    user: commentData["Comentado por"],
                    time: formatTime(commentData["Fecha comentario"]),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
