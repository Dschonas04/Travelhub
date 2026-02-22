import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../widgets/user_avatar.dart';

/// Fotos teilen – vollständige Galerie mit Alben, Upload-Simulation, Likes & Kommentaren
class PhotoSharingScreen extends StatefulWidget {
  final String tripId;
  const PhotoSharingScreen({super.key, required this.tripId});

  @override
  State<PhotoSharingScreen> createState() => _PhotoSharingScreenState();
}

class _PhotoSharingScreenState extends State<PhotoSharingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  final List<_Photo> _photos = [
    _Photo(title: 'Sonnenuntergang am Strand', uploadedBy: 'Max', emoji: '🌅', color: Color(0xFFFF7043), likes: 5, comments: ['Traumhaft!', 'Wow 😍']),
    _Photo(title: 'Altstadt-Gassen', uploadedBy: 'Sophie', emoji: '🏘️', color: Color(0xFF8D6E63), likes: 3, comments: ['So schön!']),
    _Photo(title: 'Hafen bei Nacht', uploadedBy: 'Lars', emoji: '🌃', color: Color(0xFF5C6BC0), likes: 7, comments: ['Magisch!', 'Wahnsinn', 'Hammer Shot']),
    _Photo(title: 'Strand Panorama', uploadedBy: 'Anna', emoji: '🏖️', color: Color(0xFF26A69A), likes: 4, comments: []),
    _Photo(title: 'Lokales Essen', uploadedBy: 'Tim', emoji: '🍽️', color: Color(0xFFEF5350), likes: 6, comments: ['Lecker!', 'Wo war das?']),
    _Photo(title: 'Bergwanderung', uploadedBy: 'Max', emoji: '🏔️', color: Color(0xFF66BB6A), likes: 2, comments: ['Tolle Aussicht']),
    _Photo(title: 'Marktplatz', uploadedBy: 'Sophie', emoji: '🛍️', color: Color(0xFFAB47BC), likes: 1, comments: []),
    _Photo(title: 'Cocktails am Pool', uploadedBy: 'Lars', emoji: '🍹', color: Color(0xFFEC407A), likes: 8, comments: ['Cheers! 🥂', 'Prost!']),
    _Photo(title: 'Kathedrale', uploadedBy: 'Anna', emoji: '⛪', color: Color(0xFF78909C), likes: 3, comments: ['Beeindruckend!']),
    _Photo(title: 'Gruppenphoto', uploadedBy: 'Tim', emoji: '👥', color: Color(0xFF4A90D9), likes: 12, comments: ['Beste Crew!', 'Erinnerungen!', '❤️']),
    _Photo(title: 'Sonnenaufgang', uploadedBy: 'Max', emoji: '🌄', color: Color(0xFFFFA726), likes: 9, comments: ['4:30 Uhr hat sich gelohnt!']),
    _Photo(title: 'Schnorcheln', uploadedBy: 'Sophie', emoji: '🤿', color: Color(0xFF29B6F6), likes: 5, comments: ['Unterwasserwelt!']),
  ];

  final List<_Album> _albums = [
    _Album(name: 'Tag 1 - Anreise', emoji: '✈️', color: Color(0xFF4A90D9), count: 4),
    _Album(name: 'Strandtage', emoji: '🏖️', color: Color(0xFF26A69A), count: 6),
    _Album(name: 'Altstadt Tour', emoji: '🏛️', color: Color(0xFF8D6E63), count: 3),
    _Album(name: 'Abendessen', emoji: '🍽️', color: Color(0xFFEF5350), count: 5),
    _Album(name: 'Highlights', emoji: '⭐', color: Color(0xFFFFA726), count: 8),
  ];

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fotos teilen', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFFEC407A), Color(0xFFF48FB1)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.add_a_photo, color: Colors.white), onPressed: _showUploadSheet),
        ],
        bottom: TabBar(
          controller: _tabCtrl,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white60,
          indicatorColor: Colors.white,
          indicatorWeight: 3,
          tabs: const [Tab(text: 'Galerie'), Tab(text: 'Alben'), Tab(text: 'Aktivität')],
        ),
      ),
      body: TabBarView(controller: _tabCtrl, children: [_galleryTab(), _albumsTab(), _activityTab()]),
      floatingActionButton: FloatingActionButton(
        onPressed: _showUploadSheet,
        backgroundColor: const Color(0xFFEC407A),
        child: const Icon(Icons.camera_alt, color: Colors.white),
      ),
    );
  }

  Widget _galleryTab() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: AppColors.cardBackground,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statItem('${_photos.length}', 'Fotos'),
              _statItem('${_photos.fold<int>(0, (s, p) => s + p.likes)}', 'Likes'),
              _statItem('${_photos.map((p) => p.uploadedBy).toSet().length}', 'Fotografen'),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(4),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: _photos.length,
            itemBuilder: (ctx, i) => _photoTile(_photos[i]),
          ),
        ),
      ],
    );
  }

  Widget _photoTile(_Photo photo) {
    return GestureDetector(
      onTap: () => _showPhotoDetail(photo),
      child: Container(
        decoration: BoxDecoration(color: photo.color.withOpacity(0.15), borderRadius: BorderRadius.circular(4)),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(photo.emoji, style: const TextStyle(fontSize: 36)),
                  const SizedBox(height: 2),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Text(photo.title, style: const TextStyle(fontSize: 8, fontWeight: FontWeight.w500), textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            ),
            if (photo.likes > 0)
              Positioned(
                top: 4, right: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                  child: Row(mainAxisSize: MainAxisSize.min, children: [
                    const Icon(Icons.favorite, size: 10, color: Colors.red),
                    const SizedBox(width: 2),
                    Text('${photo.likes}', style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold)),
                  ]),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _albumsTab() {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: _albums.length + 1,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (ctx, i) {
        if (i == _albums.length) {
          return InkWell(
            onTap: _showCreateAlbum,
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: AppColors.cardBackground, borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.shade300)),
              child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Icon(Icons.add_circle_outline, color: Colors.grey.shade500),
                const SizedBox(width: 8),
                Text('Neues Album erstellen', style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
              ]),
            ),
          );
        }
        final album = _albums[i];
        return Material(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(14),
          child: InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Album "${album.name}" geöffnet'), duration: const Duration(seconds: 1))),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), border: Border.all(color: Colors.grey.withOpacity(0.08))),
              child: Row(children: [
                Container(
                  width: 56, height: 56,
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [album.color, album.color.withOpacity(0.6)]), borderRadius: BorderRadius.circular(12)),
                  child: Center(child: Text(album.emoji, style: const TextStyle(fontSize: 28))),
                ),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(album.name, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
                  Text('${album.count} Fotos', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
                ])),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _activityTab() {
    final activities = <_ActivityEntry>[];
    for (final photo in _photos) {
      activities.add(_ActivityEntry(user: photo.uploadedBy, action: 'hat "${photo.title}" hochgeladen', emoji: photo.emoji, timeAgo: '${Random(photo.title.hashCode).nextInt(23) + 1}h'));
      if (photo.likes > 0) activities.add(_ActivityEntry(user: _randomUser(photo.uploadedBy), action: 'gefällt "${photo.title}"', emoji: '❤️', timeAgo: '${Random(photo.likes).nextInt(12) + 1}h'));
      for (final c in photo.comments) {
        activities.add(_ActivityEntry(user: _randomUser(photo.uploadedBy), action: 'kommentierte: "$c"', emoji: '💬', timeAgo: '${Random(c.hashCode).nextInt(8) + 1}h'));
      }
    }
    activities.shuffle(Random(42));
    final shown = activities.take(20).toList();

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: shown.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (ctx, i) {
        final a = shown[i];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(children: [
            UserAvatar(name: a.user, size: 36),
            const SizedBox(width: 12),
            Expanded(child: RichText(text: TextSpan(style: const TextStyle(color: AppColors.text, fontSize: 13), children: [
              TextSpan(text: a.user, style: const TextStyle(fontWeight: FontWeight.bold)),
              TextSpan(text: ' ${a.action}'),
            ]))),
            const SizedBox(width: 8),
            Text(a.emoji, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 6),
            Text(a.timeAgo, style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
          ]),
        );
      },
    );
  }

  void _showPhotoDetail(_Photo photo) {
    showModalBottomSheet(
      context: context, isScrollControlled: true, backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => DraggableScrollableSheet(
          initialChildSize: 0.8, maxChildSize: 0.95, expand: false,
          builder: (ctx, scroll) => Container(
            decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
            child: SingleChildScrollView(
              controller: scroll,
              child: Column(children: [
                Padding(padding: const EdgeInsets.only(top: 12), child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2)))),
                Container(
                  width: double.infinity, height: 280, margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(gradient: LinearGradient(colors: [photo.color, photo.color.withOpacity(0.3)]), borderRadius: BorderRadius.circular(16)),
                  child: Center(child: Text(photo.emoji, style: const TextStyle(fontSize: 80))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(children: [
                    IconButton(
                      icon: Icon(photo.isLikedByMe ? Icons.favorite : Icons.favorite_border, color: photo.isLikedByMe ? Colors.red : Colors.grey),
                      onPressed: () => setSheet(() { photo.isLikedByMe = !photo.isLikedByMe; photo.likes += photo.isLikedByMe ? 1 : -1; }),
                    ),
                    Text('${photo.likes}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(width: 16),
                    const Icon(Icons.chat_bubble_outline, color: Colors.grey), const SizedBox(width: 4),
                    Text('${photo.comments.length}', style: const TextStyle(fontWeight: FontWeight.w600)),
                    const Spacer(),
                    IconButton(
                      icon: Icon(photo.isSaved ? Icons.bookmark : Icons.bookmark_border, color: photo.isSaved ? const Color(0xFFFFA726) : Colors.grey),
                      onPressed: () => setSheet(() => photo.isSaved = !photo.isSaved),
                    ),
                  ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(photo.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Row(children: [UserAvatar(name: photo.uploadedBy, size: 20), const SizedBox(width: 6), Text('von ${photo.uploadedBy}', style: TextStyle(fontSize: 13, color: Colors.grey.shade600))]),
                    const SizedBox(height: 16),
                    const Text('Kommentare', style: TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 8),
                    if (photo.comments.isEmpty) Text('Noch keine Kommentare', style: TextStyle(color: Colors.grey.shade500, fontStyle: FontStyle.italic)),
                    ...photo.comments.map((c) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        UserAvatar(name: _randomUser(photo.uploadedBy), size: 24),
                        const SizedBox(width: 8),
                        Expanded(child: Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)), child: Text(c, style: const TextStyle(fontSize: 13)))),
                      ]),
                    )),
                    const SizedBox(height: 12),
                    Row(children: [
                      Expanded(child: TextField(
                        decoration: InputDecoration(hintText: 'Kommentar schreiben...', contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none), filled: true, fillColor: Colors.grey.shade100),
                        onSubmitted: (text) { if (text.isNotEmpty) { setSheet(() => photo.comments.add(text)); setState(() {}); } },
                      )),
                      const SizedBox(width: 8),
                      Container(width: 36, height: 36, decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFEC407A)), child: const Icon(Icons.send, size: 16, color: Colors.white)),
                    ]),
                    const SizedBox(height: 24),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void _showUploadSheet() {
    final titleCtrl = TextEditingController();
    String selectedEmoji = '📸';
    final emojis = ['📸', '🌅', '🏖️', '🍽️', '🏔️', '🌃', '🎉', '🗺️', '🚗', '🌊', '🏛️', '🎭'];
    showModalBottomSheet(
      context: context, isScrollControlled: true,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheet) => Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(ctx).viewInsets.bottom + 20),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            const Text('Foto hochladen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(width: double.infinity, height: 140, decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(14)),
              child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
                Text(selectedEmoji, style: const TextStyle(fontSize: 52)),
                Text('Emoji als Platzhalter', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
              ]))),
            const SizedBox(height: 12),
            SizedBox(height: 44, child: ListView.separated(
              scrollDirection: Axis.horizontal, itemCount: emojis.length, separatorBuilder: (_, __) => const SizedBox(width: 6),
              itemBuilder: (_, i) => GestureDetector(
                onTap: () => setSheet(() => selectedEmoji = emojis[i]),
                child: Container(width: 44, height: 44, decoration: BoxDecoration(
                  color: selectedEmoji == emojis[i] ? const Color(0xFFEC407A).withOpacity(0.15) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: selectedEmoji == emojis[i] ? Border.all(color: const Color(0xFFEC407A), width: 2) : null,
                ), child: Center(child: Text(emojis[i], style: const TextStyle(fontSize: 22)))),
              ),
            )),
            const SizedBox(height: 12),
            TextField(controller: titleCtrl, decoration: const InputDecoration(labelText: 'Titel / Beschreibung')),
            const SizedBox(height: 16),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(
              onPressed: () {
                if (titleCtrl.text.isNotEmpty) {
                  setState(() => _photos.insert(0, _Photo(title: titleCtrl.text, uploadedBy: 'Du', emoji: selectedEmoji, color: Color((Random().nextDouble() * 0xFFFFFF).toInt()).withOpacity(1.0))));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📸 Foto hochgeladen!'), backgroundColor: Color(0xFFEC407A)));
                }
              },
              icon: const Icon(Icons.cloud_upload), label: const Text('Hochladen'),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFEC407A)),
            )),
          ]),
        ),
      ),
    );
  }

  void _showCreateAlbum() {
    final nameCtrl = TextEditingController();
    showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Neues Album'),
      content: TextField(controller: nameCtrl, decoration: const InputDecoration(hintText: 'Albumname'), autofocus: true),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Abbrechen')),
        TextButton(onPressed: () { if (nameCtrl.text.isNotEmpty) { setState(() => _albums.add(_Album(name: nameCtrl.text, emoji: '📁', color: const Color(0xFF78909C), count: 0))); Navigator.pop(ctx); } }, child: const Text('Erstellen')),
      ],
    ));
  }

  Widget _statItem(String value, String label) => Column(children: [
    Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFEC407A))),
    Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
  ]);

  String _randomUser(String except) {
    const users = ['Max', 'Sophie', 'Lars', 'Anna', 'Tim'];
    final filtered = users.where((u) => u != except).toList();
    return filtered[except.hashCode.abs() % filtered.length];
  }
}

class _Photo {
  final String title, uploadedBy, emoji;
  final Color color;
  int likes;
  bool isLikedByMe, isSaved;
  List<String> comments;
  _Photo({required this.title, required this.uploadedBy, required this.emoji, required this.color, this.likes = 0, this.isLikedByMe = false, this.isSaved = false, List<String>? comments}) : comments = comments ?? [];
}

class _Album {
  final String name, emoji;
  final Color color;
  int count;
  _Album({required this.name, required this.emoji, required this.color, required this.count});
}

class _ActivityEntry {
  final String user, action, emoji, timeAgo;
  _ActivityEntry({required this.user, required this.action, required this.emoji, required this.timeAgo});
}
