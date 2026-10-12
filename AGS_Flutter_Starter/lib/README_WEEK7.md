# Week 7: Sprint 2 Deliverables

**Mission:** Complete the order form and dynamic cart for your app (KantinKu or your own variation).

## Required Tasks:
1. Create `AddOrderScreen` with a `Form` and `GlobalKey<FormState>`.
2. Add at least two `TextFormField`s (e.g., item name and quantity).
3. Implement `validator` callbacks to prevent empty submissions.
4. On submit, use `Navigator.pop(context, data)` to return the valid data.
5. In your main menu screen, use `setState` to receive the data and add it to your list.
6. Display the list using `ListView.builder`.

## Grade 10B Notice
Since you missed Week 6, both the navigation setup (Week 6) and the form state (Week 7) are due together in this sprint submission.

## Files included:
- `form_screen.dart`: A reference implementation of a basic form with validation.
- `order_state_example.dart`: Snippet showing how to receive data back from the form using `setState`.
