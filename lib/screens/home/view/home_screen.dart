import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mirror_wall/screens/connectivity/no_internet.dart';
import 'package:mirror_wall/screens/home/provider/home_provider.dart';
import 'package:mirror_wall/screens/home/provider/web_provider.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  HomeProvider? providerR;
  HomeProvider? providerW;
  WebProvider? providerRW;
  WebProvider? providerWW;
  InAppWebViewController? inAppWebViewController;
  TextEditingController? txtUrl = TextEditingController();
  PullToRefreshController? pullToRefreshController;

  @override
  void initState() {
    super.initState();
    context.read<WebProvider>().checkInternet();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        inAppWebViewController!.reload();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    providerR = context.read<HomeProvider>();
    providerW = context.watch<HomeProvider>();

    providerRW = context.read<WebProvider>();
    providerWW = context.watch<WebProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Browser"),
        centerTitle: true,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  onTap: () {},
                  child: const Row(
                    children: [
                      Icon(Icons.bookmark),
                      Text("All Bookmarks"),
                    ],
                  ),
                ),
                PopupMenuItem(
                  onTap: () {
                    alert(context);
                  },
                  child: const Row(
                    children: [
                      Icon(Icons.screen_search_desktop_outlined),
                      Text("Search Engine"),
                    ],
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      body: providerWW!.isInternet
          ? Column(
              children: [
                Visibility(
                  visible: providerR!.indicator < 1 ? true : false,
                  child: LinearProgressIndicator(value: providerR!.indicator),
                ),
                Expanded(
                  child: InAppWebView(
                    pullToRefreshController: pullToRefreshController,
                    onWebViewCreated: (controller) {
                      inAppWebViewController = controller;
                    },
                    onProgressChanged: (controller, progress) {
                      providerW!.changeUrl(progress / 100);
                    },
                    initialUrlRequest: URLRequest(
                      url: WebUri(
                        Uri.parse("https://www.google.com/").toString(),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.95,
                  color: Colors.white,
                  child: TextFormField(
                    controller: txtUrl,
                    decoration: InputDecoration(
                      hintText: "Search Here ",
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        onPressed: () {
                          inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri.uri(Uri.parse(
                                  "https://www.google.com/search?q=${txtUrl!.text}")),
                            ),
                          );
                        },
                        icon: const Icon(Icons.search_rounded),
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          inAppWebViewController!.loadUrl(
                            urlRequest: URLRequest(
                              url: WebUri("https://www.google.com/search?q="),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () async {},
                        icon: const Icon(Icons.bookmark_add_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          inAppWebViewController!.goBack();
                        },
                        icon: const Icon(Icons.arrow_back_ios_new_outlined),
                      ),
                      IconButton(
                        onPressed: () {
                          inAppWebViewController!.reload();
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      IconButton(
                        onPressed: () {
                          inAppWebViewController!.goForward();
                        },
                        icon: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const NoInternetScreen(),
    );
  }

  void alert(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Column(
            children: [
              RadioListTile(
                title: const Text("Google"),
                value: "Google",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Yahoo"),
                value: "Yahoo",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Bing"),
                value: "Bing",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Duck Duck Go"),
                value: "Duck Duck Go",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
