#!/bin/bash

echo "=================================="
echo "  Hospital App - IP Update Script"
echo "=================================="
echo ""

# Ask user for new IP
read -p "Enter your NEW EC2 public IP (example: 54.166.179.110): " NEW_IP

if [ -z "$NEW_IP" ]; then
  echo "❌ No IP entered. Exiting."
  exit 1
fi

echo ""
echo "Updating frontend code to use IP: $NEW_IP ..."

cd ~/hospital-management-system-docker/frontend/src || exit 1

# Replace any old IP pattern (X.X.X.X:5000) with the new IP
grep -rlE "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:5000" . | \
xargs sed -i -E "s/[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:5000/$NEW_IP:5000/g"

echo "✅ Frontend code updated."
echo ""

cd ~/hospital-management-system-docker || exit 1

echo "Rebuilding frontend container (this may take a minute)..."
docker-compose down
docker-compose build --no-cache frontend
docker-compose up -d

echo ""
echo "Checking running containers..."
docker ps

echo ""
echo "=================================="
echo "✅ DONE! Your app should now work at:"
echo "   http://$NEW_IP:3000"
echo "=================================="
echo ""

read -p "Do you want to commit this IP change to Git? (y/n): " DO_COMMIT

if [ "$DO_COMMIT" = "y" ]; then
  cd ~/hospital-management-system-docker
  git add frontend/src
  git commit -m "Update frontend to use new EC2 IP: $NEW_IP"
  git push origin main
  echo "✅ Changes pushed to GitHub."
else
  echo "Skipped Git commit."
fi
