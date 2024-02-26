import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:air_conditioning_system/features/air_conditioners/cubit/air_conditioners_cubit.dart';
import 'package:air_conditioning_system/features/order/ui/order_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AirConditionersScreen extends StatelessWidget {
  final String storeId;
  const AirConditionersScreen({
    super.key,
    required this.storeId,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AirConditionersCubit()..getAirConditioners(storeId),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          backgroundColor: Colors.grey[300],
          appBar: AppBar(
            title: const Text('التكييفات'),
          ),
          body: BlocBuilder<AirConditionersCubit, AirConditionersState>(
            builder: (context, state) {
              AirConditionersCubit cubit = context.read<AirConditionersCubit>();
              if (state is AirConditionersLoading) {
                return const Center(
                  child: CustomLoadingIndicator(),
                );
              }
              if (cubit.airConditioners.isEmpty) {
                return const Center(
                  child: Text(
                    'لا يوجد تكييفات',
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
                    AirConditionerModel airConditioner =
                        cubit.airConditioners[index];

                    return InkWell(
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderScreen(
                                  airConditionerModel: airConditioner))),
                      child: Card(
                        color: Colors.white,
                        shadowColor: Colors.white,
                        elevation: 0.0,
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              imageUrl: airConditioner.image,
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
                                    airConditioner.name,
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
                                        '${airConditioner.price} جم',
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
                                        '${airConditioner.capacity} حصان',
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
                  itemCount: cubit.airConditioners.length,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
