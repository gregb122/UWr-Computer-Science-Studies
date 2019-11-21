from typing import List

import bs4
import requests
import re
import threading

from time import time


class Crawler:
    """
    Web Crawler for processing http/https pages using predefined user actions. Multi-threaded version
    """
    crawl_results = {}

    def __init__(self):
        self.soup = None
        self.visited_pages = set()
        self.threads = []

    def crawl(self, start_page: str, distance: int, action: str):
        """
        Call :py:func:`self._crawl` and manage threads created by this function:
        Start and wait for all.
        """
        self._crawl(start_page, distance, action)
        for t in self.threads:
            t.start()
        for t in self.threads:
            if t.isAlive():
                t.join()
        self.threads.clear()

    def _crawl(self, start_page: str, distance: int, action: str):
        """
        Collect jobs of processing web pages in DFS order:
        1. Start from start_page and perform action
        2. Visit all links of this page (call this function recursively with distance - 1)
        3. Perform an action for each visited page
        4. Repeat until distance > 0
        :param start_page:      Starting point of crawling, root page.
        :param distance:        Maximum recursion depth of crawl
        :param action:          Predefined user action
        :return:                Generator which single step is a URL of visited page and action result
        """
        if distance == 0:
            return
        if start_page not in self.visited_pages:
            if start_page.startswith('http'):
                page = requests.get(start_page)
                self.soup = bs4.BeautifulSoup(page.content, 'html.parser')
                self.visited_pages.add(start_page)
                expr_result = eval(f"self.{action}")
                self.crawl_results[start_page] = expr_result
                for link in self.soup.find_all('a'):
                    th = threading.Thread(target=self._crawl, args=(link.get('href'), distance - 1, action))
                    self.threads.append(th)

    def find_sentences_with_word(self, word: str) -> List[str]:
        """
        Extract sentences containing :param word from parsed html page (called as 'soup').
        Remove all sentences placed in non-body specific html tags.
        :return:        Sentences which contain :param word
        """
        for element in self.soup(["script", "style", "head"]):
            element.decompose()
        return [sentence.strip(' ') for sentence in re.split(r"[\n][\s]?|[\.][\s]", self.soup.get_text()) if word in
                sentence]


crawler = Crawler()

start = time()
crawler.crawl("https://www.python.org/", 4, "find_sentences_with_word('Python')")
end = time()

for key in crawler.crawl_results:
    print(key, crawler.crawl_results[key])

print("TOTAL TIME EXECUTION THREAD: ", round(end - start, 4), " SECONDS")
