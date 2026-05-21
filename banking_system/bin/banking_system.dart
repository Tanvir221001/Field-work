import 'dart:io';

class Account {
  int accountNumber;
  String holderName;
  double balance;

  Account(this.accountNumber, this.holderName, this.balance);

  void deposit(double amount) {
    if (amount > 0) {
      balance += amount;
      print("Deposit Successful!");
    } else {
      print("Invalid Amount!");
    }
  }

  void withdraw(double amount) {
    if (amount > balance) {
      print("Insufficient Balance!");
    } else if (amount <= 0) {
      print("Invalid Amount!");
    } else {
      balance -= amount;
      print("Withdrawal Successful!");
    }
  }

  void showDetails() {
    print("\n----- Account Details -----");
    print("Account Number : $accountNumber");
    print("Account Holder : $holderName");
    print("Balance         : \$${balance.toStringAsFixed(2)}");
  }
}

class Bank {
  List<Account> accounts = [];

  void createAccount(int accNo, String name, double balance) {
    Account account = Account(accNo, name, balance);
    accounts.add(account);
    print("Account Created Successfully!");
  }

  Account? findAccount(int accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    return null;
  }

  void showAllAccounts() {
    if (accounts.isEmpty) {
      print("No Accounts Found!");
    } else {
      for (var acc in accounts) {
        acc.showDetails();
      }
    }
  }
}

void main() {
  Bank bank = Bank();

  while (true) {
    print("\n====== Banking System ======");
    print("1. Create Account");
    print("2. Deposit Money");
    print("3. Withdraw Money");
    print("4. Check Account");
    print("5. Show All Accounts");
    print("6. Exit");

    stdout.write("Enter Your Choice: ");
    int choice = int.parse(stdin.readLineSync()!);

    switch (choice) {
      case 1:
        stdout.write("Enter Account Number: ");
        int accNo = int.parse(stdin.readLineSync()!);

        stdout.write("Enter Account Holder Name: ");
        String name = stdin.readLineSync()!;

        stdout.write("Enter Initial Balance: ");
        double balance = double.parse(stdin.readLineSync()!);

        bank.createAccount(accNo, name, balance);
        break;

      case 2:
        stdout.write("Enter Account Number: ");
        int accNo = int.parse(stdin.readLineSync()!);

        Account? account = bank.findAccount(accNo);

        if (account != null) {
          stdout.write("Enter Deposit Amount: ");
          double amount = double.parse(stdin.readLineSync()!);

          account.deposit(amount);
        } else {
          print("Account Not Found!");
        }
        break;

      case 3:
        stdout.write("Enter Account Number: ");
        int accNo = int.parse(stdin.readLineSync()!);

        Account? account = bank.findAccount(accNo);

        if (account != null) {
          stdout.write("Enter Withdraw Amount: ");
          double amount = double.parse(stdin.readLineSync()!);

          account.withdraw(amount);
        } else {
          print("Account Not Found!");
        }
        break;

      case 4:
        stdout.write("Enter Account Number: ");
        int accNo = int.parse(stdin.readLineSync()!);

        Account? account = bank.findAccount(accNo);

        if (account != null) {
          account.showDetails();
        } else {
          print("Account Not Found!");
        }
        break;

      case 5:
        bank.showAllAccounts();
        break;

      case 6:
        print("Thank You for Using Banking System!");
        exit(0);

      default:
        print("Invalid Choice!");
    }
  }
}