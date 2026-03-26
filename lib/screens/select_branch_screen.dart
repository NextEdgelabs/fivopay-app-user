import 'package:flutter/material.dart';
import 'package:janseva/modules/fd_rd/model/branch_model.dart';
import 'package:janseva/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SelectUserBranch extends StatefulWidget {
  const SelectUserBranch({super.key});

  @override
  State<SelectUserBranch> createState() => _SelectUserBranchState();
}

class _SelectUserBranchState extends State<SelectUserBranch> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchOrganizationBranches(
        page: 1,
        limit: 10,
        refresh: true,
      );
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final provider = context.read<UserProvider>();
    if (!provider.hasMoreBranches || provider.isBranchLoadingMore) return;

    final thresholdReached =
        _scrollController.position.pixels >=
        (_scrollController.position.maxScrollExtent - 180);

    if (thresholdReached) {
      provider.fetchMoreOrganizationBranches();
    }
  }

  String _address(BranchModel branch) {
    final parts = [
      branch.addressLine1,
      branch.addressLine2,
      branch.city,
      branch.state,
      branch.postalCode,
    ].where((e) => e != null && e.trim().isNotEmpty).map((e) => e!.trim());

    return parts.isEmpty ? 'Address not available' : parts.join(', ');
  }

  bool _matchesSearch(BranchModel branch) {
    final query = _searchQuery.trim().toLowerCase();
    if (query.isEmpty) return true;

    final searchableText = [
      branch.branchName,
      branch.branchCode,
      branch.postalCode,
      branch.addressLine1,
      branch.addressLine2,
      branch.city,
      branch.state,
      branch.landmark,
    ].whereType<String>().map((e) => e.toLowerCase()).join(' ');

    return searchableText.contains(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Branch')),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          final branches = userProvider.organizationBranches;
          final filteredBranches = branches.where(_matchesSearch).toList();

          if (userProvider.isLoading && branches.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (userProvider.error != null && branches.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      userProvider.error!,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        userProvider.refreshOrganizationBranches();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          if (branches.isEmpty) {
            return const Center(child: Text('No branches found'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() => _searchQuery = value);
                  },
                  decoration: InputDecoration(
                    hintText: 'Search by branch name, code, pincode or address',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: filteredBranches.isEmpty
                    ? Center(
                        child: Text(
                          'No branches match "${_searchQuery.trim()}"',
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: userProvider.refreshOrganizationBranches,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.all(12),
                          itemCount:
                              filteredBranches.length +
                              (userProvider.isBranchLoadingMore ? 1 : 0),
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 10),
                          itemBuilder: (context, index) {
                            if (index >= filteredBranches.length) {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final branch = filteredBranches[index];
                            final isSelected =
                                userProvider.selectedBranch?.id == branch.id;

                            return Material(
                              color: Colors.white,
                              elevation: isSelected ? 3 : 1,
                              borderRadius: BorderRadius.circular(12),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(12),
                                onTap: () {
                                  userProvider.selectBranch(branch);
                                  Navigator.of(context).pop(branch);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? Colors.blue
                                          : Colors.black12,
                                      width: isSelected ? 1.4 : 1,
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              branch.branchName ??
                                                  'Unnamed Branch',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 16,
                                              ),
                                            ),
                                          ),
                                          if (isSelected)
                                            const Icon(
                                              Icons.check_circle,
                                              color: Colors.blue,
                                              size: 20,
                                            ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        'Code: ${branch.branchCode ?? '-'}',
                                        style: const TextStyle(
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _address(branch),
                                        style: const TextStyle(
                                          color: Colors.black54,
                                        ),
                                      ),
                                      if (branch.phone != null &&
                                          branch.phone!.isNotEmpty)
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 6,
                                          ),
                                          child: Text(
                                            'Phone: ${branch.phone}',
                                            style: const TextStyle(
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
