# this script attempts to pull all google drive links out of the specified Google site by crawling the html code on each page
# it recursively checks all pages for links and produces a csv

import requests
from bs4 import BeautifulSoup
from urllib.parse import urljoin, urlparse
import csv

# Set of visited URLs to avoid revisiting
visited = set()

# List to store document links and their source pages
document_links = []

# Function to check if a URL is a Google document link
def is_google_doc(url):
    return any(domain in url for domain in [
        "docs.google.com/document",
        "docs.google.com/spreadsheets",
        "docs.google.com/presentation",
        "drive.google.com",
    ])

# Recursive function to crawl pages
def crawl(url, base_domain):
    if url in visited or '#' in url:
        return
    visited.add(url)

    try:
        response = requests.get(url)
        soup = BeautifulSoup(response.text, 'html.parser')

        # Extract all anchor tags
        for a_tag in soup.find_all('a', href=True):
            href = a_tag['href']
            full_url = urljoin(url, href)

            # Ignore anchor links
            if '#' in full_url:
                continue

            # Check for Google document links
            if is_google_doc(full_url):
                document_links.append((full_url, url))

            # Check if the link is within the same site
            elif base_domain in urlparse(full_url).netloc and full_url not in visited:
                crawl(full_url, base_domain)

        for iframe in soup.find_all('iframe'): # links in iframes may not be retrieved if content is generated dynamically with js
            href = a_tag['href']
            full_url = urljoin(url, href)

            # Ignore anchor links
            if '#' in full_url:
                continue

            # Check for Google document links
            if is_google_doc(full_url):
                document_links.append((full_url, url))

            # Check if the link is within the same site
            elif base_domain in urlparse(full_url).netloc and full_url not in visited:
                crawl(full_url, base_domain)

    except Exception as e:
        print(f"Failed to crawl {url}: {e}")

# Starting URL of the Google Site
start_url = "https://sites.google.com/<domain>.com/<site>"
base_domain = urlparse(start_url).netloc

# Start crawling
crawl(start_url, base_domain)

# Write results to CSV
with open("links.csv", "w", newline="") as csvfile:
    writer = csv.writer(csvfile)
    writer.writerow(["Document Link", "Found On Page"])
    writer.writerows(document_links)

print(f"Found {len(document_links)} Google document links. Results saved to links.csv.")
