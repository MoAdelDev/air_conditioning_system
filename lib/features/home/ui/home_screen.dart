import 'package:air_conditioning_system/core/data/app_data.dart';
import 'package:air_conditioning_system/core/widgets/custom_button.dart';
import 'package:air_conditioning_system/core/widgets/custom_loading_indicator.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/add_air_conditioner_screen.dart';
import 'package:air_conditioning_system/features/add_air_conditioner/data/air_conditioner_model.dart';
import 'package:air_conditioning_system/features/add_spare_parts/add_spare_parts_screen.dart';
import 'package:air_conditioning_system/features/add_spare_parts/data/spare_part_model.dart';
import 'package:air_conditioning_system/features/auth/data/store_model.dart';
import 'package:air_conditioning_system/features/auth/ui/login_screen.dart';
import 'package:air_conditioning_system/features/home/logic/cubit/home_cubit.dart';
import 'package:air_conditioning_system/features/air_conditioners/air_conditioners_screen.dart';
import 'package:air_conditioning_system/features/order/data/order_model.dart';
import 'package:air_conditioning_system/features/orders/ui/orders_screen.dart';
import 'package:air_conditioning_system/features/spare_parts/spare_parts_screen.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_expandable_fab/flutter_expandable_fab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeCubit()
        ..getUser()
        ..getStores()
        ..getAirConditioners()
        ..getSpareParts()
        ..getReporters(),
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          HomeCubit cubit = context.read<HomeCubit>();
          if ((storeModel == null && userModel == null)) {
            return Scaffold(
              backgroundColor: Colors.grey[300],
              body: const Center(
                child: CustomLoadingIndicator(),
              ),
            );
          }
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Scaffold(
              backgroundColor: Colors.grey[300],
              appBar: AppBar(
                  title: storeModel != null
                      ? Text(storeModel!.name)
                      : userModel?.email == 'admin@gmail.com'
                          ? const Text('التقارير')
                          : const Text('المتاجر'),
                  actions: [
                    if (storeModel != null)
                      IconButton(
                        icon: const Icon(
                          Icons.request_page,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrdersScreen(),
                            ),
                          );
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.logout,
                        color: Colors.red[900],
                      ),
                      onPressed: () {
                        FirebaseAuth.instance.signOut().then((value) {
                          storeModel = null;
                          userModel = null;
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        });
                      },
                    ),
                  ]),
              floatingActionButtonLocation: ExpandableFab.location,
              floatingActionButton: isStore()
                  ? ExpandableFab(
                      openButtonBuilder: RotateFloatingActionButtonBuilder(
                        child: const Icon(Icons.add),
                        fabSize: ExpandableFabSize.regular,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.blue,
                        shape: const CircleBorder(),
                      ),
                      closeButtonBuilder: DefaultFloatingActionButtonBuilder(
                        child: const Icon(Icons.close),
                        fabSize: ExpandableFabSize.small,
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                        shape: const CircleBorder(),
                      ),
                      children: [
                        FloatingActionButton.extended(
                          label: const Text('إضافة قطع غيار'),
                          heroTag: null,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddSparePartsScreen(),
                            ),
                          ),
                        ),
                        FloatingActionButton.extended(
                          label: const Text('إضافة تكييفات'),
                          heroTag: null,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const AddAirConditionerScreen(),
                            ),
                          ),
                        ),
                      ],
                    )
                  : null,
              body: storeModel != null
                  ? _buildStoreItem(cubit)
                  : userModel?.email == 'admin@gmail.com'
                      ? _buildAdminItem(cubit)
                      : _buildClientItem(cubit),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdminItem(HomeCubit cubit) {
    return Container(
      color: Colors.grey[300],
      child: ListView.separated(
        itemCount: cubit.orders.length,
        itemBuilder: (context, index) {
          OrderModel orderModel = cubit.orders[index];
          return Card(
            shadowColor: Colors.white,
            surfaceTintColor: Colors.white,
            child: Row(
              children: [
                CachedNetworkImage(
                  imageUrl: orderModel.image,
                  width: 100.0,
                  height: 100.0,
                  placeholder: (context, url) => const Center(
                    child: CustomLoadingIndicator(),
                  ),
                  errorWidget: (context, url, error) => const Center(
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
                      Row(
                        children: [
                          Text(
                            'التاجر : ${orderModel.storeName}',
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            '  .  ',
                            style: TextStyle(fontSize: 20.0),
                          ),
                          Text(
                            orderModel.name,
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'الكمية : ${orderModel.amount}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          const Text(
                            '  .  ',
                            style: TextStyle(fontSize: 16.0),
                          ),
                          Text(
                            '${orderModel.totalPrice} جم',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.red[900],
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الشاري : ${orderModel.userName}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            orderModel.address,
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'طريقة الدفع : ${orderModel.paymentMethod}',
                            style: TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10.0,
        ),
      ),
    );
  }

  Widget _buildStoreItem(
    HomeCubit cubit,
  ) =>
      Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              automaticIndicatorColorAdjustment: true,
              tabs: const [
                Tab(
                  text: 'التكييفات',
                ),
                Tab(
                  text: 'قطع الغيار',
                ),
              ],
              onTap: (index) {
                if (index == 0) {
                  tabController.animateTo(0);
                } else if (index == 1) {
                  tabController.animateTo(1);
                }
              },
              controller: tabController,
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                _buildAirContioners(cubit),
                _buildSpareParts(cubit),
              ],
            ),
          ),
        ],
      );

  Widget _buildAirContioners(HomeCubit cubit) => Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12,
        ),
        child: ListView.separated(
          itemBuilder: (context, index) {
            AirConditionerModel airConditioner = cubit.airConditioners[index];

            return InkWell(
              onTap: () {},
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
                      errorWidget: (context, url, error) => const Center(
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
                    const SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () => cubit.deleteAirConditioner(
                        airConditionerId: airConditioner.id,
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
  Widget _buildSpareParts(HomeCubit cubit) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12),
        child: ListView.separated(
          itemBuilder: (context, index) {
            SparePartModel sparePart = cubit.spareParts[index];

            return InkWell(
              onTap: () {},
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
                      errorWidget: (context, url, error) => const Center(
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
                    const SizedBox(
                      width: 5.0,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () =>
                          cubit.deleteSparePart(sparePartId: sparePart.id),
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

  Widget _buildClientItem(HomeCubit cubit) => ListView.separated(
        itemBuilder: (context, index) {
          List<StoreModel> stores = cubit.stores;
          return InkWell(
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AirConditionersScreen(
                                    storeId: stores[index].uid,
                                  ),
                                ),
                              ),
                              text: 'التكييفات',
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: CustomButton(
                              onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SparePartsScreen(
                                    storeId: stores[index].uid,
                                  ),
                                ),
                              ),
                              text: 'قطع الغيار',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: stores[index].logo,
                      placeholder: (context, url) =>
                          const CustomLoadingIndicator(),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        backgroundImage: imageProvider,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            cubit.stores[index].name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            cubit.stores[index].address,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.forward,
                      color: Colors.grey[800],
                    )
                  ],
                ),
              ),
            ),
          );
        },
        separatorBuilder: (context, index) => const SizedBox(
          height: 10,
        ),
        itemCount: cubit.stores.length,
      );
}
