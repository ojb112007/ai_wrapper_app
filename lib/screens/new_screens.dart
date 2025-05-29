// import 'package:flutter/material.dart';

// class NewsScreen extends StatefulWidget {
//   const NewsScreen({Key? key}) : super(key: key);

//   @override
//   State<NewsScreen> createState() => _NewsScreenState();
// }

// class _NewsScreenState extends State<NewsScreen> {
//   final PageController _pageController = PageController(viewportFraction: 0.9);
//   int _currentPage = 0;

//   @override
//   void initState() {
//     super.initState();
//     _pageController.addListener(() {
//       int next = _pageController.page!.round();
//       if (_currentPage != next) {
//         setState(() {
//           _currentPage = next;
//         });
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _pageController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.black,
//       body: SafeArea(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Top Bar with Icons and Title
//             _buildTopBar(),

//             // Category Tabs
//             _buildCategoryTabs(),

//             // News Cards with Sticky Sliding
//             Expanded(
//               child: StickyCardPageView(
//                 controller: _pageController,
//                 itemCount: newsList.length,
//                 itemBuilder: (context, index) {
//                   return NewsCard(
//                     article: newsList[index],
//                     isActive: _currentPage == index,
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTopBar() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(8),
//             child: const Row(
//               children: [
//                 Icon(Icons.cloud_outlined, color: Colors.white),
//                 SizedBox(width: 4),
//                 Icon(Icons.add, color: Colors.white, size: 16),
//               ],
//             ),
//           ),
//           const Text(
//             'Discover',
//             style: TextStyle(
//               fontSize: 24,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Container(
//             decoration: BoxDecoration(
//               color: Colors.grey[900],
//               borderRadius: BorderRadius.circular(20),
//             ),
//             padding: const EdgeInsets.all(8),
//             child: const Icon(Icons.headphones, color: Colors.white),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryTabs() {
//     return Container(
//       height: 50,
//       margin: const EdgeInsets.only(bottom: 16),
//       child: ListView(
//         scrollDirection: Axis.horizontal,
//         padding: const EdgeInsets.symmetric(horizontal: 8),
//         children: [
//           _buildCategoryTab('Top Stories', isSelected: true),
//           _buildCategoryTab('Tech & Science'),
//           _buildCategoryTab('Finance'),
//           _buildCategoryTab('Arts'),
//         ],
//       ),
//     );
//   }

//   Widget _buildCategoryTab(String title, {bool isSelected = false}) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8),
//       decoration: BoxDecoration(
//         color: isSelected ? Colors.white : Colors.grey[900],
//         borderRadius: BorderRadius.circular(24),
//       ),
//       padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//       alignment: Alignment.center,
//       child: Text(
//         title,
//         style: TextStyle(
//           fontSize: 16,
//           fontWeight: FontWeight.w600,
//           color: isSelected ? Colors.black : Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _buildBottomNavigationBar() {
//     return Container(
//       height: 80,
//       decoration: BoxDecoration(
//         color: Colors.black,
//         border: Border(
//           top: BorderSide(color: Colors.grey[900]!, width: 0.5),
//         ),
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildNavBarItem(Icons.search, isSelected: false),
//           _buildNavBarItem(Icons.language, isSelected: true),
//           _buildNavBarItem(Icons.star_border, isSelected: false),
//           _buildNavBarItem(Icons.person_outline, isSelected: false),
//         ],
//       ),
//     );
//   }

//   Widget _buildNavBarItem(IconData icon, {required bool isSelected}) {
//     return Icon(
//       icon,
//       color: isSelected ? Colors.white : Colors.grey,
//       size: 28,
//     );
//   }
// }

// // Custom PageView with Sticky Scrolling Physics
// class StickyCardPageView extends StatelessWidget {
//   final PageController controller;
//   final int itemCount;
//   final Widget Function(BuildContext, int) itemBuilder;

//   const StickyCardPageView({
//     Key? key,
//     required this.controller,
//     required this.itemCount,
//     required this.itemBuilder,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return PageView.builder(
//       controller: controller,
//       physics: const StickyScrollPhysics(),
//       itemCount: itemCount,
//       itemBuilder: itemBuilder,
//     );
//   }
// }

// // Custom ScrollPhysics for Sticky Scrolling Effect
// class StickyScrollPhysics extends ScrollPhysics {
//   const StickyScrollPhysics({ScrollPhysics? parent}) : super(parent: parent);

