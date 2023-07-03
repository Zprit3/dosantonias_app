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

  const TimeLinePost(
      {super.key,
      required this.message,
      required this.user,
      required this.postId,
      required this.likes,
      required this.time});

  @override
  State<TimeLinePost> createState() => _TimeLinePostState();
}

class _TimeLinePostState extends State<TimeLinePost> {
  //usuario
  final user = FirebaseAuth.instance.currentUser!;
  bool liked = false;

  //comentarios
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
                    //primero borrar comentarios en firestore
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
                    //borrar publicacion
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
            ));
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
                )
              ],
            ));
  }

  void addComment(String commentText) {
    FirebaseFirestore.instance
        .collection("Posts del usuario")
        .doc(widget.postId)
        .collection("Comentarios")
        .add({
      "Comentario": commentText,
      "Comentado por": user.email,
      "Fecha comentario": Timestamp.now()
    });
  }

  //like switcher (implementar parecido al switcher de paginas)
  void likeSwitcher() {
    setState(() {
      liked = !liked;
    });

    //agregar comentarios a publicaciones. guardar comentarios en firestore

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
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
      padding: const EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Muro del timeline
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
              if (widget.user == user.email) DeleteButton(onTap: deletePost),
            ],
          ),
          const SizedBox(height: 20),
          //botones aqui
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //seccion de like
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
              const SizedBox(
                width: 10,
              ),
              //seccion de comentario
              Column(
                children: [
                  //boton
                  CommentButton(onTap: showCommentDialog),
                  //contador likes
                  const SizedBox(height: 5),
                  const Text(
                    '0',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 5),

          //comentarios mostrados
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
                  shrinkWrap: true, //para acomodar las listas
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;

                    return PostComment(
                        text: commentData["Comentario"],
                        user: commentData["Comentado por"],
                        time: formatTime(commentData["Fecha comentario"]));
                  }).toList(),
                );
              }),
        ],
      ),
    );
  }
}

    /*
          //IMAGEN DE PERFIL. PROBAR CON FIREBASE
          Container(
            decoration: 
              BoxDecoration(shape: BoxShape.circle, color: Colors.grey[400]),
              padding: EdgeInsets.all(10),
              child:Icon(Icons.person,
                color: Colors.white),
          ),*/