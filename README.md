# Grocery App
[![Ask DeepWiki](https://devin.ai/assets/askdeepwiki.png)](https://deepwiki.com/m7md3bbas/Grocery_App)

A full-featured grocery shopping application built with Flutter and backed by Supabase. This app provides a complete e-commerce experience, from user authentication and product browsing to order placement and payment processing with Stripe.

## Features

- **User Authentication:** Secure sign-up, login, and Google Sign-In functionality.
- **Product Discovery:** Browse products through categories, view detailed product information, and use a robust search feature.
- **Shopping Cart:** Add, remove, and update the quantity of items in the cart.
- **Favorites:** Save products to a personal favorites list for quick access.
- **Order Management:** Place orders, view order history, check order status, and cancel pending orders.
- **Payment Integration:** Seamless checkout process powered by Stripe.
- **User Profile:** Manage personal details, including name, email, phone number, and profile picture uploads.
- **MVVM Architecture:** Clean and scalable codebase following the Model-View-ViewModel pattern.

## Tech Stack & Architecture

- **Framework:** Flutter
- **Architecture:** MVVM (Model-View-ViewModel)
- **State Management:** [Provider](https://pub.dev/packages/provider)
- **Backend:** [Supabase](https://supabase.io/) (Authentication, Database, Storage)
- **Routing:** [GoRouter](https://pub.dev/packages/go_router)
- **HTTP Client:** [Dio](https://pub.dev/packages/dio)
- **Dependency Injection:** [GetIt](https://pub.dev/packages/get_it)
- **Payment Gateway:** [Stripe](https://stripe.com/) (`flutter_stripe`)

## Project Structure

The project is organized into a clean and scalable structure to facilitate development and maintenance.

- `lib/core`: Contains the application's core logic, including:
  - `repos`: Repositories that abstract data sources.
  - `service`: Services for interacting with external APIs (Supabase, Stripe).
  - `routes`: Application routing configuration using GoRouter.
  - `utils`: Shared utilities, constants, dependency injection setup, and custom widgets.
- `lib/features`: Contains the UI and ViewModel for each distinct feature of the app, such as Authentication, Home, Cart, Profile, etc. Each feature folder follows the MVVM pattern with `model`, `view`, and `viewmodel` subdirectories.

## Getting Started

To get a local copy up and running, follow these simple steps.

### Prerequisites

- Flutter SDK installed on your machine.
- A Supabase project.
- A Stripe account.

### Installation

1.  **Clone the repository:**
    ```sh
    git clone https://github.com/m7md3bbas/Grocery_App.git
    cd Grocery_App
    ```

2.  **Create a `.env` file** in the root of the project and add your Supabase and Stripe credentials:
    ```env
    SUPABASE_URL=YOUR_SUPABASE_URL
    SUPABASE_KEY=YOUR_SUPABASE_ANON_KEY
    GoogleClintID=YOUR_GOOGLE_CLIENT_ID
    PublishableKey=YOUR_STRIPE_PUBLISHABLE_KEY
    secretKey=YOUR_STRIPE_SECRET_KEY
    ```

3.  **Install dependencies:**
    ```sh
    flutter pub get
    ```

4.  **Run the app:**
    ```sh
    flutter run
