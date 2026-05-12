import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/app/routes.dart';
import 'package:nextcart/features/auth/data/firebase_auth_repository.dart';
import 'package:nextcart/features/cart/data/firebase_cart_repository.dart';
import 'package:nextcart/features/cart/domain/models/cart_item.dart';
import 'package:nextcart/features/cart/presentation/viewmodels/cart_viewmodel.dart';
import 'package:nextcart/features/checkout/presentation/viewmodels/checkout_viewmodel.dart';
import 'package:nextcart/shared/widgets/price_tag.dart';

class CheckoutView extends ConsumerStatefulWidget {
  const CheckoutView({super.key});

  @override
  ConsumerState<CheckoutView> createState() => _CheckoutViewState();
}

class _CheckoutViewState extends ConsumerState<CheckoutView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _city;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _phone = TextEditingController();
    _address = TextEditingController();
    _city = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    super.dispose();
  }

  void _prefill() {
    if (_initialized) return;
    final user = ref.read(currentAppUserProvider).value;
    if (user == null) return;
    _name.text = user.name;
    _phone.text = user.phone ?? '';
    _address.text = user.address ?? '';
    _city.text = user.city ?? '';
    _initialized = true;
  }

  Future<void> _placeOrder() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    HapticFeedback.mediumImpact();
    final order = await ref
        .read(checkoutControllerProvider.notifier)
        .placeOrder(
          customerName: _name.text.trim(),
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          city: _city.text.trim(),
        );
    if (!mounted || order == null) return;
    context.pushReplacement(Routes.orderDetailPath(order.id));
  }

  @override
  Widget build(BuildContext context) {
    _prefill();
    final theme = Theme.of(context);
    final cart = ref.watch(cartStreamProvider).value ?? const [];
    final subtotal = ref.watch(cartSubtotalProvider);
    final delivery = ref.watch(cartDeliveryFeeProvider);
    final total = ref.watch(cartTotalProvider);
    final state = ref.watch(checkoutControllerProvider);

    ref.listen<AsyncValue<dynamic>>(checkoutControllerProvider, (prev, next) {
      next.whenOrNull(error: (e, _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: $e')),
        );
      });
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        leading: const IosBackButton(),
      ),
      body: cart.isEmpty
          ? const Center(child: Text('Your cart is empty.'))
          : Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  Text('Delivery details',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Full name',
                      prefixIcon: _PrefixIcon(FontAwesomeIcons.user),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _phone,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Phone number',
                      prefixIcon: _PrefixIcon(FontAwesomeIcons.phone),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) return 'Required';
                      if (v.trim().length < 8) return 'Enter a valid number';
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _address,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Full address',
                      alignLabelWithHint: true,
                      prefixIcon: _PrefixIcon(FontAwesomeIcons.locationDot),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _city,
                    decoration: const InputDecoration(
                      labelText: 'City',
                      prefixIcon: _PrefixIcon(FontAwesomeIcons.city),
                      prefixIconConstraints: BoxConstraints(
                        minWidth: 48,
                        minHeight: 48,
                      ),
                    ),
                    validator: (v) =>
                        (v == null || v.trim().isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 28),
                  Text('Payment method',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer
                          .withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: theme.colorScheme.primary),
                    ),
                    child: Row(
                      children: [
                        FaIcon(
                          FontAwesomeIcons.moneyBillWave,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Cash on Delivery',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pay in cash when your order arrives.',
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                        ),
                        FaIcon(
                          FontAwesomeIcons.circleCheck,
                          color: theme.colorScheme.primary,
                          size: 18,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text('Order summary',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      )),
                  const SizedBox(height: 8),
                  for (final c in cart)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${c.title} × ${c.quantity}',
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.bodyMedium,
                            ),
                          ),
                          Text(
                            formatPrice(c.subtotal),
                            style: theme.textTheme.bodyMedium,
                          ),
                        ],
                      ),
                    ),
                  const Divider(height: 24),
                  _line(theme, 'Subtotal', subtotal),
                  _line(theme, 'Delivery', delivery,
                      hint: delivery == 0 ? 'Free' : null),
                  const Divider(height: 16),
                  _line(theme, 'Total', total, isTotal: true),
                ],
              ),
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: state.isLoading || cart.isEmpty ? null : _placeOrder,
            icon: const FaIcon(FontAwesomeIcons.moneyBillWave, size: 16),
            label: Text(state.isLoading ? 'Placing order…' : 'Place Order'),
          ),
        ),
      ),
    );
  }

  Widget _line(
    ThemeData theme,
    String label,
    double value, {
    String? hint,
    bool isTotal = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: (isTotal
                    ? theme.textTheme.titleMedium
                    : theme.textTheme.bodyMedium)
                ?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? null : theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          if (hint != null) ...[
            Text(
              hint,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Text(
            formatPrice(value),
            style: isTotal
                ? theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  )
                : theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _PrefixIcon extends StatelessWidget {
  const _PrefixIcon(this.icon);
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Center(child: FaIcon(icon, size: 16)),
    );
  }
}
