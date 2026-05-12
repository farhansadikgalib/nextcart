import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/features/products/data/firebase_product_repository.dart';
import 'package:nextcart/features/products/domain/product_repository.dart';
import 'package:nextcart/features/search/presentation/viewmodels/search_viewmodel.dart';
import 'package:nextcart/shared/widgets/empty_state.dart';
import 'package:nextcart/shared/widgets/product_card.dart';

class SearchView extends ConsumerStatefulWidget {
  const SearchView({super.key});

  @override
  ConsumerState<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends ConsumerState<SearchView> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _focusNode.requestFocus());
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final query = ref.watch(searchQueryProvider);
    final productsAsync =
        ref.watch(productsStreamProvider(sort: ProductSort.newest));
    final recentAsync = ref.watch(recentSearchesProvider);

    final results = query.trim().isEmpty
        ? const <dynamic>[]
        : productsAsync.value
                ?.where((p) =>
                    p.title.toLowerCase().contains(query.toLowerCase()))
                .toList() ??
            const [];

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(72),
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 16, 12),
            child: Row(
              children: [
                const IosBackButton(),
                const SizedBox(width: 4),
                Expanded(
                  child: _SearchField(
                    controller: _controller,
                    focusNode: _focusNode,
                    hasQuery: query.isNotEmpty,
                    onChanged: (v) =>
                        ref.read(searchQueryProvider.notifier).set(v),
                    onSubmitted: (v) {
                      if (v.trim().isEmpty) return;
                      ref.read(recentSearchesProvider.notifier).add(v);
                    },
                    onClear: () {
                      _controller.clear();
                      ref.read(searchQueryProvider.notifier).clear();
                      _focusNode.requestFocus();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: query.trim().isEmpty
          ? recentAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
              data: (recent) {
                if (recent.isEmpty) {
                  return const EmptyState(
                    icon: FontAwesomeIcons.magnifyingGlass,
                    title: 'Search NextCart',
                    message: 'Find products by name.',
                  );
                }
                return ListView(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.fromLTRB(20, 16, 12, 8),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Recent',
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          TextButton(
                            onPressed: () => ref
                                .read(recentSearchesProvider.notifier)
                                .clear(),
                            child: const Text('Clear'),
                          ),
                        ],
                      ),
                    ),
                    for (final q in recent)
                      ListTile(
                        leading: const FaIcon(
                          FontAwesomeIcons.clockRotateLeft,
                          size: 16,
                        ),
                        title: Text(q),
                        onTap: () {
                          _controller.text = q;
                          _controller.selection = TextSelection.collapsed(
                            offset: q.length,
                          );
                          ref.read(searchQueryProvider.notifier).set(q);
                        },
                      ),
                  ],
                );
              },
            )
          : results.isEmpty
              ? EmptyState(
                  icon: FontAwesomeIcons.faceFrown,
                  title: 'No results',
                  message: 'No products matched "${query.trim()}".',
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.66,
                  ),
                  itemCount: results.length,
                  itemBuilder: (_, i) {
                    final p = results[i];
                    return ProductCard(
                      product: p,
                      onTap: () {
                        ref
                            .read(recentSearchesProvider.notifier)
                            .add(query);
                        context.push(Routes.productDetailPath(p.id));
                      },
                    );
                  },
                ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField({
    required this.controller,
    required this.focusNode,
    required this.hasQuery,
    required this.onChanged,
    required this.onSubmitted,
    required this.onClear,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasQuery;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    return AnimatedBuilder(
      animation: focusNode,
      builder: (_, _) {
        final focused = focusNode.hasFocus;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          height: 48,
          decoration: BoxDecoration(
            color: focused
                ? scheme.surface
                : scheme.surfaceContainerHighest.withValues(alpha: 0.55),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: focused
                  ? scheme.primary.withValues(alpha: 0.55)
                  : scheme.outlineVariant.withValues(alpha: 0.5),
              width: focused ? 1.4 : 1,
            ),
            boxShadow: focused
                ? [
                    BoxShadow(
                      color: scheme.primary.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              FaIcon(
                FontAwesomeIcons.magnifyingGlass,
                size: 16,
                color: focused ? scheme.primary : scheme.onSurfaceVariant,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  cursorColor: scheme.primary,
                  style: theme.textTheme.bodyLarge,
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Search products, brands, categories…',
                    hintStyle: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant.withValues(alpha: 0.8),
                    ),
                  ),
                  onChanged: onChanged,
                  onSubmitted: onSubmitted,
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                transitionBuilder: (child, anim) =>
                    ScaleTransition(scale: anim, child: child),
                child: hasQuery
                    ? Padding(
                        key: const ValueKey('clear'),
                        padding: const EdgeInsets.only(right: 6),
                        child: Material(
                          color: scheme.surfaceContainerHighest,
                          shape: const CircleBorder(),
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: onClear,
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: Center(
                                child: FaIcon(
                                  FontAwesomeIcons.xmark,
                                  size: 12,
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ),
                        ),
                      )
                    : const SizedBox(
                        key: ValueKey('empty'),
                        width: 16,
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
