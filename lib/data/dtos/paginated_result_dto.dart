class PaginatedResultDTO<T> {
  final int from;
  final int to;
  final int total;
  final int count;
  final int perPage;
  final int currentPage;
  final int lastPage;
  final List<T> items;

  const PaginatedResultDTO({
    this.from = 0,
    this.to = 0,
    this.total = 0,
    this.count = 0,
    this.perPage = 0,
    this.currentPage = 0,
    this.lastPage = 0,
    this.items = const [],
  });

  update({required PaginatedResultDTO<T> result}) => PaginatedResultDTO<T>(
        from: result.from,
        to: result.to,
        total: result.total,
        count: result.count,
        perPage: result.perPage,
        currentPage: result.currentPage,
        lastPage: result.lastPage,
        items: [...items, ...result.items],
      );

  add({required T item}) => PaginatedResultDTO<T>(
        from: from,
        to: to,
        total: total,
        count: count,
        perPage: perPage,
        currentPage: currentPage,
        lastPage: lastPage,
        items: [item, ...items],
      );
  addFirst({required T item}) => PaginatedResultDTO<T>(
    from: from,
    to: to,
    total: total,
    count: count,
    perPage: perPage,
    currentPage: currentPage,
    lastPage: lastPage,
    items: [ ...items,item],
  );

  String toooo() {
    return "$from $to $total $count $perPage $currentPage $lastPage";
  }
}
