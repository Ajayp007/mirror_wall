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
    context.read<HomeProvider>().getBookMark();
    pullToRefreshController = PullToRefreshController(
      onRefresh: () {
        inAppWebViewController!.reload();
        pullToRefreshController!.endRefreshing();
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
                  onTap: () {
                    showBookMark();
                  },
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
                        url: WebUri.uri(
                            Uri.parse("https://www.${providerW!.search}.com"))),
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
                                  "https://www.${providerW!.search}.com/search?q=${txtUrl!.text}")),
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
                              url: WebUri(
                                  "https://www.${providerW!.search}.com"),
                            ),
                          );
                        },
                        icon: const Icon(Icons.home),
                      ),
                      IconButton(
                        onPressed: () async {
                          var link = await inAppWebViewController!.getOriginalUrl();
                          providerR!.setLink1(link.toString());
                        },
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
                value: "google",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  inAppWebViewController!.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://www.google.co.in/"),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Yahoo"),
                value: "yahoo",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  inAppWebViewController!.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://www.yahoo.com/"),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Bing"),
                value: "bing",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  inAppWebViewController!.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://www.bing.com/?PC=U673"),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
              RadioListTile(
                title: const Text("Duck Duck Go"),
                value: "duck duck go",
                groupValue: providerW!.search,
                onChanged: (value) {
                  providerR!.changeEngine(value);
                  inAppWebViewController!.loadUrl(
                    urlRequest: URLRequest(
                      url: WebUri.uri(
                        Uri.parse("https://duckduckgo.com/"),
                      ),
                    ),
                  );
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void showBookMark() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          onClosing: () {},
          builder: (context) {
            return ListView.builder(
              itemCount: providerW!.book.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: IconButton(onPressed: () {
                    providerW!.deleteLink(index);
                     Navigator.pop(context);
                  }, icon: const Icon(Icons.delete)),
                  onTap: () {
                    inAppWebViewController!.loadUrl(
                      urlRequest: URLRequest(
                        url: WebUri(providerW!.book[index]),
                      ),
                    );
                    Navigator.pop(context);
                  },
                  title: Text(
                    providerW!.book[index],
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
