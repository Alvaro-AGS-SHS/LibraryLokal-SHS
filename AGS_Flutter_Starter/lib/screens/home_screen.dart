import 'package:flutter/material.dart';
import 'package:ags_flutter_starter/services/storage_helper.dart';
import 'menu_screen.dart';
import 'cart_screen.dart';
import 'name_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> cartItems = [];
  String _displayName = 'Loading...'; // Variabel penampung nama pengguna

  @override
  void initState() {
    super.initState(); 
    print('=== LIFECYCLE: HomeScreen born (initState) ===');
    print('Selamat Datang ke LibraryLokal! Sistem siap untuk menerima perintah.');
    _loadSavedName(); // Memuat nama dari penyimpanan lokal saat aplikasi terbuka
  }

  @override
  void dispose() {
    print('=== LIFECYCLE: HomeScreen closed (dispose) ===');
    print('Cleaning up resources and ending LibraryLokal session.');
    super.dispose();
  }

  // Fungsi untuk mengambil nama dari StorageHelper
  Future<void> _loadSavedName() async {
    final name = await StorageHelper.getUserName();
    setState(() {
      _displayName = name ?? 'Reader'; // Default jika data kosong
    });
  }

  // Fungsi untuk membuka NameScreen dan menunggu data nama yang baru diperbarui
  Future<void> _editName() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const NameScreen(), // Mengarah ke NameScreen dari kode pertama Anda
      ),
    );
    _loadSavedName(); // Segarkan nama di HomeScreen setelah kembali dari NameScreen
  }

  Future<void> _openMenu() async {
    final updatedCart = await Navigator.push<List<Map<String, dynamic>>>(
      context,
      MaterialPageRoute(
        builder: (context) => MenuScreen(cartSaatIni: cartItems),
      ),
    );

    if (updatedCart != null) {
      setState(() {
        cartItems = List<Map<String, dynamic>>.from(updatedCart);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bookmark updated: ${cartItems.length} Bookmark stored!'),
            backgroundColor: const Color.fromARGB(255, 174, 86, 28),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _viewCart() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CartScreen(cartItems: cartItems),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color brandOrange = Color.fromARGB(255, 174, 86, 28);

    return Scaffold(
      backgroundColor: const Color(0xFFF7F2EC),
      appBar: AppBar(
        title: const Text(
          'LibraryLokal', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: brandOrange,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.white),
                    onPressed: _viewCart,
                  ),
                  if (cartItems.isNotEmpty)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Color(0xFFFFD166),
                          shape: BoxShape.circle,
                        ),
                        constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                        child: Text(
                          '${cartItems.length}',
                          style: const TextStyle(
                            color: Color(0xFF1A1A2E),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Pembungkus Card yang sebelumnya rusak/terpotong kini diperbaiki
              Card(
                elevation: 1,
                color: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F4FD),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(Icons.storefront, color: brandOrange, size: 32),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Menampilkan nama dinamis di text sambutan
                                Text(
                                  'Halo, $_displayName!', 
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1E293B),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'LibraryLokal, siap menemanimu membaca',
                                  style: TextStyle(fontSize: 13, color: Color(0xFF607D8B)),
                                ),
                              ],
                            ),
                          ),
                          // Tombol Edit di sebelah teks nama untuk mengubah nama
                          IconButton(
                            icon: const Icon(Icons.edit, color: brandOrange),
                            onPressed: _editName,
                          ),
                        ],
                      ),
                      const Divider(height: 28),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFAFAF7),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF8E9AAF), width: 0.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.info_outline, size: 20, color: brandOrange),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'Reader: $_displayName (${cartItems.length} items in Favorite)',
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: Color.fromARGB(255, 174, 86, 28),
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
              const SizedBox(height: 24),
              const Text(
                'Main Navigation',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
              ),
              const SizedBox(height: 12),
              
              // Contoh tombol navigasi utama ke Menu
              ElevatedButton.icon(
                onPressed: _openMenu,
                icon: const Icon(Icons.book),
                label: const Text('Buka Menu Buku'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: brandOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
            



          const SizedBox(height: 14),

              // Button 2: View Cart (Opens CartScreen)
              OutlinedButton.icon(
                onPressed: _viewCart,
                icon: const Icon(Icons.favorite, color: brandOrange),
                label: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 14.0),
                  child: Text(
                    'View Favorites (${cartItems.length} Items)', // [CHANGE HERE]: Cart button label
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: brandOrange),
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: brandOrange, width: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const Spacer(),

              // Week 8 Architectural Reminder
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3E0),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD166)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.lightbulb_outline, color: Color(0xFFD4880A)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Week 8 Concept: HomeScreen stores cartItems (State Owner). MenuScreen updates it via pop, and HomeScreen triggers setState()!',
                        style: TextStyle(fontSize: 12, color: Color(0xFFD4880A), fontWeight: FontWeight.w600),
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
