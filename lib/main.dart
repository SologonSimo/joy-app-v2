import 'package:flutter/material.dart';
import 'models.dart';
import 'services.dart';

void main() => runApp(const JoyApp());

class JoyApp extends StatelessWidget {
  const JoyApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'JOY',
    theme: ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF08080B),
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF4F9A), brightness: Brightness.dark),
      cardTheme: CardThemeData(color: const Color(0xFF131319), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24))),
    ),
    home: const JoyShell(),
  );
}

class JoyShell extends StatefulWidget {
  const JoyShell({super.key});
  @override State<JoyShell> createState() => _JoyShellState();
}

class _JoyShellState extends State<JoyShell> {
  int tab = 0;
  final repo = JoyRepository();
  late JoyUser me;

  @override
  void initState() {
    super.initState();
    me = repo.auth.register('Semyon', 'semyon');
  }

  @override
  Widget build(BuildContext context) {
    final pages = [FeedPage(posts: repo.posts), StatusPage(repo: repo), const SearchPage(), const CreatePage(), const ChatsPage(), ProfilePage(user: me)];
    return Scaffold(
      body: AnimatedSwitcher(duration: const Duration(milliseconds: 220), child: pages[tab]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tab,
        onDestinationSelected: (i) => setState(() => tab = i),
        backgroundColor: const Color(0xFF0C0C10),
        indicatorColor: const Color(0x33FF4F9A),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.play_circle_outline), selectedIcon: Icon(Icons.play_circle), label: 'JOY'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), selectedIcon: Icon(Icons.add_circle), label: 'Create'),
          NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
          NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class FeedPage extends StatefulWidget {
  final List<JoyPost> posts;
  const FeedPage({super.key, required this.posts});
  @override State<FeedPage> createState() => _FeedPageState();
}
class _FeedPageState extends State<FeedPage> {
  int index = 0;
  @override
  Widget build(BuildContext context) {
    final p = widget.posts[index % widget.posts.length];
    return GestureDetector(
      onVerticalDragEnd: (d) { if ((d.primaryVelocity ?? 0) < -200) setState(() => index++); },
      child: Stack(children: [
        Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [const Color(0xFF21142B), const Color(0xFF08080B), const Color(0xFF17111F)]))),
        Positioned.fill(child: Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 190, height: 270, decoration: BoxDecoration(borderRadius: BorderRadius.circular(34), gradient: const LinearGradient(colors: [Color(0xFF5E3C78), Color(0xFF18131F)])), child: Center(child: Text(p.mediaLabel, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 3)))),
          const SizedBox(height: 24),
          Text(p.caption, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8), Text('Swipe up for next • ${p.mood}', style: TextStyle(color: Colors.white.withOpacity(.6))),
        ]))),
        Positioned(top: 54, left: 22, right: 22, child: Row(children: [const Text('JOY', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 2)), const Spacer(), IconButton(onPressed: () {}, icon: const Icon(Icons.notifications_none))])),
        Positioned(right: 18, bottom: 120, child: Column(children: [Action(icon: Icons.favorite_border, label: '${p.likes ~/ 1000}K'), Action(icon: Icons.chat_bubble_outline, label: '${p.comments}'), Action(icon: Icons.repeat, label: '${p.shares}'), Action(icon: Icons.bookmark_border, label: 'Save'), const SizedBox(height: 12), CircleAvatar(radius: 24, backgroundColor: const Color(0xFF2B2430), child: Text(p.author[0]))])),
        Positioned(left: 22, bottom: 40, child: Row(children: [CircleAvatar(backgroundColor: const Color(0xFF2B2430), child: Text(p.author[0])), const SizedBox(width: 10), Text('@${p.author.toLowerCase()}', style: const TextStyle(fontWeight: FontWeight.w700))])),
      ]),
    );
  }
}
class Action extends StatelessWidget { final IconData icon; final String label; const Action({super.key, required this.icon, required this.label}); @override Widget build(BuildContext c)=>Padding(padding: const EdgeInsets.only(bottom: 18), child: Column(children:[CircleAvatar(backgroundColor: const Color(0x66131319), radius: 25, child: Icon(icon)), const SizedBox(height:4), Text(label, style: const TextStyle(fontSize:11))])); }


class StatusPage extends StatelessWidget {
  final JoyRepository repo;
  const StatusPage({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final active = repo.statuses.where((s) => !s.isExpired).toList();
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 30),
        children: [
          Row(children: [
            const Expanded(child: Text('Статусы', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900))),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_horiz)),
          ]),
          const SizedBox(height: 6),
          Text('Контакты, которые зарегистрированы в JOY', style: TextStyle(color: Colors.white.withOpacity(.55))),
          const SizedBox(height: 20),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.add)),
              title: const Text('Мой статус', style: TextStyle(fontWeight: FontWeight.w700)),
              subtitle: const Text('Добавить фото, видео или текст • 24 часа'),
              onTap: () {},
            ),
          ),
          const SizedBox(height: 22),
          const Text('Контакты в JOY', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          ...active.map((status) => _StatusTile(status: status)),
          const SizedBox(height: 18),
          TextButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.contacts_outlined),
            label: const Text('Синхронизировать контакты'),
          ),
          const SizedBox(height: 8),
          Text(
            'JOY показывает только те контакты, которые нашли соответствующий аккаунт JOY. Номера телефонов другим пользователям не показываются.',
            style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(.42)),
          ),
        ],
      ),
    );
  }
}

