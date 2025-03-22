import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listin/Column.dart';
import 'home_controller.dart';
class LListView extends StatefulWidget {
  const LListView({super.key});

  @override
  State<LListView> createState() => _LListViewState();
}

class _LListViewState extends State<LListView> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MyHomePage<T> extends StatelessWidget {
  final dynamic tabelKey;
  final String tabel;
  final String where;
  final int dataCount;
  final String initialSort;
  final bool ascending;
  final List<String>? kolomDiCari;
  final List<ColumnsModel> column;
  final Function(T? data)? onSelected;
  final bool fullWidth;

  final HomeController controller = Get.put(HomeController());
  

  MyHomePage({super.key, this.tabelKey, });


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("title"),
      ),
      body: Obx(
        () => ListView.builder(
          controller: controller.scrollController,
          itemCount:
              controller.data.length + (controller.isLoading.value ? 1 : 0),
          itemBuilder: (context, i) {
            if (i == controller.data.length) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!controller.focusNodes.containsKey(i)) {
              controller.focusNodes[i] = controller.createFocusNode(i);
            }
            return ListTile(
              focusNode: controller.focusNodes[i],
              title: Text(controller.data[i]),
              selected: i == controller.selectedIndex.value,
              onTap: () {
                controller.changeSelected(i);
                controller.changeFocus(i);
              },
            );
          },
        ),
      ),
    );
  }
}