//   @override
//   StickyScrollPhysics applyTo(ScrollPhysics? ancestor) {
//     return StickyScrollPhysics(parent: buildParent(ancestor));
//   }

//   @override
//   SpringDescription get spring => const SpringDescription(
//         mass: 80,
//         stiffness: 100,
//         damping: 1.0,
//       );

//   @override
//   Simulation? createBallisticSimulation(
//       ScrollMetrics position, double velocity) {
//     // Implement a custom threshold for the sticky effect
//     final double threshold = 0.5;

//     // If the velocity is low enough, snap to the nearest page
//     if (velocity.abs() <= 500) {
//       final double page = position.pixels / position.viewportDimension;
//       final int targetPage = velocity > 0
//           ? page.ceil()
//           : velocity < 0
//               ? page.floor()
//               : page.round();

//       final double currentPage = position.pixels / position.viewportDimension;
//       final double targetPixels = targetPage * position.viewportDimension;

//       // Only snap if we're past the threshold
//       if ((targetPage - currentPage).abs() >= threshold ||
//           velocity.abs() >= 200) {
//         return ScrollSpringSimulation(
//           spring,
//           position.pixels,
//           targetPixels,
//           velocity,
//           tolerance: const Tolerance(velocity: 0.01, distance: 0.01),
//         );
//       }
//       return null;
//     }

//     // For higher velocities, use the default behavior
//     return super.createBallisticSimulation(position, velocity);
//   }
// }

// // News Card Widget
// class NewsCard extends StatelessWidget {
//   final NewsArticle article;
//   final bool isActive;

//   const NewsCard({
//     Key? key,
//     required this.article,
//     this.isActive = false,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedContainer(
//       duration: const Duration(milliseconds: 300),
//       margin: EdgeInsets.only(
//         left: 8,
//         right: 8,
//         bottom: isActive ? 20 : 40,
//         top: isActive ? 0 : 20,
//       ),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(16),
//         color: Colors.grey[900],
//         boxShadow: isActive
//             ? [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.3),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 )
//               ]
//             : [],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // News Image
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
//             child: Container(
//               height: 280,
//               width: double.infinity,
//               color: Colors.grey[800],
//               child: article.imageUrl != null
//                   ? Image.network(
//                       article.imageUrl!,
//                       fit: BoxFit.cover,
//                     )
//                   : Center(
//                       child: Icon(
//                         Icons.image,
//                         size: 80,
//                         color: Colors.grey[700],
//                       ),
//                     ),
//             ),
//           ),

//           // News Content
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   article.title,
//                   style: const TextStyle(
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                   maxLines: 2,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   article.summary,
//                   style: TextStyle(
//                     fontSize: 16,
//                     color: Colors.grey[400],
//                   ),
//                   maxLines: 3,
//                   overflow: TextOverflow.ellipsis,
//                 ),
//               ],
//             ),
//           ),

//           const Spacer(),

