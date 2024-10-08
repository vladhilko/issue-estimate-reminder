# README

## Screen Recording

![Application Demo](./screenrecords/screen-recording.gif)

## Prerequisites

- **Ruby 3.3.0**

The application requires Ruby version **3.3.0**. Please ensure you have this version installed before proceeding.

## Testing

To run the test suite, execute:

```bash
bundle exec rspec
```

## Initial Setup

Note: Ensure that you have completed Step 1 and Step 2 before proceeding. This includes creating the GitHub App, setting up the webhook URL, and generating the necessary credentials.

Clone the repository and set up the application.

### 1. Clone the Repository

```bash
git clone https://github.com/vladhilko/issue-estimate-reminder.git
cd issue-estimate-reminder
```

### 2. Install Dependencies

```bash
bundle install
```

### 3. Add Environment Variables and Private Key

Copy your environment variables and private key from Step 1 into the project directory.

- Create a `.env` File:
  - In the root of the project directory, create a file named .env and add the following content:
  ```bash
  APP_ID=your_app_id
  WEBHOOK_SECRET=your_webhook_secret
  PRIVATE_KEY_PATH=./private-key.pem
  ```
  - Replace your_app_id and your_webhook_secret with the actual values obtained in Step 1.
- Place Your Private Key:
  - Copy the private-key.pem file downloaded in Step 1 into the root of the project directory.

### 4. Run the Application

Start the Smee client and the application to begin receiving webhook events.

- Run the Smee Client:
  - Replace https://smee.io/your-unique-channel with your actual Smee.io URL from Step 1.
  ```bash
  smee --url https://smee.io/your-unique-channel --target http://127.0.0.1:3000/
  ```
- Run the Application:
  - In a new terminal window, start the Sinatra application:
  ```bash
  ruby app/app.rb
  ```

## Step 1: Create a GitHub App

### 1. Access GitHub Developer Settings

- **Log in to GitHub:**
  - Navigate to [github.com](https://github.com/) and sign in to your account.

- **Go to Developer Settings:**
  - Click on your profile picture in the top-right corner.
  - Select **"Settings"** from the dropdown menu.
  - In the left sidebar, scroll down and click on **"Developer settings"**.

### 2. Create a New GitHub App

- **Select "GitHub Apps":**
  - In the **Developer settings**, click on **"GitHub Apps"**.

- **Create a New App:**
  - Click the **"New GitHub App"** button.

### 3. Configure Your GitHub App

- **GitHub App Name:**
  - Enter a unique name for your app. For example: `Issue Estimate Reminder`.

- **Description (Optional):**
  - Provide a brief description of what your app does.

- **Homepage URL:**
  - Enter the URL of your application's homepage or repository. Example:
    ```
    https://github.com/yourusername/issue-estimate-reminder
    ```

- **Webhook URL:**

Generate a Webhook Proxy URL with Smee.io

- Visit Smee.io
  - Open https://smee.io/ in your browser.
- Create a New Channel
  - Click on "Start a new channel".
  - A unique URL will be generated, e.g., https://smee.io/your-unique-channel.
  - Copy this URL.
  - Paste it into the **"Webhook URL"** field.

- **Webhook Secret:**
  - Generate a secret token to secure your webhook events.
    - You can generate a secret using the following command in your terminal:
      ```bash
      openssl rand -hex 20
      ```
    - Copy the generated secret and paste it into the **"Webhook secret"** field.
    - **Important:** Save this secret securely; you will need it later in your application.

- **Repository Permissions:**
  - Scroll down to **"Repository permissions"**.
  - Find **"Issues"** and set the access to **"Read & Write"**.

- **Subscribe to Events:**
  - Under **"Subscribe to events"**, check the box for **"Issues"**.

- **Where can this GitHub App be installed?:**
  - Choose **"Only on this account"** if you're installing the app on your repositories.
  - Alternatively, select **"Any account"** if you plan to make the app available to others.

### 4. Create the GitHub App

- **Review Your Settings:**
  - Double-check all the information you've entered.

- **Create the App:**
  - Scroll to the bottom of the page and click **"Create GitHub App"**.

### 5. Generate and Download the Private Key

- **Generate Private Key:**
  - On your new app's page, find the **"Private keys"** section.
  - Click on **"Generate a private key"**.
  - A `.pem` file will be downloaded to your computer.

- **Store the Private Key Securely:**
  - Move the `.pem` file to your project's root directory.
  - **Do Not Commit:** Ensure this file is listed in your `.gitignore` to prevent it from being committed to version control.

### 6. Install the GitHub App on Your Repository

- **Navigate to Installation Page:**
  - In the left sidebar of your app's page, click **"Install App"**.

- **Install the App:**
  - Click on the **"Install"** button next to your account or organization.

- **Select Repositories:**
  - Choose **"Only select repositories"**.
  - Select the repository where you want to install the app.

- **Confirm Installation:**
  - Click **"Install"** at the bottom to confirm.

### 7. Record Essential Information

- **App ID:**
  - Note down your **App ID** displayed at the top of the app's page.

- **Webhook Secret:**
  - Ensure you have your webhook secret saved from earlier.

- **Private Key Path:**
  - Note the relative path to your `.pem` file in your project directory. Example:
    ```
    ./private-key.pem
    ```

- **Environment Variables:**
  - You will need to set the following environment variables in your application:
    - `APP_ID`: Your GitHub App's App ID.
    - `WEBHOOK_SECRET`: The webhook secret you generated.
    - `PRIVATE_KEY_PATH`: The path to your `.pem` file.

### 8. Update Your `.env` File

- **Create a `.env` File:**
  - In your project's root directory, create a file named `.env`.

- **Add the Following Variables:**
  ```dotenv
  APP_ID=your_app_id
  WEBHOOK_SECRET=your_webhook_secret
  PRIVATE_KEY_PATH=./private-key.pem
  ```

  - Replace `your_app_id` with the App ID from GitHub.
  - Replace `your_webhook_secret` with the secret you generated.


## Step 2: Set Up Webhook Proxy with Smee.io

- Install and run the Smee client using the Smee.io URL generated in Step 1:

```bash
npm install --global smee-client
smee --url https://smee.io/your-unique-channel --target http://127.0.0.1:3000/
```

- Replace https://smee.io/your-unique-channel with your actual Smee.io URL from Step 1.

- Keep this terminal window open to continue forwarding webhooks to your local application.
