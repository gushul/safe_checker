# How to setup the project

git clone reopository
cd safe-cracker

# Install dependencies
./bin/setup

# Run
./bin/safe_cracker

# Example Usage

Enter N (number of dials, 1-6): 3
Enter beginning state (3 digits separated by space): 0 0 0
Enter target state (3 digits separated by space): 1 1 1
Enter the number of restricted combinations: 2
Enter restricted combination 1 (3 digits separated by space): 0 0 1
Enter restricted combination 2 (3 digits separated by space): 1 0 0

Solution finded:
[0, 0, 0]
[0, 1, 0]
[1, 1, 0]
[1, 1, 1]