//           // Author Info and Actions
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Row(
//               children: [
//                 CircleAvatar(
//                   radius: 16,
//                   backgroundColor: Colors.grey[800],
//                   backgroundImage: article.authorImageUrl != null
//                       ? NetworkImage(article.authorImageUrl!)
//                       : null,
//                   child: article.authorImageUrl == null
//                       ? const Icon(Icons.person, color: Colors.white70)
//                       : null,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   article.source,
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey[400],
//                   ),
//                 ),
//                 const Spacer(),
//                 const Icon(Icons.bookmark_border, color: Colors.white70),
//                 const SizedBox(width: 16),
//                 const Icon(Icons.headphones, color: Colors.white70),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // News Article Model
// class NewsArticle {
//   final String title;
//   final String summary;
//   final String source;
//   final String? imageUrl;
//   final String? authorImageUrl;

//   const NewsArticle({
//     required this.title,
//     required this.summary,
//     required this.source,
//     this.imageUrl,
//     this.authorImageUrl,
//   });
// }

// // Sample News Data
// final List<NewsArticle> newsList = [
//   // const NewsArticle(
//   //   title: 'Abbott signs Texas DOGE law creating Regulatory Efficiency Office',
//   //   summary:
//   //       'Governor Greg Abbott has signed Senate Bill 14 into law, establishing the Texas Regulatory Efficiency Office, nicknamed "Texas DOGE," which aims to streamline government operations.',
//   //   source: 'pagesandbits',
//   //   imageUrl: 'https://images.unsplash.com/photo-1541872705-0c5073f82571',
//   //   authorImageUrl:
//   //       'https://images.unsplash.com/photo-1570295999919-56ceb5ecca61',
//   // ),
//   const NewsArticle(
//     title: 'Tech Giants Announce Joint AI Safety Initiative',
//     summary:
//         'Leading technology companies have formed a coalition to establish ethical guidelines and safety protocols for artificial intelligence development.',
//     source: 'techreport',
//     imageUrl: 'https://images.unsplash.com/photo-1522869635100-9f4c5e86aa37',
//     authorImageUrl:
//         'https://images.unsplash.com/photo-1568602471122-7832951cc4c5',
//   ),
//   // const NewsArticle(
//   //   title: 'Global Climate Summit Reaches Landmark Agreement',
//   //   summary:
//   //       'World leaders have committed to ambitious carbon reduction targets during the latest international climate conference.',
//   //   source: 'worldnewstoday',
//   //   imageUrl: 'https://images.unsplash.com/photo-1569920100547-76d4b3d17098',
//   //   authorImageUrl:
//   //       'https://images.unsplash.com/photo-1580489944761-15a19d654956',
//   // ),
//   const NewsArticle(
//     title: 'Breakthrough in Quantum Computing Announced',
//     summary:
//         'Scientists have achieved a significant milestone in quantum computing that could revolutionize data processing capabilities.',
//     source: 'scienceinsider',
//     imageUrl: 'https://images.unsplash.com/photo-1526374965328-7f61d4dc18c5',
//     authorImageUrl: 'https://images.unsplash.com/photo-1544725176-7c40e5a71c5e',
//   ),
// ];
import 'package:flutter/material.dart';

// void main() {
//   runApp(const NaturalMedicineApp());
// }

// class NaturalMedicineApp extends StatelessWidget {
//   const NaturalMedicineApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Natural Healing',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         brightness: Brightness.dark,
//         scaffoldBackgroundColor: const Color(0xFF121212),
//         primaryColor: const Color(0xFF1DB954), // Green accent similar to Fiverr
//         colorScheme: const ColorScheme.dark(
//           primary: Color(0xFF1DB954),
//           secondary: Color(0xFF1ED760),
//         ),
//         useMaterial3: true,
//       ),
//       home: const HomeScreen(),
//     );
//   }
// }

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'NaturalHealing',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white24, width: 1),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Icon(Icons.diamond_outlined, size: 18),
                      ),
                    ),
                  ],
                ),
              ),

              // Search Bar
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    child: Row(
                      children: [
                        Icon(Icons.search, color: Colors.white54),
                        SizedBox(width: 8),
                        Text(
                          'Search remedies & herbs',
                          style: TextStyle(color: Colors.white54, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Popular Healing Articles
              const SectionHeader(title: 'Popular Articles'),

              SizedBox(
                height: 220,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    ArticleCard(
                      image: 'assets/images/herbs.jpg',
                      title: 'Medicinal Herbs',
                      subtitle: 'Top 10 herbs for immune system',
                    ),
                    ArticleCard(
                      image: 'assets/images/meditation.jpg',
                      title: 'Meditation',
                      subtitle: 'Healing through mindfulness',
                    ),
                    ArticleCard(
                      image: 'assets/images/acupuncture.jpg',
                      title: 'Acupuncture',
                      subtitle: 'Ancient healing techniques',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Active Wellness Plans
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'My Wellness Plan',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
              ),

              // Wellness Plan Card
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: Container(
                                width: 60,
                                height: 60,
                                color: Colors.green.shade900,
                                child: const Center(
                                  child: Icon(Icons.spa,
                                      color: Colors.white, size: 30),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '\$39.95',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Personalized herbal remedy plan with monthly refills',
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.amber,
                              child: Icon(Icons.person,
                                  size: 18, color: Colors.black),
                            ),
                            const SizedBox(width: 8),
                            const Text(
                              'Dr. Sarah Chen',
                              style: TextStyle(
                                fontSize: 14,
                              ),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.purple.shade900,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Apr 30, 2025',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white54,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Featured Products Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white10,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'FEATURED PRODUCTS',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Explore natural remedies,\npicked for you.',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Featured Products Grid
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 0.8,
                  children: const [
                    ProductCard(
                      color: Color(0xFFF9A826),
                      icon: Icons.eco,
                      title: 'Organic\nTurmeric',
                      creator: 'OrganicHerbs',
                    ),
                    ProductCard(
                      color: Color(0xFF9C27B0),
                      icon: Icons.spa,
                      title: 'Lavender\nEssential Oil',
                      creator: 'NaturalEssence',
                    ),
                    ProductCard(
                      color: Color(0xFF1DB954),
                      icon: Icons.local_florist,
                      title: 'Herbal\nTea Blend',
                      creator: 'TeaHealing',
                    ),
                    ProductCard(
                      color: Color(0xFF03A9F4),
                      icon: Icons.water_drop,
                      title: 'CBD\nOil Drops',
                      creator: 'PureRelief',
                    ),
                  ],
                ),
              ),

              // Recently Viewed Section
              const SectionHeader(title: 'Recently Viewed & More'),

              // Recently Viewed Products
              SizedBox(
                height: 300,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: const [
                    RecentProductCard(
                      image: 'assets/images/ashwagandha.jpg',
                      title: 'Ashwagandha Root Extract',
                      rating: 4.9,
                      reviews: 128,
                      price: 19.99,
                    ),
                    RecentProductCard(
                      image: 'assets/images/ginger.jpg',
                      title: 'Organic Ginger Supplement',
                      rating: 4.7,
                      reviews: 86,
                      price: 15.95,
                    ),
                    RecentProductCard(
                      image: 'assets/images/echinacea.jpg',
                      title: 'Echinacea Immune Support',
                      rating: 4.8,
                      reviews: 214,
                      price: 22.50,
                    ),
                  ],
                ),
              ),

              // Your Interest Section
              const SectionHeader(title: 'What sparks your interest?'),

              // Interest Categories
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    InterestItem(
                      icon: Icons.article,
                      title: 'Read about holistic health',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    InterestItem(
                      icon: Icons.health_and_safety,
                      title: 'Find a natural remedy',
                      onTap: () {},
                    ),
                    const SizedBox(height: 12),
                    InterestItem(
                      icon: Icons.shopping_basket,
                      title: 'Shop organic products',
                      onTap: () {},
                    ),
                  ],
                ),
              ),

              // Referral Banner
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.purple.shade900.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Share & get up to \$50 off',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Give friends a 15% discount up to \$50 off their first natural remedy order.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Text(
                              'Invite Friends →',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // What's New Section
              const SectionHeader(title: "What's new in natural healing?"),

              // Featured Article with Image
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: const DecorationImage(
                      image:
                          NetworkImage('https://example.com/placeholder.jpg'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ancient healing practices making a comeback',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Spacing
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF121212),
        selectedItemColor: Theme.of(context).primaryColor,
        unselectedItemColor: Colors.white54,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.email), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.article), label: 'Articles'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;

  const SectionHeader({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            'See All',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final String image;
  final String title;
  final String subtitle;

  const ArticleCard({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 160,
              width: double.infinity,
              fit: BoxFit.cover,
              // Use a placeholder color since we don't have actual assets
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                color: Theme.of(context).primaryColor.withOpacity(0.5),
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white70),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String creator;

  const ProductCard({
    super.key,
    required this.color,
    required this.icon,
    required this.title,
    required this.creator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 12,
            right: 12,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white10,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4.0),
                child: Icon(Icons.favorite_border, size: 16),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 32),
                const Spacer(),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  creator,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecentProductCard extends StatelessWidget {
  final String image;
  final String title;
  final double rating;
  final int reviews;
  final double price;

  const RecentProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.rating,
    required this.reviews,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              image,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              // Use a placeholder color since we don't have actual assets
              errorBuilder: (context, error, stackTrace) => Container(
                height: 180,
                color: Colors.grey.shade800,
                child: const Center(
                  child: Icon(Icons.image, color: Colors.white70),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 16),
              const SizedBox(width: 4),
              Text(
                rating.toString(),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Text(
                '($reviews)',
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'From \$${price.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class InterestItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const InterestItem({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.all(8),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onTap,
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.black,
              ),
              child: const Text('+ Add'),
            ),
          ],
        ),
      ),
    );
  }
}
