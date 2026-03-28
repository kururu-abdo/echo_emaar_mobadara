import 'package:echoemaar_commerce/config/themes/theme_context.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/shipping_address.dart';

class AddressSelector extends StatelessWidget {
  final ShippingAddress addresses;
  final ShippingAddress? selectedAddress;
  final ValueChanged<ShippingAddress> onSelectAddress;
  final VoidCallback onAddNew;

  const AddressSelector({
    super.key,
    required this.addresses,
    required this.selectedAddress,
    required this.onSelectAddress,
    required this.onAddNew,
  });

  @override
  Widget build(BuildContext context) {
    // if (addresses.isEmpty) {
    //   return _EmptyAddresses(onAddNew: onAddNew);
    // }
var addr = addresses;
    return 
    
    Column(
      children: [
       
        
         Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _AddressCard(
                address: addr,
                isSelected: addr.id == selectedAddress?.id,
                onTap: () => onSelectAddress(addr),
              ),
            ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onAddNew,
          icon: const Icon(Icons.add_rounded, size: 18),
          label: const Text('Add New Address'),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
        ),
      ],
    );
  }
}

class _AddressCard extends StatelessWidget {
  final ShippingAddress address;
  final bool isSelected;
  final VoidCallback onTap;

  const _AddressCard({
    required this.address,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final shapes = context.shapes;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(shapes.borderRadiusMedium),
          border: Border.all(
            color: isSelected ? colors.primary : colors.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: colors.primary.withOpacity(.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  )
                ]
              : [],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Radio button
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? colors.primary : colors.textSecondary,
            ),
            const SizedBox(width: 12),
            // Address details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [




                  Row(
                    children: [
                      Text(
                        address.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      if (address.isDefault) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: colors.primary.withOpacity(.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Default',
                            style: TextStyle(
                              color: colors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    address.phone,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    address.fullAddress,
                    style: TextStyle(
                      color: colors.textSecondary,
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyAddresses extends StatelessWidget {
  final VoidCallback onAddNew;

  const _EmptyAddresses({required this.onAddNew});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(Icons.location_on_outlined,
              size: 48, color: colors.textSecondary),
          const SizedBox(height: 16),
          Text(
            'No shipping addresses yet',
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: onAddNew,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add Address'),
          ),
        ],
      ),
    );
  }
}