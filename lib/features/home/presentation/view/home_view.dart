import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sajilo_style/app/constant/api_endpoints.dart';
import 'package:sajilo_style/features/auth/presentation/view/login_view.dart';
import 'package:sajilo_style/features/profile/presentation/view/profile_view.dart';
import '../../domain/entity/product_entity.dart';
import '../product_view_model/product_bloc.dart';
import '../product_view_model/product_state.dart';
import '../product_view_model/product_event.dart';
import 'package:sajilo_style/features/home/presentation/view/product_detail_view.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/cart_bloc.dart';
import 'package:sajilo_style/features/home/presentation/view/cart_view.dart';
import 'package:sajilo_style/app/service_locator/service_locator.dart';
import 'package:sajilo_style/features/home/presentation/view/order_view.dart';
import 'package:sajilo_style/features/home/presentation/product_view_model/payment_order_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'dart:async';
import 'dart:math';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  int _selectedIndex = 0;
  StreamSubscription? _accelerometerSubscription;
  double _shakeThreshold = 15.0; // Lowered threshold for easier shake detection
  DateTime? _lastShakeTime;
  bool _isLogoutDialogOpen = false;

  @override
  void initState() {
    super.initState();
    _accelerometerSubscription = accelerometerEvents.listen(_onAccelerometerEvent);
  }

  void _onAccelerometerEvent(AccelerometerEvent event) {
    final now = DateTime.now();
    final double acceleration = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
    print('Acceleration: $acceleration'); // Debug print
    if (acceleration > _shakeThreshold) {
      print('Shake detected!'); // Debug print
      if (_lastShakeTime == null || now.difference(_lastShakeTime!) > const Duration(seconds: 2)) {
        _lastShakeTime = now;
        if (!mounted) return;
        _showLogoutDialog();
      }
    }
  }

  void _showLogoutDialog() {
    if (_isLogoutDialogOpen) return;
    _isLogoutDialogOpen = true;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Do you want to logout?'),
        actions: [
          TextButton(
            onPressed: () {
              _isLogoutDialogOpen = false;
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              _isLogoutDialogOpen = false;
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginView()));
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    ).then((_) {
      _isLogoutDialogOpen = false;
    });
  }

  @override
  void dispose() {
    _accelerometerSubscription?.cancel();
    super.dispose();
  }

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    // Center(child: Text('Search Page')),
    OrderView(),
    CartView(),
    Center(child: ProfileView()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // small chanegs on the design

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CartBloc>(
          create: (_) => serviceLocator<CartBloc>(),
        ),
        BlocProvider<PaymentOrderBloc>(
          create: (_) => serviceLocator<PaymentOrderBloc>(),
        ),
      ],
      child: Scaffold(
        body: _pages[_selectedIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.white,
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            // BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_shopping_cart),
              label: ' Cart',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  final String userName = 'Dinesh';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Hi, $userName!',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 12),

          // Search bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search for products', // search bar
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[200],
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Categories with icons and images
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: const [
                CategoryImageCard(
                  title: 'Categories',
                  icon: Icons.category,
                  color: Colors.blue,
                  imagePath: 'assets/images/category.png',
                ),
                CategoryImageCard(
                  title: 'Men',
                  icon: Icons.male,
                  color: Colors.blue,
                  imagePath: 'assets/images/man.jpg',
                ),
                CategoryImageCard(
                  title: 'Women',
                  icon: Icons.female,
                  color: Color.fromARGB(255, 174, 159, 164),
                  imagePath: 'assets/images/women.jpg',
                ),
                CategoryImageCard(
                  title: 'Kids',
                  icon: Icons.child_care,
                  color: Color.fromARGB(255, 132, 110, 136),
                  imagePath: 'assets/images/kids.jpg',
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Poster
          Container(
            width: double.infinity,
            height: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Colors.orange, Colors.deepOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              image: DecorationImage(
                image: AssetImage('assets/images/air_max.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Big Fashion Festival',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(
                      255,
                      227,
                      224,
                      224,
                    ), //color of the main sections of the dashbboard
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  '70% - 80% Off',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.yellow,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          const Text(
            'Explore',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              if (state is ProductLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProductLoaded) {
                final products = state.products;
                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: products.length,
                  separatorBuilder:
                      (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    return ProductCard(
                      product: products[index],
                      onTap: () {
                        final cartBloc = BlocProvider.of<CartBloc>(context);
                        final paymentOrderBloc = BlocProvider.of<PaymentOrderBloc>(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(value: cartBloc),
                                BlocProvider.value(value: paymentOrderBloc),
                              ],
                              child: ProductDetailView(product: products[index]),
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              } else if (state is ProductError) {
                return Center(
                  child: Text(
                    state.message,
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              } else {
                // Initial state: trigger loading
                context.read<ProductBloc>().add(const LoadProducts());
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}

class CategoryImageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final String imagePath;

  const CategoryImageCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: color.withOpacity(0.2),
                ),
              ),
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.white,
                backgroundImage: AssetImage(imagePath),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }
}

class OfferCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final String? imagePath;

  const OfferCard({
    required this.label,
    required this.icon,
    required this.color,
    this.imagePath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color.withOpacity(0.1),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imagePath != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Image.asset(
                  imagePath!,
                  width: 100, // size of the image
                  height: 100,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(icon, color: color, size: 32),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;
  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    print("http://10.0.2.2:5050/${product.image}");
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: "http://10.0.2.2:5050/${product.image}",
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/category.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/category.png',
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.category.title,
                      style: const TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Rs. ${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        color: Colors.deepOrange,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.desc,
                      style: const TextStyle(
                        color: Colors.black54,
                        fontSize: 12,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                        onPressed: () {
                          // Add to cart or details action
                        },
                        child: const Text(
                          'Add to Cart',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
