import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pds_front/app/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class PublicPostCard extends StatelessWidget {
  final PostModel post;

  const PublicPostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final currencyFormat =
        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

    final ScrollController controller = ScrollController();

    return Card(
      color: const Color(0xFF1F1F2A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      margin: const EdgeInsets.all(8),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: ScrollConfiguration(
                  behavior: const ScrollBehavior().copyWith(
                    scrollbars: false,
                    dragDevices: {
                      PointerDeviceKind.touch,
                      PointerDeviceKind.mouse,
                    },
                  ),
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: controller,
                    itemCount: post.images.length,
                    itemBuilder: (context, index) {
                      final imageUrl =
                          "http://localhost:3000/v1/posts/images/${post.images[index]}";
                      return AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          height: 200, // largura dinâmica
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(Icons.broken_image,
                                  color: Colors.redAccent),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (post.active)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black87,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Disponível',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              Positioned(
                  right: 8,
                  top: 120,
                  child: GestureDetector(
                      onTap: () {
                        controller.animateTo(controller.offset + 450,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut);
                      },
                      child: Chip(label: Icon(Icons.chevron_right_outlined)))),
              Positioned(
                  left: 8,
                  top: 120,
                  child: GestureDetector(
                    onTap: () {
                      controller.animateTo(controller.offset - 450,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut);
                    },
                    child: Chip(
                      label: Icon(Icons.chevron_left_outlined),
                    ),
                  )),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  post.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      post.price != null
                          ? 'A partir de ${currencyFormat.format(post.price)}'
                          : 'Preço sob consulta',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: post.price == null
                            ? FontStyle.italic
                            : FontStyle.normal,
                        color: post.price == null
                            ? Colors.white.withOpacity(0.5)
                            : const Color(0xFF00FF88),
                      ),
                    ),
                    Text(
                      post.updatedAt != null
                          ? timeago.format(post.createdAt!, locale: 'pt_BR')
                          : '',
                      style: const TextStyle(color: Colors.white60),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
