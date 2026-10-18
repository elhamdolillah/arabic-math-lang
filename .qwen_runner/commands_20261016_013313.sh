ps aux | grep -i chrom | grep -v grep
echo "---XVFB---"
ps aux | grep Xvfb | grep -v grep
echo "---CHROME LOG---"
tail -30 /tmp/chrome.log
