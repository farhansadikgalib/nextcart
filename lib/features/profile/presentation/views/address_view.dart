import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nextcart/core/widgets/ios_back_button.dart';
import 'package:nextcart/features/auth/data/firebase_auth_repository.dart';
import 'package:nextcart/features/auth/domain/models/app_user.dart';
import 'package:nextcart/features/profile/presentation/viewmodels/profile_viewmodel.dart';

class AddressView extends ConsumerWidget {
  const AddressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentAppUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery Address'),
        leading: const IosBackButton(),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (user) {
          if (user == null) return const Center(child: Text('Not signed in'));
          return _AddressForm(user: user);
        },
      ),
    );
  }
}

class _AddressForm extends ConsumerStatefulWidget {
  const _AddressForm({required this.user});
  final AppUser user;

  @override
  ConsumerState<_AddressForm> createState() => _AddressFormState();
}

class _AddressFormState extends ConsumerState<_AddressForm> {
  late final TextEditingController _phone;
  late final TextEditingController _address;
  late final TextEditingController _city;

  @override
  void initState() {
    super.initState();
    _phone = TextEditingController(text: widget.user.phone ?? '');
    _address = TextEditingController(text: widget.user.address ?? '');
    _city = TextEditingController(text: widget.user.city ?? '');
  }

  @override
  void dispose() {
    _phone.dispose();
    _address.dispose();
    _city.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    FocusScope.of(context).unfocus();
    await ref
        .read(profileEditorProvider.notifier)
        .save(
          phone: _phone.text.trim(),
          address: _address.text.trim(),
          city: _city.text.trim(),
        );
    if (!mounted) return;
    final err = ref.read(profileEditorProvider).error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(err == null ? 'Address saved' : 'Save failed'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final state = ref.watch(profileEditorProvider);
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'Where should we deliver?',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'We use this to estimate shipping and contact you when your order is on the way.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _phone,
          keyboardType: TextInputType.phone,
          decoration: const InputDecoration(
            labelText: 'Phone',
            prefixIcon: _PrefixIcon(FontAwesomeIcons.phone),
            prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _address,
          minLines: 2,
          maxLines: 4,
          decoration: const InputDecoration(
            labelText: 'Street address',
            alignLabelWithHint: true,
            prefixIcon: _PrefixIcon(FontAwesomeIcons.locationDot),
            prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _city,
          decoration: const InputDecoration(
            labelText: 'City',
            prefixIcon: _PrefixIcon(FontAwesomeIcons.city),
            prefixIconConstraints: BoxConstraints(minWidth: 48, minHeight: 48),
          ),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: state.isLoading ? null : _save,
          icon: state.isLoading
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const FaIcon(FontAwesomeIcons.floppyDisk, size: 16),
          label: Text(state.isLoading ? 'Saving…' : 'Save address'),
        ),
      ],
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
