import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatelessWidget {
  final PostModel post;
  final void Function(String id)? onEdit;
  final void Function(String id)? onDelete;
  final void Function(String id)? onDetails;

  const PostCard(
      {super.key,
      required this.post,
      this.onEdit,
      this.onDelete,
      this.onDetails});

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('pt_BR', timeago.PtBrMessages());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: 300,
          height: 400,
          decoration: BoxDecoration(
            color: const Color(0xFF252734),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.hardEdge,
          child: Column(
            children: [
              Stack(
                children: [
                  Image.network(
                    "http://localhost:3000/v1/posts/images/${post.images[post.coverImage]}",
                    width: constraints.maxWidth,
                    height: constraints.maxHeight / 2,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                      top: 4,
                      right: 4,
                      child:
                          Chip(label: Text(post.active ? 'Ativo' : 'Inativo'))),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title,
                        style: const TextStyle(color: Colors.white)),
                    const SizedBox(height: 4),
                    Text(post.category,
                        style: const TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          post.price != null
                              ? NumberFormat.currency(
                                      locale: 'pt_BR', symbol: 'R\$')
                                  .format(post.price)
                              : '',
                          style: const TextStyle(color: Colors.greenAccent),
                        ),
                        Text(
                          post.createdAt != null
                              ? timeago.format(post.createdAt!, locale: 'pt_BR')
                              : '',
                          style: const TextStyle(color: Colors.white60),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      children: [
                        ElevatedButton.icon(
                          icon: const Icon(Icons.insert_drive_file_outlined,
                              size: 16),
                          onPressed: () {
                            onDetails?.call(post.id!);
                          },
                          label: const Text('Detalhes'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.edit, size: 16),
                          onPressed: () {
                            onEdit?.call(post.id!);
                          },
                          label: const Text('Editar'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                          ),
                        ),
                        ElevatedButton.icon(
                          icon: const Icon(Icons.delete, size: 16),
                          onPressed: () {
                            onDelete?.call(post.id!);
                          },
                          label: const Text('Excluir'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            backgroundColor: Colors.red[400],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
