import 'package:day_15_bloc_navigation/post_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'nav_cubit.dart';
import 'post.dart';

class PostsView extends StatelessWidget {
  const PostsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocBuilder<PostsBloc, PostsState>(
        builder: (context, state) {
          if (state is LoadingPostsState) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is LoadedPostsState) {
            return RefreshIndicator(
              onRefresh: () async =>
                  BlocProvider.of<PostsBloc>(context).add(PullToRefreshEvent()),
              child: ListView.builder(
                  itemCount: state.posts.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(state.posts[index].title),
                        onTap: () => BlocProvider.of<NavCubit>(context).showPostDetails(state.posts[index]),
                      ),
                    );
                  }),
            );
          } else if (state is FailedToLoadPostsState) {
            return Center(
              child: Text('Error occurred: ${state.error}'),
            );
          } else {
            return GridView(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2));
          }
        },
      ),
    );
  }
}
