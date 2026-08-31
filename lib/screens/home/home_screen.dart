import 'package:flutter/material.dart'; // Flutter-এর Material Design widgets ব্যবহার করার জন্য।
import '../medicine/add_medicine_screen.dart';

class HomeScreen extends StatelessWidget { // এটি আমাদের Home/Dashboard screen।
  const HomeScreen({super.key}); // Widget-এর constructor।

  @override
  Widget build(BuildContext context) { // এই method screen-এর পুরো UI তৈরি করে।
    return Scaffold( // একটি basic screen structure তৈরি করে।
      backgroundColor: Colors.grey.shade50, // পুরো screen-এর background color।

      appBar: AppBar( // Screen-এর উপরের AppBar।
        title: const Text( // AppBar-এর title।
          'MediSync',
          style: TextStyle(
            fontWeight: FontWeight.bold, // Text-কে bold করার জন্য।
          ),
        ),

        centerTitle: false, // Title-কে left side-এ রাখে।

        actions: [ // AppBar-এর ডান পাশে widget রাখার জন্য।
          IconButton( // একটি clickable icon button।
            onPressed: () {
              // পরে এখানে notification feature যোগ করব।
            },
            icon: const Icon(
              Icons.notifications_none, // Notification bell icon।
            ),
          ),
        ],
      ),

      body: SafeArea( // Status bar/notch থেকে UI safe রাখে।
        child: SingleChildScrollView( // Screen ছোট হলে scroll করার সুবিধা দেয়।
          padding: const EdgeInsets.all(20), // চারপাশে 20 pixel space দেয়।

          child: Column( // সব widget-কে উপর থেকে নিচে সাজায়।
            crossAxisAlignment: CrossAxisAlignment.start, // সব content left থেকে শুরু করে।

            children: [
              const SizedBox(height: 10), // উপরে একটু space দেয়।

              const Text( // Greeting text।
                'Hello 👋',
                style: TextStyle(
                  fontSize: 16, // Text-এর size।
                  color: Colors.grey, // Text-এর color।
                ),
              ),

              const SizedBox(height: 5), // দুইটা text-এর মাঝে space।

              const Text( // Main welcome text।
                'Welcome to MediSync',
                style: TextStyle(
                  fontSize: 26, // Text-এর size।
                  fontWeight: FontWeight.bold, // Text bold করে।
                ),
              ),

              const SizedBox(height: 8), // নিচে space দেয়।

              Text( // ছোট description text।
                'Stay on track with your medications.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
              ),

              const SizedBox(height: 30), // Section-এর মাঝে বড় space।

              Container( // আজকের medicine summary card।
                width: double.infinity, // পুরো available width নেয়।
                padding: const EdgeInsets.all(20), // Card-এর ভিতরে space দেয়।

                decoration: BoxDecoration( // Container-এর design।
                  color: Colors.teal, // Card-এর background color।
                  borderRadius: BorderRadius.circular(20), // Card-এর corner round করে।
                ),

                child: Column( // Card-এর ভিতরের content verticalভাবে সাজায়।
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text(
                      'Today\'s Schedule', // আজকের medicine section title।
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'No medicines scheduled yet', // এখনো database না থাকায় placeholder text।
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),

                    const SizedBox(height: 20),

                    ElevatedButton.icon( // Icon + Text সহ button।
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddMedicineScreen(),
                          ),
                        );
                      },

                      icon: const Icon(
                        Icons.add,
                      ),

                      label: const Text(
                        'Add Medicine',
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30), // নিচে বড় space।

              const Text( // Quick Actions section title।
                'Quick Actions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              Row( // দুইটি action card পাশাপাশি রাখে।
                children: [
                  Expanded( // Available জায়গার সমান অংশ নেয়।
                    child: _buildActionCard( // প্রথম reusable action card।
                      icon: Icons.medication_outlined,
                      title: 'My Medicines',
                      onTap: () {
                        // পরে Medicine List screen-এ যাবে।
                      },
                    ),
                  ),

                  const SizedBox(width: 15), // দুই card-এর মাঝে space।

                  Expanded( // দ্বিতীয় card-ও সমান জায়গা নেয়।
                    child: _buildActionCard(
                      icon: Icons.history,
                      title: 'History',
                      onTap: () {
                        // পরে History screen-এ যাবে।
                      },
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              Row( // দ্বিতীয় row-তে আরও দুইটি action card।
                children: [
                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.notifications_active_outlined,
                      title: 'Reminders',
                      onTap: () {
                        // পরে Reminder screen-এ যাবে।
                      },
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: _buildActionCard(
                      icon: Icons.person_outline,
                      title: 'Profile',
                      onTap: () {
                        // পরে Profile screen-এ যাবে।
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard({ // একই design-এর action card বারবার বানানোর জন্য reusable method।
    required IconData icon, // কোন icon দেখাবে।
    required String title, // Card-এর title।
    required VoidCallback onTap, // Card-এ click করলে কী হবে।
  }) {
    return InkWell( // পুরো card-কে clickable করার জন্য।
      onTap: onTap,

      borderRadius: BorderRadius.circular(18), // Click effect-ও round corner অনুযায়ী হয়।

      child: Container( // Card-এর মূল design।
        height: 130, // Card-এর fixed height।

        decoration: BoxDecoration(
          color: Colors.white, // Card-এর background।
          borderRadius: BorderRadius.circular(18), // Card-এর corner round করে।

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05), // হালকা shadow।
              blurRadius: 10, // Shadow কতটা soft হবে।
              offset: const Offset(0, 4), // Shadow নিচের দিকে দেয়।
            ),
          ],
        ),

        child: Column( // Icon এবং text vertically সাজায়।
          mainAxisAlignment: MainAxisAlignment.center, // Content vertically center করে।

          children: [
            Icon(
              icon, // Method থেকে পাওয়া icon দেখায়।
              size: 35, // Icon-এর size।
              color: Colors.teal, // Icon-এর color।
            ),

            const SizedBox(height: 12), // Icon এবং text-এর মাঝে space।

            Text(
              title, // Method থেকে পাওয়া title দেখায়।
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}