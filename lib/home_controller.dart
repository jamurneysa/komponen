import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<String> data = <String>[].obs;
  final RxBool isLoading = false.obs;
  final ScrollController scrollController = ScrollController();
  final RxInt selectedIndex = 0.obs;
  final Map<int, FocusNode> focusNodes = {};

  @override
  void onInit() {
    super.onInit();
    loadMoreData();
    scrollController.addListener(onScroll);
  }

  @override
  void onClose() {
    scrollController.dispose();
    for (var focusNode in focusNodes.values) {
      focusNode.dispose();
    }
    super.onClose();
  }

  void onScroll() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoading.value) {
      loadMoreData();
    }
  }

  void loadMoreData() {
    if (isLoading.value) return;
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      final startIndex = data.length;
      data.addAll(List.generate(20, (index) => "data ${startIndex + index}"));
      isLoading.value = false;
    });
  }

  void changeSelected(int index) {
    selectedIndex.value = index;
  }

  void changeFocus(int index) {
    if (!focusNodes.containsKey(index)) {
      focusNodes[index] = createFocusNode(index);
    }
    focusNodes[index]!.requestFocus();
  }

  FocusNode createFocusNode(int index) {
    return FocusNode(
      onKeyEvent: (node, event) {
        if (event.runtimeType == KeyUpEvent &&
            (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                event.logicalKey == LogicalKeyboardKey.arrowDown ||
                event.logicalKey == LogicalKeyboardKey.tab)) {
          changeSelected(index);
        }
        return KeyEventResult.ignored;
      },
    );
  }
}
