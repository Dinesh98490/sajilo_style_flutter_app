import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeState();
}

class _HomeState extends State<HomeView> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    HomePage(),
    Center(child: Text('Search Page')),
    Center(child: Text('Favourite Page')),
    Center(child: Text('Wishlist Page')),
    Center(child: Text('Profile Page')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        elevation: 1,
        title: const Text(
          'Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.orange,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favourite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_card),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
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
                    color: Color.fromARGB(255, 227, 224, 224), //color of the main sections of the dashbboard
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

          // Offer Grid
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            children: const [
              OfferCard(
                label: 'Min 30% Off',
                icon: Icons.local_offer,
                color: Colors.teal,
                imagePath: 'assets/images/air_max.png',
              ),
              OfferCard(
                label: 'Buy 1 Get 1',
                icon: Icons.shopping_bag,
                color: Colors.indigo,
                imagePath: 'assets/images/air_force_1.png',
              ),
              OfferCard(
                label: 'Flat 50%',
                icon: Icons.discount,
                color: Color.fromARGB(255, 70, 56, 51),
                imagePath: 'assets/images/black_shoes.png',
              ),
              OfferCard(
                label: 'New Arrivals',
                icon: Icons.new_releases,
                color: Colors.green,
                imagePath: 'assets/images/black_shoes.png',
              ),
            ],
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
