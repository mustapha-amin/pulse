# Pulse 💸

Pulse is a modern, responsive personal expense tracking application built with Flutter.

---

## How to Run

### Prerequisites
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (`^3.13.2` or later)
- Dart SDK (`^3.13.2`)
- An active emulator, simulator, or connected physical device

### Steps
1. **Clone the repository**:
   ```bash
   git clone <repo-url>
   cd pulse
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Run the application**:
   ```bash
   flutter run
   ```

---

## State Management Choice: Riverpod

### Why Flutter Riverpod?
- **Robust Async State Handling (`AsyncValue`)**: Built-in support for `data`, `loading`, and `error` states simplifies network data lifecycles (initial load, skeleton shimmer, pull-to-refresh, and error retries).
- **Compile-Time Safety & Decoupling**: Providers are declared outside the widget tree, eliminating `BuildContext` lookup bugs and making business logic easily testable and maintainable.
- **Modern Architecture**: Leverages Riverpod's `AsyncNotifier` and `Notifier` patterns for clean unidirectional data flow with minimal boilerplate.

---

## Trade-offs & Future Improvements

Here are the key trade-offs in the current implementation and what would be tackled with more time:

### 1. In-Memory State & Lack of Offline Persistence
- **Current Trade-off**: Expenses and theme preferences are held in-memory and fetched directly from the REST API. Launching the app offline results in an error state rather than serving cached data.
- **With More Time**: Implement an offline-first cache (using Drift/SQLite, Hive, or Isar) paired with a synchronization worker to queue offline transactions and sync when connectivity returns.

### 2. Full-List Fetching vs. Pagination / Query Filtering
- **Current Trade-off**: All expenses are retrieved in a single batch, with month-based calculations (like the Monthly Summary Card) computed entirely in-memory. For large histories, this increases payload size and memory overhead.
- **With More Time**: Implement server-side date-range querying, category filtering, and paginated infinite scrolling.

### 3. Asynchronous Mutations vs. Optimistic UI Updates
- **Current Trade-off**: Adding, updating, or deleting an expense waits for the network response before updating the UI state.
- **With More Time**: Implement optimistic UI updates with automatic rollback on network failure to deliver instant, zero-latency interactions.

## Screenshots

<img width="1600" height="900" alt="Pulse" src="https://github.com/user-attachments/assets/d0358633-34c0-4618-99db-c9f18996b2bd" />
