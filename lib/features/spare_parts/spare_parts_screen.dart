import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:air_conditioning_system/features/order/ui/order_screen.dart';
import 'package:air_conditioning_system/features/spare_parts/cubit/spare_parts_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SparePartsScreen extends StatelessWidget {
  final String storeId;
  const SparePartsScreen({
    super.key,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SparePartsCubit()..getSpareParts(storeId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: const Text('قطع الغيار'),
          ),
          body: BlocBuilder<SparePartsCubit, SparePartsState>(
            builder: (context, state) {
              SparePartsCubit cubit = context.read<SparePartsCubit>();
              if (state is SparePartsLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              }
              if (cubit.spareParts.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد قطع غيار',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              }
              return Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
                child: ListView.separated(
                  itemBuilder: (context, index) {
                    SparePartModel sparePart = cubit.spareParts[index];

                    return InkWell(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              OrderScreen(sparePartModel: sparePart),
                        ),
                      ),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 0.0,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: sparePart.image,
                              width: 100.0,
                              height: 100.0,
                              placeholder: (context, url) => const Center(
                                child: CustomLoadingIndicator(),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(
                                child: CustomLoadingIndicator(),
                              ),
                            ),
                            const SizedBox(
                              width: 10.0,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    sparePart.name,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10.0,
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        '${sparePart.price} جم',
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      const Text(
                                        '.',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 10.0,
                                      ),
                                      Text(
                                        sparePart.brandName,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10.0,
                  ),
                  itemCount: cubit.spareParts.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
