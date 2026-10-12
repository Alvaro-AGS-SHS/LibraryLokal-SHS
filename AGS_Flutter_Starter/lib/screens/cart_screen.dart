import 'package:flutter/material.dart';

// ============================================================================
// KANTINKU: CART SCREEN (Week 8: Reading Shared State from Parent)
// Alta Global School | IT Grade 10 & 11 (SHS)
//
// WEEK 8 CONCEPTS DEMONSTRATED HERE:
// 1. Receiving State via Constructor: CartScreen receives `cartItems` from HomeScreen.
// 2. Stateless Architecture: CartScreen does not need its own state,
//    it simply renders the data owned and shared by HomeScreen (Lifting State Up).
// 3. Data Aggregation: Calculates total order price using `fold()`.
// 4. Empty State Handling: Friendly UI when the cart has no items.
//
// Look for '// [CHANGE HERE]' comments to customize your team's cart screen!
// ============================================================================

class CartScreen extends StatelessWidget {
  // [CHANGE HERE]: Receives cart items stored in HomeScreen
  final List<Map<String, dynamic>> cartItems;

  const CartScreen({super.key, required this.cartItems});

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color.fromARGB(255, 174, 86, 28);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        title: const Text(
          'Favorite',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: brandOrange,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            ? _buildEmptyState(context, brandOrange)
            : _buildCartList(context, brandOrange),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Empty state view when cart contains no items
  // --------------------------------------------------------------------------
  Widget _buildEmptyState(BuildContext context, Color brandColor) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFE8F4FD),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.favorite_border_outlined, size: 64, color: brandColor),
            ),
            const SizedBox(height: 20),
            const Text(
              'Favorite is empty', // [CHANGE HERE]: Empty state title
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have not shown love to any titles yet :). Browse the library menu to mark a title as favorite!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Color(0xFF607D8B)),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.home, color: Colors.white),
              label: const Text('Back to Menu', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: brandColor,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // Populated cart view with list of items and checkout summary
  // --------------------------------------------------------------------------
  Widget _buildCartList(BuildContext context, Color brandColor) {
    return Column(
      children: [
        // Info bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          color: const Color(0xFFE8F4FD),
          child: Text(
            'Total ${cartItems.length} item(s) ready to save:',
            style: const TextStyle(fontWeight: FontWeight.w600, color: Color.fromARGB(255, 174, 86, 28)),
          ),
        ),

        // Items list
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return Card(
                elevation: 1,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(color: Color(0xFF8E9AAF), width: 0.5),
                ),
                child: ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAF7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Image.network(
                      item['image'] as String? ?? 'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAPYAAABzCAMAAACcsQ+RAAAAY1BMVEUzMzP///8vLy8pKSksLCwhISEmJiY6Ojp3d3e6urqPj4/f39/Q0NDo6Ojv7++Hh4caGhqXl5egoKD29vYNDQ1paWlCQkJXV1dJSUnBwcHY2Niurq5jY2OAgIAWFhZOTk4AAAB2i0mwAAAC6UlEQVR4nO3Xa3OcIBQGYO54AVzFG+qu+f+/sgdN0zTth06mTWr7PjPZiOvO+HIAkTEAAAAAAAAAAAAAAAAAAAAAAAAAAAAA+DuIz76B3++nkaR5OS3Vx93Ln6eMOQ+EeZMrBx6K+bk1FoP9yPv6s3ST1jEfyCLdvyu4sNR0oTg7Qw2hHv+dMX5rOe8eIufn3ZnwDCerNCrhYiGPM2Lu2vMXQrxcdd1uuHU8xs28xFaGjYImtOpdYDrHflg6Qd3w1DOhDX1vxTEtNBuV0vqaM/7WxsQTVTDHlkzvq1tSw8zU+bBWzMWhcku5CbV3rWVVy9qjycSjSUs5DetwyZJTtZuSV/KILeTgY+08d2arefSJ5rYLdc39pofgrVpCCktuStHy6Lx3vJWfHeE9aG43c/STOga5dbxiaqZPOXu/W+F4PQlT8o5i11YeTU3N2xZCIe3KeWU+O8J7UOyqb3nqc2y9Bd/TeC+4Y5aqKyl2pdntzssjtqHmTWhq9g39MbPX1EFXHOU5thkdL/ocu+Kup9Vri8tovR/FuZKbgmJvR+xIzzNqJuqp7kE/TxeOLeUQa5tjU9kpjJpCPVO1v8aWr2OfvfDoeHujDlqvHFvojnf3b9WecrVzbPZ9teXXapf9GVuUV45N+44QVnqAUdWfaJdKc9vSILeKHTnlD4O87Cu+9kyOy3WXtIZ2HOYePe+OSS7NSDPWWB9G9mpu05LGXlV7iH7XrI250y6Intv5xgUNV6q2amIoV3pMMaVq7tZ9eR3byuW5+EnbxJc1+eWisXWzHC8bckquEbRfoT1I3Y05XB3cvibakcltaen70qpvTeon2qwM60Vjv7xHq/O/MfNsdV6ljJ2tksdZ6gQmpBL547iUNubTNI5Sp3i/aOy3hBJvDn520b744aHvwe9XXMjfTeU9+RL5v1LsX/VUJOfK4fHZ9/HRJLPPb97/GfFfTWsAAAAAAAAAAAAAAAAAAAAAAAAAAIC/xhdDbCeGQLZO0wAAAABJRU5ErkJggg==',
                      fit: BoxFit.fill,
                    ),
                  ),
                  title: Text(
                    item['name'] as String,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  subtitle: Text(
                    item['writer'] as String? ?? 'Unknown Writer',
                    style: const TextStyle(fontSize: 12, color: Color(0xFF607D8B)),
                  ),
                ),
              );
            },
          ),
        ),

        // Checkout Bottom Sheet Summary
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                offset: const Offset(0, -3),
                blurRadius: 10,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total Favorites:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  ),
                  Text(
                    '${cartItems.length}', // [CHANGE HERE]: Currency formatting
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 174, 86, 28),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Show confirmation SnackBar
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Favorites Saved! Happy Readings!.'),
                        backgroundColor: const Color.fromARGB(255, 226, 112, 36),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  },
                  icon: const Icon(Icons.save_alt, color: Colors.white),
                  label: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text(
                      'Save Now', // [CHANGE HERE]: Pay button label
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 226, 112, 36),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
