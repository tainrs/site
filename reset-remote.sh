#!/bin/bash

#
#  _______ _______ _____ __   _  ______ _______
#     |    |_____|   |   | \  | |_____/ |______
#     |    |     | __|__ |  \_| |    \_ ______|
#

# The  deploy.sh  script deletes the gh-pages branch on the remote repository,
# deletes the local gh-pages branch, creates a new local gh-pages branch,
# and then pushes the new local gh-pages branch to the remote repository.

# Delete the gh-pages branch on the remote repository
echo "Deleting the gh-pages branch on the remote repository..."
git push origin --delete gh-pages
if [ $? -ne 0 ]; then
    echo "Failed to delete the remote gh-pages branch."
    exit 1
fi

# Delete the local gh-pages branch
echo "Deleting the local gh-pages branch..."
git branch -D gh-pages
if [ $? -ne 0 ]; then
    echo "Failed to delete the local gh-pages branch."
    exit 1
fi

# Output the completion message
echo ""
echo " ---------------------------------------------------"
echo "   _______ _______ _____ __   _  ______ _______"
echo "      |    |_____|   |   | \  | |_____/ |______"
echo "      |    |     | __|__ |  \_| |    \_ ______|"
echo ""
echo " ---------------------------------------------------"
echo "The 'gh-pages' branch has been successfully reset."
echo ""