class _StatusTile extends StatelessWidget {
  final JoyStatus status;
  const _StatusTile({required this.status});
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: const EdgeInsets.symmetric(vertical: 5),
    leading: Stack(children: [
      CircleAvatar(radius: 27, backgroundColor: const Color(0xFF2B2430), child: Text(status.author[0])),
      if (!status.viewed) Positioned.fill(child: Container(decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 3, color: const Color(0xFFFF4F9A)))))
    ]),
    title: Text(status.author, style: const TextStyle(fontWeight: FontWeight.w700)),
    subtitle: Text('${status.video ? 'Видео' : 'Текст'} • ${_age(status.createdAt)}'),
    trailing: const Icon(Icons.chevron_right),
    onTap: () {},
  );

  String _age(DateTime time) {
    final minutes = DateTime.now().difference(time).inMinutes;
    if (minutes < 60) return '${minutes.clamp(1, 59)} мин назад';
    return '${(minutes / 60).floor()} ч назад';
  }
}

class SearchPage extends StatelessWidget { const SearchPage({super.key}); @override Widget build(BuildContext c)=>SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[const Text('Search', style: TextStyle(fontSize:32,fontWeight:FontWeight.w900)), const SizedBox(height:18), TextField(decoration: InputDecoration(hintText:'People, videos, moods', prefixIcon: const Icon(Icons.search), filled:true, fillColor: const Color(0xFF141419), border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none))), const SizedBox(height:28), const Text('Explore', style: TextStyle(fontSize:20,fontWeight:FontWeight.w700)), const SizedBox(height:12), Wrap(spacing:10, runSpacing:10, children:['Trending','Music','Comedy','Travel','Mood','Creators'].map((x)=>Chip(label:Text(x))).toList())]))); }

class CreatePage extends StatelessWidget { const CreatePage({super.key}); @override Widget build(BuildContext c)=>SafeArea(child: Center(child: Column(mainAxisAlignment:MainAxisAlignment.center, children:[const Icon(Icons.auto_awesome, size:64), const SizedBox(height:20), const Text('Create on JOY', style: TextStyle(fontSize:28,fontWeight:FontWeight.w900)), const SizedBox(height:10), Text('Video • Story • Live • Mood', style: TextStyle(color:Colors.white.withOpacity(.6))), const SizedBox(height:28), FilledButton.icon(onPressed:(){}, icon:const Icon(Icons.videocam), label:const Text('Create video'))]))); }

class ChatsPage extends StatelessWidget { const ChatsPage({super.key}); @override Widget build(BuildContext c)=>SafeArea(child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment:CrossAxisAlignment.start, children:[const Text('Chats', style: TextStyle(fontSize:32,fontWeight:FontWeight.w900)), const SizedBox(height:20), ...['Mia','Artem','Nika'].map((x)=>ListTile(contentPadding:EdgeInsets.zero, leading:CircleAvatar(child:Text(x[0])), title:Text(x), subtitle:const Text('Tap to open conversation'), trailing:const Icon(Icons.chevron_right))) ]))); }

class ProfilePage extends StatelessWidget { final JoyUser user; const ProfilePage({super.key, required this.user}); @override Widget build(BuildContext c)=>SafeArea(child: ListView(padding: const EdgeInsets.all(20), children:[Row(children:[const CircleAvatar(radius:42, child:Icon(Icons.person)), const SizedBox(width:16), Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start, children:[Row(children:[Text(user.name,style:const TextStyle(fontSize:24,fontWeight:FontWeight.w900)), const SizedBox(width:8), if(user.verified) const Icon(Icons.verified,size:20)]), Text('@${user.handle}',style:TextStyle(color:Colors.white.withOpacity(.55))), const SizedBox(height:8), Text(user.role.name.toUpperCase(),style:const TextStyle(fontSize:11,letterSpacing:1.5))]))]), const SizedBox(height:24), Row(mainAxisAlignment:MainAxisAlignment.spaceAround, children:[Stat('${user.followers}','Followers'),const Stat('248','Following'),const Stat('18.4K','Likes')]), const SizedBox(height:28), Card(child:Padding(padding:const EdgeInsets.all(18),child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[const Text('JOY+ & Coins',style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)),const SizedBox(height:14),Row(children:[Icon(user.joyPlus?Icons.workspace_premium:Icons.workspace_premium_outlined),const SizedBox(width:10),Text(user.joyPlus?'JOY+ active':'JOY+ inactive'),const Spacer(),Text(user.unlimitedCoins?'∞ Coins':'${user.coins} Coins',style:const TextStyle(fontWeight:FontWeight.w800))])])), const SizedBox(height:16), Card(child:Column(children:[ListTile(leading:const Icon(Icons.insights),title:const Text('Creator Analytics'),subtitle:const Text('Views, retention, followers'),onTap:(){}),ListTile(leading:const Icon(Icons.emoji_events_outlined),title:const Text('Achievements'),onTap:(){}),ListTile(leading:const Icon(Icons.settings_outlined),title:const Text('Settings'),onTap:(){})]))])); }
class Stat extends StatelessWidget { final String value,label; const Stat(this.value,this.label,{super.key}); @override Widget build(BuildContext c)=>Column(children:[Text(value,style:const TextStyle(fontSize:18,fontWeight:FontWeight.w800)),Text(label,style:TextStyle(color:Colors.white.withOpacity(.5),fontSize:12))]); }
