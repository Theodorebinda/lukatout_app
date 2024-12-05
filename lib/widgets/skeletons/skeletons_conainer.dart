import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerLoading extends StatelessWidget {
  const ShimmerLoading({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade50,
      child: child,
    );
  }
}

Widget buildUserProfilSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 70.0),
      child: Column(
        mainAxisSize:
            MainAxisSize.min, // Ajuste la taille du Column à son contenu
        children: [
          Container(
            //skeleton avatar
            padding: const EdgeInsets.all(2.0),
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            //skeleton name
            width: 150.0,
            height: 20.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            //skeleton email
            width: 230.0,
            height: 15.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey.shade300,
            ),
          ),
          const SizedBox(height: 5),
          Container(
            width: 150.0,
            height: 15.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.grey.shade300,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget buildUserInfoSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: 150.0,
            height: 20.0,
            color: Colors.grey.shade300,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 150.0,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(3, (index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  margin: const EdgeInsets.only(right: 20.0),
                  child: Card(
                    color: Colors.grey.shade300,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 40.0,
                                height: 40.0,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(width: 5),
                              Container(
                                width: 100.0,
                                height: 20.0,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Container(
                            width: 80.0,
                            height: 20.0,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildTaxTypesSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: 50.0,
                      height: 10.0,
                      color: Colors.grey.shade400,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

Widget buildRecentActivitiesSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 150.0,
            height: 25.0,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 10),
          Column(
            children: List.generate(3, (index) {
              return Card(
                color: Colors.grey.shade300,
                margin: const EdgeInsets.symmetric(vertical: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 30.0,
                            height: 30.0,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 100.0,
                                height: 10.0,
                                color: Colors.grey.shade400,
                              ),
                              const SizedBox(height: 5),
                              Container(
                                width: 80.0,
                                height: 10.0,
                                color: Colors.grey.shade400,
                              ),
                            ],
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Container(
                            width: 50.0,
                            height: 10.0,
                            color: Colors.grey.shade400,
                          ),
                          const SizedBox(height: 5),
                          Container(
                            width: 40.0,
                            height: 10.0,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    ),
  );
}

Widget buildInfoSectionSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: Column(
      children: [
        Column(
          children: List.generate(4, (index) {
            return Column(
              children: [
                Container(
                  width: double.infinity,
                  height: 70.0,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius:
                        BorderRadius.circular(10.0), // Ajout des coins arrondis
                  ),
                ),
                const SizedBox(height: 10.0),
              ],
            );
          }),
        ),
      ],
    ),
  );
}

Widget buildServiceGridSkeleton(BuildContext context) {
  return ShimmerLoading(
    child: SizedBox(
      height: 600,
      child: GridView.builder(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 6.0,
          mainAxisSpacing: 6.0,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100.0,
                height: 100.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                ),
              ),
              const SizedBox(height: 2),
            ],
          );
        },
      ),
    ),
  );
}

Widget buildTaxImage(BuildContext context,
    {double width = 100.0, double height = 20.0}) {
  return ShimmerLoading(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Card(
          color: const Color.fromARGB(255, 27, 22, 22),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: 6,
              itemBuilder: (context, index) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: width,
                      height: height,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 10),
                    Container(
                      width:
                          width * 0.7, // ajustement pour la largeur secondaire
                      height: height,
                      color: Colors.grey.shade400,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    ),
  );
}

class SkeletonsContainer extends StatelessWidget {
  const SkeletonsContainer({super.key}); // Convert 'key' to a super parameter

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildUserInfoSkeleton(context), // Call the function here
        buildTaxTypesSkeleton(context),
        buildRecentActivitiesSkeleton(context),
        buildInfoSectionSkeleton(context), // Call the function here
        buildUserProfilSkeleton(context),
        buildServiceGridSkeleton(context),
        buildTaxImage(context),
      ],
    );
  }
}
